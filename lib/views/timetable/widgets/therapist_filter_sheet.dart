import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';
import '../../../providers/schedule_provider.dart';
import '../../../providers/therapist_provider.dart';
import 'package:provider/provider.dart';

class TherapistFilterSheet extends StatefulWidget {
  final ScheduleProvider scheduleProvider;

  const TherapistFilterSheet({
    Key? key,
    required this.scheduleProvider,
  }) : super(key: key);

  @override
  State<TherapistFilterSheet> createState() => _TherapistFilterSheetState();
}

class _TherapistFilterSheetState extends State<TherapistFilterSheet> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TherapistProvider>(
      builder: (context, therapistProvider, _) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppTheme.radius16),
              topRight: Radius.circular(AppTheme.radius16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 헤더
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200]!,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '선생님 필터',
                      style: AppTheme.headingSmall,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // 전체 선택/해제
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          widget.scheduleProvider.selectAllTherapists();
                        },
                        child: const Text('전체 선택'),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          widget.scheduleProvider.deselectAllTherapists();
                        },
                        child: const Text('전체 해제'),
                      ),
                    ),
                  ],
                ),
              ),

              // 선생님 목록
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: therapistProvider.therapists.length,
                  itemBuilder: (context, index) {
                    final therapist = therapistProvider.therapists[index];
                    final isSelected =
                        widget.scheduleProvider.therapistFilter[therapist.uid] ??
                            false;
                    final color =
                        widget.scheduleProvider.therapistColorMap[therapist.uid];

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing16,
                        vertical: AppTheme.spacing12,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[100]!,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // 색상 표시
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: color ?? Colors.grey,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radius4),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacing12),

                          // 선생님 이름
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  therapist.name,
                                  style: AppTheme.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  therapist.email,
                                  style: AppTheme.bodySmall.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 체크박스
                          Checkbox(
                            value: isSelected,
                            onChanged: (_) {
                              widget.scheduleProvider
                                  .toggleTherapistFilter(therapist.uid);
                            },
                            activeColor: AppTheme.primary,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // 닫기 버튼
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                    ),
                    child: const Text(
                      '적용',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
