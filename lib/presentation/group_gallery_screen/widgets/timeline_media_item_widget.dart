import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TimelineMediaItemWidget extends StatelessWidget {
  final Map<String, dynamic> mediaItem;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isUploading;

  const TimelineMediaItemWidget({
    Key? key,
    required this.mediaItem,
    required this.onTap,
    required this.onLongPress,
    this.isUploading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isVideo = (mediaItem['type'] as String) == 'video';
    final String thumbnailUrl = mediaItem['thumbnailUrl'] as String;
    final String uploaderName = mediaItem['uploaderName'] as String;
    final String uploadTime = mediaItem['uploadTime'] as String;
    final double uploadProgress =
        (mediaItem['uploadProgress'] as double?) ?? 0.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 5.w,
                  backgroundImage:
                      NetworkImage(mediaItem['uploaderAvatar'] as String),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        uploaderName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        uploadTime,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                if (isUploading)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Uploading...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Container(
              height: 50.h,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    child: CustomImageWidget(
                      imageUrl: thumbnailUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (isVideo)
                    Positioned(
                      left: 50.w - 4.w,
                      top: 25.h - 4.w,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'play_arrow',
                          color: Colors.white,
                          size: 8.w,
                        ),
                      ),
                    ),
                  if (isVideo)
                    Positioned(
                      bottom: 3.w,
                      right: 3.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 1.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          mediaItem['duration'] as String? ?? '0:00',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                  ),
                        ),
                      ),
                    ),
                  if (isUploading)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 12.w,
                              height: 12.w,
                              child: CircularProgressIndicator(
                                value: uploadProgress,
                                strokeWidth: 3,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '${(uploadProgress * 100).toInt()}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}