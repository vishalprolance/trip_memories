import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SmartSelectionWidget extends StatelessWidget {
  final VoidCallback onSelectAllToday;
  final VoidCallback onSelectRecentTrip;
  final VoidCallback onSelectAll;

  const SmartSelectionWidget({
    Key? key,
    required this.onSelectAllToday,
    required this.onSelectRecentTrip,
    required this.onSelectAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Select',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: _buildSelectionButton(
                  'Today',
                  CustomIconWidget(
                    iconName: 'today',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  onSelectAllToday,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildSelectionButton(
                  'Recent Trip',
                  CustomIconWidget(
                    iconName: 'location_on',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  onSelectRecentTrip,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildSelectionButton(
                  'Select All',
                  CustomIconWidget(
                    iconName: 'select_all',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  onSelectAll,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionButton(String label, Widget icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            icon,
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                fontSize: 10.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
