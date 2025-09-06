import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhotoViewerWidget extends StatefulWidget {
  final List<Map<String, dynamic>> photos;
  final int initialIndex;
  final Function(int) onPageChanged;
  final VoidCallback onTap;

  const PhotoViewerWidget({
    Key? key,
    required this.photos,
    required this.initialIndex,
    required this.onPageChanged,
    required this.onTap,
  }) : super(key: key);

  @override
  State<PhotoViewerWidget> createState() => _PhotoViewerWidgetState();
}

class _PhotoViewerWidgetState extends State<PhotoViewerWidget>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late TransformationController _transformationController;
  late AnimationController _scaleAnimationController;
  late Animation<Matrix4> _scaleAnimation;

  bool _isZoomed = false;
  double _currentScale = 1.0;
  static const double _minScale = 1.0;
  static const double _maxScale = 3.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _transformationController = TransformationController();
    _scaleAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _transformationController.addListener(_onTransformationChanged);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    _scaleAnimationController.dispose();
    super.dispose();
  }

  void _onTransformationChanged() {
    final Matrix4 matrix = _transformationController.value;
    final double scale = matrix.getMaxScaleOnAxis();

    setState(() {
      _currentScale = scale;
      _isZoomed = scale > _minScale + 0.1;
    });
  }

  void _handleDoubleTap() {
    if (_isZoomed) {
      // Zoom out to fit
      _animateToScale(_minScale);
    } else {
      // Zoom in to 2x
      _animateToScale(2.0);
    }
  }

  void _animateToScale(double targetScale) {
    final Matrix4 currentMatrix = _transformationController.value;
    final Matrix4 targetMatrix = Matrix4.identity()..scale(targetScale);

    _scaleAnimation = Matrix4Tween(
      begin: currentMatrix,
      end: targetMatrix,
    ).animate(CurvedAnimation(
      parent: _scaleAnimationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation.addListener(() {
      _transformationController.value = _scaleAnimation.value;
    });

    _scaleAnimationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            // Reset zoom when changing pages
            if (_isZoomed) {
              _transformationController.value = Matrix4.identity();
            }
            widget.onPageChanged(index);
          },
          itemCount: widget.photos.length,
          itemBuilder: (context, index) {
            final photo = widget.photos[index];
            return _buildPhotoView(photo);
          },
        ),
      ),
    );
  }

  Widget _buildPhotoView(Map<String, dynamic> photo) {
    return Center(
      child: GestureDetector(
        onDoubleTap: _handleDoubleTap,
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: _minScale,
          maxScale: _maxScale,
          panEnabled: true,
          scaleEnabled: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: photo["type"] == "video"
                ? _buildVideoPlayer(photo)
                : _buildImageView(photo),
          ),
        ),
      ),
    );
  }

  Widget _buildImageView(Map<String, dynamic> photo) {
    return CustomImageWidget(
      imageUrl: photo["url"] ?? photo["imageUrl"] ?? "",
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain,
    );
  }

  Widget _buildVideoPlayer(Map<String, dynamic> photo) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Video thumbnail
          CustomImageWidget(
            imageUrl: photo["thumbnail"] ?? photo["url"] ?? "",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.contain,
          ),

          // Play button overlay
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'play_arrow',
              color: Colors.white,
              size: 12.w,
            ),
          ),

          // Video duration
          if (photo["duration"] != null)
            Positioned(
              bottom: 4.h,
              right: 4.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _formatDuration(photo["duration"]),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
