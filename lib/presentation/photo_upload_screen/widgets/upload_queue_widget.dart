import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UploadQueueWidget extends StatelessWidget {
  final List<Map<String, dynamic>> uploadQueue;
  final bool isUploading;
  final bool uploadOnWifiOnly;
  final Function(bool) onWifiToggle;
  final VoidCallback onStartUpload;
  final VoidCallback onRemoveAll;
  final Function(String) onRemoveItem;

  const UploadQueueWidget({
    Key? key,
    required this.uploadQueue,
    required this.isUploading,
    required this.uploadOnWifiOnly,
    required this.onWifiToggle,
    required this.onStartUpload,
    required this.onRemoveAll,
    required this.onRemoveItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (uploadQueue.isEmpty) return SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upload Queue (${uploadQueue.length})',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: onRemoveAll,
                      child: Text(
                        'Remove All',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                _buildUploadSettings(),
                SizedBox(height: 2.h),
                _buildEstimatedInfo(),
                SizedBox(height: 2.h),
                _buildUploadList(),
                SizedBox(height: 2.h),
                _buildUploadButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSettings() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'wifi',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload on WiFi only',
                  style: AppTheme.lightTheme.textTheme.titleSmall,
                ),
                Text(
                  'Save mobile data usage',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: uploadOnWifiOnly,
            onChanged: onWifiToggle,
          ),
        ],
      ),
    );
  }

  Widget _buildEstimatedInfo() {
    final totalSize = uploadQueue.fold<double>(
      0.0,
      (sum, item) => sum + (item['sizeInMB'] as double),
    );

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Size',
                style: AppTheme.lightTheme.textTheme.labelMedium,
              ),
              Text(
                '${totalSize.toStringAsFixed(1)} MB',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Est. Time',
                style: AppTheme.lightTheme.textTheme.labelMedium,
              ),
              Text(
                '${(totalSize / 2).ceil()} min',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadList() {
    return Container(
      constraints: BoxConstraints(maxHeight: 30.h),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: uploadQueue.length,
        separatorBuilder: (context, index) => SizedBox(height: 1.h),
        itemBuilder: (context, index) {
          final item = uploadQueue[index];
          return Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CustomImageWidget(
                    imageUrl: item['thumbnail'],
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: AppTheme.lightTheme.textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${item['sizeInMB'].toStringAsFixed(1)} MB',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (isUploading && item['progress'] != null)
                        Column(
                          children: [
                            SizedBox(height: 1.h),
                            LinearProgressIndicator(
                              value: item['progress'] / 100,
                              backgroundColor:
                                  AppTheme.lightTheme.colorScheme.outline,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              '${item['progress']}%',
                              style: AppTheme.lightTheme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => onRemoveItem(item['id']),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 5.w,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUploadButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isUploading ? null : onStartUpload,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 2.h),
        ),
        child: isUploading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 5.w,
                    height: 5.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text('Uploading...'),
                ],
              )
            : Text('Start Upload'),
      ),
    );
  }
}
