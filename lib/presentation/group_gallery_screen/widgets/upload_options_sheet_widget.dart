import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UploadOptionsSheetWidget extends StatelessWidget {
  final VoidCallback onTakePhoto;
  final VoidCallback onTakeVideo;
  final VoidCallback onChooseFromLibrary;
  final VoidCallback onBulkUpload;

  const UploadOptionsSheetWidget({
    Key? key,
    required this.onTakePhoto,
    required this.onTakeVideo,
    required this.onChooseFromLibrary,
    required this.onBulkUpload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Add to Gallery',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 3.h),
          _buildOptionItem(
            context,
            icon: 'camera_alt',
            title: 'Take Photo',
            subtitle: 'Capture a new photo',
            onTap: onTakePhoto,
          ),
          SizedBox(height: 2.h),
          _buildOptionItem(
            context,
            icon: 'videocam',
            title: 'Take Video',
            subtitle: 'Record a new video',
            onTap: onTakeVideo,
          ),
          SizedBox(height: 2.h),
          _buildOptionItem(
            context,
            icon: 'photo_library',
            title: 'Choose from Library',
            subtitle: 'Select from your photos',
            onTap: onChooseFromLibrary,
          ),
          SizedBox(height: 2.h),
          _buildOptionItem(
            context,
            icon: 'cloud_upload',
            title: 'Bulk Upload',
            subtitle: 'Upload multiple files',
            onTap: onBulkUpload,
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildOptionItem(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }
}
