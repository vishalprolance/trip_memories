import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DatePickerWidget extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?) onStartDateChanged;
  final Function(DateTime?) onEndDateChanged;

  const DatePickerWidget({
    Key? key,
    this.startDate,
    this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
  }) : super(key: key);

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: AppTheme.lightTheme,
          child: child!,
        );
      },
    );

    if (picked != null && picked != widget.startDate) {
      widget.onStartDateChanged(picked);

      // If end date is before start date, clear it
      if (widget.endDate != null && widget.endDate!.isBefore(picked)) {
        widget.onEndDateChanged(null);
      }
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime firstDate = widget.startDate ?? DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.endDate ?? firstDate.add(Duration(days: 1)),
      firstDate: firstDate,
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: AppTheme.lightTheme,
          child: child!,
        );
      },
    );

    if (picked != null && picked != widget.endDate) {
      widget.onEndDateChanged(picked);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trip Dates',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _selectStartDate,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'calendar_today',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Date',
                              style: AppTheme.lightTheme.textTheme.labelSmall,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              _formatDate(widget.startDate),
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: widget.startDate != null
                                    ? AppTheme.lightTheme.colorScheme.onSurface
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: GestureDetector(
                onTap: widget.startDate != null ? _selectEndDate : null,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.startDate != null
                          ? AppTheme.lightTheme.colorScheme.outline
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.5),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'calendar_today',
                        color: widget.startDate != null
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.5),
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End Date',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: widget.startDate != null
                                    ? AppTheme
                                        .lightTheme.colorScheme.onSurfaceVariant
                                    : AppTheme
                                        .lightTheme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.5),
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              _formatDate(widget.endDate),
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: widget.endDate != null
                                    ? AppTheme.lightTheme.colorScheme.onSurface
                                    : widget.startDate != null
                                        ? AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant
                                        : AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant
                                            .withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
