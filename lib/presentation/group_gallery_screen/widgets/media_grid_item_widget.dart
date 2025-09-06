import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MediaGridItemWidget extends StatelessWidget {
  final Map<String, dynamic> mediaItem;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isUploading;

  const MediaGridItemWidget({
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
    final double uploadProgress =
        (mediaItem['uploadProgress'] as double?) ?? 0.0;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomImageWidget(
                imageUrl: thumbnailUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              if (isVideo)
                Positioned(
                  top: 2.w,
                  right: 2.w,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: CustomIconWidget(
                      iconName: 'play_arrow',
                      color: Colors.white,
                      size: 4.w,
                    ),
                  ),
                ),
              if (isVideo)
                Positioned(
                  bottom: 2.w,
                  right: 2.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      mediaItem['duration'] as String? ?? '0:00',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                    ),
                  ),
                ),
              if (isUploading)
                Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 8.w,
                          height: 8.w,
                          child: CircularProgressIndicator(
                            value: uploadProgress,
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '${(uploadProgress * 100).toInt()}%',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
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
    );
  }
}
