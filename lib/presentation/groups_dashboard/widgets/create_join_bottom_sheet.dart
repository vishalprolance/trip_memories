import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CreateJoinBottomSheet extends StatelessWidget {
  final VoidCallback onCreateGroup;
  final VoidCallback onJoinWithCode;
  final VoidCallback onScanQR;

  const CreateJoinBottomSheet({
    Key? key,
    required this.onCreateGroup,
    required this.onJoinWithCode,
    required this.onScanQR,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Text(
              'Trip Groups',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          // Options
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                // Create Group
                _buildOptionTile(
                  context: context,
                  icon: 'add_circle_outline',
                  title: 'Create Group',
                  subtitle: 'Start a new trip group and invite friends',
                  onTap: () {
                    Navigator.pop(context);
                    onCreateGroup();
                  },
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                SizedBox(height: 1.h),
                // Join with Code
                _buildOptionTile(
                  context: context,
                  icon: 'vpn_key',
                  title: 'Join with Code',
                  subtitle: 'Enter a group code to join an existing trip',
                  onTap: () {
                    Navigator.pop(context);
                    onJoinWithCode();
                  },
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
                SizedBox(height: 1.h),
                // Scan QR Code
                _buildOptionTile(
                  context: context,
                  icon: 'qr_code_scanner',
                  title: 'Scan QR Code',
                  subtitle: 'Scan a QR code to quickly join a group',
                  onTap: () {
                    Navigator.pop(context);
                    onScanQR();
                  },
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: color,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow Icon
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
