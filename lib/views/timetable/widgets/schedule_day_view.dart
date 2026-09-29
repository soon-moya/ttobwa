import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';
import '../../../models/models.dart';
import 'package:intl/intl.dart';

class ScheduleDayView extends StatelessWidget {
  final DateTime date;
  final List<Schedule> schedules;
  final Map<String, Color> therapistColorMap;

  const ScheduleDayView({
    Key? key,
    required this.date,
    required this.schedules,
    required this.therapistColorMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 날짜 헤더
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.spacing16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[200]!,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('yyyy년 M월 d일 (E)', 'ko_KR').format(date),
                style: AppTheme.headingMedium,
              ),
              const SizedBox(height: AppTheme.spacing4),
              Text(
                '총 ${schedules.length}개의 일정',
                style: AppTheme.bodySmall.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        // 일정 리스트
        if (schedules.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 48,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  Text(
                    '이 날짜의 일정이 없습니다.',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacing12),
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                final color = therapistColorMap[schedule.therapistId] ??
                    AppTheme.primary;

                return _ScheduleCard(
                  schedule: schedule,
                  color: color,
                );
              },
            ),
          ),
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final Schedule schedule;
  final Color color;

  const _ScheduleCard({
    Key? key,
    required this.schedule,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: color,
            width: 4,
          ),
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radius8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 시간
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: AppTheme.spacing8),
                Text(
                  '${_formatTime(schedule.startTime)} - ${_formatTime(schedule.endTime)}',
                  style: AppTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const Spacer(),
                // 상태 배지
                _StatusBadge(status: schedule.status),
              ],
            ),

            const SizedBox(height: AppTheme.spacing8),

            // 치료 내용
            Text(
              schedule.therapyType,
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: AppTheme.spacing4),

            // 원생 이름
            Text(
              '${schedule.childName} (${schedule.therapistName})',
              style: AppTheme.bodySmall.copyWith(
                color: Colors.grey[600],
              ),
            ),

            if (schedule.memo != null && schedule.memo!.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spacing8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacing8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(AppTheme.radius4),
                ),
                child: Text(
                  schedule.memo!,
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return time;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final (backgroundColor, textColor, label) = _getStatusStyle();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing8,
        vertical: AppTheme.spacing4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radius4),
      ),
      child: Text(
        label,
        style: AppTheme.bodySmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (Color, Color, String) _getStatusStyle() {
    switch (status) {
      case 'completed':
        return (
          AppTheme.accent.withOpacity(0.1),
          AppTheme.accent,
          '완료',
        );
      case 'pending':
        return (
          AppTheme.warning.withOpacity(0.1),
          AppTheme.warning,
          '예정',
        );
      case 'cancelled':
        return (
          AppTheme.error.withOpacity(0.1),
          AppTheme.error,
          '취소',
        );
      default:
        return (
          Colors.grey[200]!,
          Colors.grey[600]!,
          '미정',
        );
    }
  }
}
