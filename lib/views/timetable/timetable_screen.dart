import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../config/app_theme.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/therapist_provider.dart';
import '../../models/models.dart';
import './widgets/therapist_filter_sheet.dart';
import './widgets/schedule_day_view.dart';

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({Key? key}) : super(key: key);

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    // 일정 및 선생님 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadData() {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    
    if (user != null && user.centerId!.isNotEmpty) {
      // 선생님 목록 로드
      context.read<TherapistProvider>().loadTherapists(user.centerId!);
      
      // 일정 로드 (모든 선생님)
      context.read<ScheduleProvider>().initializeSchedules(
        centerId: user.centerId!,
        therapistIds: [], // 나중에 선생님 목록이 로드되면 업데이트됨
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일정'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // 필터 버튼
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _showTherapistFilter,
          ),
        ],
      ),
      body: Consumer<ScheduleProvider>(
        builder: (context, scheduleProvider, _) {
          if (scheduleProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (scheduleProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppTheme.error,
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  Text(scheduleProvider.error!),
                  const SizedBox(height: AppTheme.spacing16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // 달력
              _buildCalendar(scheduleProvider),
              
              const Divider(height: 1),
              
              // 선택된 날짜의 일정
              Expanded(
                child: _buildScheduleList(scheduleProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 달력 빌드
  Widget _buildCalendar(ScheduleProvider scheduleProvider) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing12),
      child: Column(
        children: [
          // 월 네비게이션
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
              vertical: AppTheme.spacing8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    final newMonth = DateTime(
                      scheduleProvider.currentMonth.year,
                      scheduleProvider.currentMonth.month - 1,
                    );
                    final authProvider = context.read<AuthProvider>();
                    final user = authProvider.currentUser;
                    if (user != null && user.centerId!.isNotEmpty) {
                      scheduleProvider.changeMonth(newMonth, user.centerId!);
                    }
                  },
                ),
                Text(
                  '${scheduleProvider.currentMonth.year}년 ${scheduleProvider.currentMonth.month}월',
                  style: AppTheme.headingSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    final newMonth = DateTime(
                      scheduleProvider.currentMonth.year,
                      scheduleProvider.currentMonth.month + 1,
                    );
                    final authProvider = context.read<AuthProvider>();
                    final user = authProvider.currentUser;
                    if (user != null && user.centerId!.isNotEmpty) {
                      scheduleProvider.changeMonth(newMonth, user.centerId!);
                    }
                  },
                ),
              ],
            ),
          ),
          
          // 요일 헤더
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing8,
              vertical: AppTheme.spacing8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _DayHeader('월'),
                _DayHeader('화'),
                _DayHeader('수'),
                _DayHeader('목'),
                _DayHeader('금'),
                _DayHeader('토'),
                _DayHeader('일'),
              ],
            ),
          ),
          
          // 달력 날짜
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing8),
            child: _buildCalendarGrid(scheduleProvider),
          ),
        ],
      ),
    );
  }

  /// 달력 그리드 빌드
  Widget _buildCalendarGrid(ScheduleProvider scheduleProvider) {
    final now = DateTime.now();
    final month = scheduleProvider.currentMonth;
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = lastDay.day;
    final startingWeekday = firstDay.weekday == 7 ? 0 : firstDay.weekday; // 월요일 = 0

    final children = <Widget>[];

    // 이전 달 빈 칸
    for (int i = 0; i < startingWeekday; i++) {
      children.add(const SizedBox());
    }

    // 현재 달 날짜
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(month.year, month.month, day);
      final count = scheduleProvider.getScheduleCountForDate(date);
      final isSelected = scheduleProvider.selectedDate.day == day &&
          scheduleProvider.selectedDate.month == month.month &&
          scheduleProvider.selectedDate.year == month.year;
      final isToday = date.day == now.day &&
          date.month == now.month &&
          date.year == now.year;

      children.add(
        _CalendarDay(
          day: day,
          scheduleCount: count,
          isSelected: isSelected,
          isToday: isToday,
          onTap: () {
            scheduleProvider.selectDate(date);
          },
        ),
      );
    }

    // 다음 달 빈 칸
    while (children.length % 7 != 0) {
      children.add(const SizedBox());
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppTheme.spacing8,
      crossAxisSpacing: AppTheme.spacing8,
      childAspectRatio: 1,
      children: children,
    );
  }

  /// 선택된 날짜의 일정 리스트
  Widget _buildScheduleList(ScheduleProvider scheduleProvider) {
    final schedules = scheduleProvider.getSchedulesForDate(
      scheduleProvider.selectedDate,
    );

    return ScheduleDayView(
      date: scheduleProvider.selectedDate,
      schedules: schedules,
      therapistColorMap: scheduleProvider.therapistColorMap,
    );
  }

  /// 선생님 필터 시트 표시
  void _showTherapistFilter() {
    showModalBottomSheet(
      context: context,
      builder: (_) => TherapistFilterSheet(
        scheduleProvider: context.read<ScheduleProvider>(),
      ),
    );
  }
}

/// 요일 헤더
class _DayHeader extends StatelessWidget {
  final String day;

  const _DayHeader(this.day);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          day,
          style: AppTheme.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}

/// 달력 날짜 셀
class _CalendarDay extends StatelessWidget {
  final int day;
  final int scheduleCount;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const _CalendarDay({
    required this.day,
    required this.scheduleCount,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary
              : isToday
                  ? Colors.blue[50]
                  : Colors.transparent,
          border: isToday
              ? Border.all(
                  color: AppTheme.primary,
                  width: 1,
                )
              : null,
          borderRadius: BorderRadius.circular(AppTheme.radius8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            if (scheduleCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: AppTheme.spacing4),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
