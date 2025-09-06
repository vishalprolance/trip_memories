import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhotoMetadataOverlay extends StatelessWidget {
  final Map<String, dynamic> photo;
  final bool isVisible;
  final VoidCallback onClose;
  final VoidCallback onShare;
  final VoidCallback onDownload;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback? onDelete;

  const PhotoMetadataOverlay({
    Key? key,
    required this.photo,
    required this.isVisible,
    required this.onClose,
    required this.onShare,
    required this.onDownload,
    required this.onLike,
    required this.onComment,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return SizedBox.shrink();

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          // Top overlay with photo counter and close button
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.7),
                  Colors.transparent,
                ],
              ),
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${photo["currentIndex"] ?? 1} of ${photo["totalCount"] ?? 1}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: Colors.white,
                        size: 6.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Spacer(),

          // Bottom overlay with metadata and actions
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Photo metadata
                  if (photo["uploader"] != null) ...[
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 4.w,
                          backgroundImage: photo["uploaderAvatar"] != null
                              ? NetworkImage(photo["uploaderAvatar"])
                              : null,
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.primary,
                          child: photo["uploaderAvatar"] == null
                              ? Text(
                                  (photo["uploader"] as String)
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : null,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                photo["uploader"] ?? "Unknown",
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (photo["uploadDate"] != null)
                                Text(
                                  _formatDate(photo["uploadDate"]),
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                  ],

                  // Location if available
                  if (photo["location"] != null) ...[
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: Colors.white.withValues(alpha: 0.8),
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            photo["location"],
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                  ],

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: 'share',
                        label: 'Share',
                        onTap: onShare,
                      ),
                      _buildActionButton(
                        icon: 'download',
                        label: 'Download',
                        onTap: onDownload,
                      ),
                      _buildActionButton(
                        icon: photo["isLiked"] == true
                            ? 'favorite'
                            : 'favorite_border',
                        label: '${photo["likeCount"] ?? 0}',
                        onTap: onLike,
                        isActive: photo["isLiked"] == true,
                      ),
                      _buildActionButton(
                        icon: 'comment',
                        label: '${photo["commentCount"] ?? 0}',
                        onTap: onComment,
                      ),
                      if (onDelete != null)
                        _buildActionButton(
                          icon: 'delete',
                          label: 'Delete',
                          onTap: onDelete!,
                          isDestructive: true,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isDestructive
                  ? AppTheme.errorLight
                  : isActive
                      ? AppTheme.lightTheme.colorScheme.primary
                      : Colors.white,
              size: 6.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isDestructive
                    ? AppTheme.errorLight
                    : isActive
                        ? AppTheme.lightTheme.colorScheme.primary
                        : Colors.white,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
