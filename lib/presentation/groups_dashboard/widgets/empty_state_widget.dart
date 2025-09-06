import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onCreateGroup;
  final VoidCallback onJoinGroup;

  const EmptyStateWidget({
    Key? key,
    required this.onCreateGroup,
    required this.onJoinGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 60.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circles for depth
                  Positioned(
                    top: 8.h,
                    left: 15.w,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 6.h,
                    right: 12.w,
                    child: Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.lightTheme.colorScheme.tertiary
                            .withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  // Main illustration elements
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Camera icon with photos
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'photo_camera',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 32,
                            ),
                            // Small photo cards around camera
                            Positioned(
                              top: 1.w,
                              right: 1.w,
                              child: Container(
                                width: 4.w,
                                height: 4.w,
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 1.w,
                              left: 1.w,
                              child: Container(
                                width: 4.w,
                                height: 4.w,
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),
                      // Connected users illustration
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildUserAvatar(
                              AppTheme.lightTheme.colorScheme.primary),
                          SizedBox(width: 2.w),
                          Container(
                            width: 6.w,
                            height: 0.3.h,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.outline,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          _buildUserAvatar(
                              AppTheme.lightTheme.colorScheme.tertiary),
                          SizedBox(width: 2.w),
                          Container(
                            width: 6.w,
                            height: 0.3.h,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.outline,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          _buildUserAvatar(
                              AppTheme.lightTheme.colorScheme.secondary),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            // Title
            Text(
              'Start Your First Trip',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            // Description
            Text(
              'Create a group to share photos and videos with friends and family during your adventures.',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            // Action Buttons
            Column(
              children: [
                // Create Group Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onCreateGroup,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'add',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Create Your First Group',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                // Join Group Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onJoinGroup,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'group_add',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Join Group',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar(Color color) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.2),
        border: Border.all(
          color: color,
          width: 2,
        ),
      ),
      child: CustomIconWidget(
        iconName: 'person',
        color: color,
        size: 16,
      ),
    );
  }
}
