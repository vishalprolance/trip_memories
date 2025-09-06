import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhotoGridWidget extends StatelessWidget {
  final List<Map<String, dynamic>> photos;
  final List<String> selectedPhotos;
  final Function(String) onPhotoTap;

  const PhotoGridWidget({
    Key? key,
    required this.photos,
    required this.selectedPhotos,
    required this.onPhotoTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(2.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1.w,
        mainAxisSpacing: 1.w,
        childAspectRatio: 1.0,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        final photoId = photo['id'].toString();
        final isSelected = selectedPhotos.contains(photoId);

        return GestureDetector(
          onTap: () => onPhotoTap(photoId),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(
                      color: AppTheme.lightTheme.colorScheme.primary, width: 3)
                  : null,
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: photo['thumbnail'],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 1.w,
                    right: 1.w,
                    child: Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'check',
                        color: Colors.white,
                        size: 4.w,
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 1.w,
                  right: 1.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      photo['size'],
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontSize: 8.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
