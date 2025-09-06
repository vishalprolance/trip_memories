import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/comments_bottom_sheet.dart';
import './widgets/photo_metadata_overlay.dart';
import './widgets/photo_viewer_widget.dart';

class FullscreenPhotoViewer extends StatefulWidget {
  const FullscreenPhotoViewer({Key? key}) : super(key: key);

  @override
  State<FullscreenPhotoViewer> createState() => _FullscreenPhotoViewerState();
}

class _FullscreenPhotoViewerState extends State<FullscreenPhotoViewer>
    with TickerProviderStateMixin {
  late AnimationController _overlayAnimationController;
  late Animation<double> _overlayAnimation;

  bool _isOverlayVisible = true;
  int _currentPhotoIndex = 0;
  bool _isDownloading = false;

  // Mock data for photos in the gallery
  final List<Map<String, dynamic>> _photos = [
    {
      "id": 1,
      "url":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "type": "image",
      "uploader": "Sarah Johnson",
      "uploaderAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "uploadDate": DateTime.now().subtract(Duration(hours: 2)),
      "location": "Santorini, Greece",
      "isLiked": true,
      "likeCount": 24,
      "commentCount": 8,
      "comments": [
        {
          "id": 1,
          "userName": "Mike Chen",
          "userAvatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
          "text": "Absolutely stunning view! The sunset colors are incredible.",
          "timestamp": DateTime.now().subtract(Duration(minutes: 30)),
        },
        {
          "id": 2,
          "userName": "Emma Wilson",
          "userAvatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
          "text": "This makes me want to book a trip to Greece right now! 😍",
          "timestamp": DateTime.now().subtract(Duration(hours: 1)),
        },
      ],
    },
    {
      "id": 2,
      "url":
          "https://images.unsplash.com/photo-1539635278303-d4002c07eae3?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "type": "image",
      "uploader": "David Martinez",
      "uploaderAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "uploadDate": DateTime.now().subtract(Duration(hours: 5)),
      "location": "Bali, Indonesia",
      "isLiked": false,
      "likeCount": 18,
      "commentCount": 5,
      "comments": [
        {
          "id": 3,
          "userName": "Lisa Park",
          "userAvatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
          "text": "The water is so clear and blue! Perfect beach day.",
          "timestamp": DateTime.now().subtract(Duration(hours: 2)),
        },
      ],
    },
    {
      "id": 3,
      "url":
          "https://images.unsplash.com/photo-1506197603052-3cc9c3a201bd?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "type": "video",
      "thumbnail":
          "https://images.unsplash.com/photo-1506197603052-3cc9c3a201bd?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "duration": 45,
      "uploader": "Alex Thompson",
      "uploaderAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "uploadDate": DateTime.now().subtract(Duration(days: 1)),
      "location": "Swiss Alps",
      "isLiked": true,
      "likeCount": 32,
      "commentCount": 12,
      "comments": [
        {
          "id": 4,
          "userName": "Rachel Green",
          "userAvatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
          "text": "This video captures the mountain atmosphere perfectly!",
          "timestamp": DateTime.now().subtract(Duration(hours: 8)),
        },
      ],
    },
    {
      "id": 4,
      "url":
          "https://images.unsplash.com/photo-1469474968028-56623f02e42e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "type": "image",
      "uploader": "Jennifer Lee",
      "uploaderAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "uploadDate": DateTime.now().subtract(Duration(days: 2)),
      "location": "Yosemite National Park",
      "isLiked": false,
      "likeCount": 41,
      "commentCount": 15,
      "comments": [
        {
          "id": 5,
          "userName": "Tom Wilson",
          "userAvatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
          "text":
              "Nature at its finest! The reflection in the lake is amazing.",
          "timestamp": DateTime.now().subtract(Duration(days: 1)),
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();

    // Set system UI overlay style for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _overlayAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _overlayAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _overlayAnimationController,
      curve: Curves.easeInOut,
    ));

    // Show overlay initially
    _overlayAnimationController.forward();

    // Update photo metadata with current index
    _updateCurrentPhotoMetadata();
  }

  @override
  void dispose() {
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _overlayAnimationController.dispose();
    super.dispose();
  }

  void _updateCurrentPhotoMetadata() {
    setState(() {
      for (int i = 0; i < _photos.length; i++) {
        _photos[i]["currentIndex"] = i + 1;
        _photos[i]["totalCount"] = _photos.length;
      }
    });
  }

  void _toggleOverlay() {
    setState(() {
      _isOverlayVisible = !_isOverlayVisible;
    });

    if (_isOverlayVisible) {
      _overlayAnimationController.forward();
    } else {
      _overlayAnimationController.reverse();
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPhotoIndex = index;
    });

    // Provide haptic feedback
    HapticFeedback.selectionClick();
  }

  void _closeViewer() {
    Navigator.pop(context);
  }

  void _sharePhoto() {
    final currentPhoto = _photos[_currentPhotoIndex];

    // Show share options
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(bottom: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Share Photo',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption('copy', 'Copy Link'),
                _buildShareOption('message', 'Message'),
                _buildShareOption('email', 'Email'),
                _buildShareOption('more_horiz', 'More'),
              ],
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(String icon, String label) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        // Handle share action
        HapticFeedback.lightImpact();
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _downloadPhoto() async {
    setState(() {
      _isDownloading = true;
    });

    // Simulate download process
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isDownloading = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Photo downloaded successfully'),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    HapticFeedback.lightImpact();
  }

  void _toggleLike() {
    setState(() {
      final currentPhoto = _photos[_currentPhotoIndex];
      final isLiked = currentPhoto["isLiked"] ?? false;
      currentPhoto["isLiked"] = !isLiked;
      currentPhoto["likeCount"] =
          (currentPhoto["likeCount"] ?? 0) + (isLiked ? -1 : 1);
    });

    HapticFeedback.lightImpact();
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CommentsBottomSheet(
        photo: _photos[_currentPhotoIndex],
        onAddComment: _addComment,
      ),
    );
  }

  void _addComment(String text) {
    setState(() {
      final currentPhoto = _photos[_currentPhotoIndex];
      final comments = (currentPhoto["comments"] as List?) ?? [];

      comments.insert(0, {
        "id": DateTime.now().millisecondsSinceEpoch,
        "userName": "You",
        "userAvatar": null,
        "text": text,
        "timestamp": DateTime.now(),
      });

      currentPhoto["comments"] = comments;
      currentPhoto["commentCount"] = comments.length;
    });

    HapticFeedback.lightImpact();
  }

  void _deletePhoto() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Photo'),
        content: Text(
            'Are you sure you want to delete this photo? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _photos.removeAt(_currentPhotoIndex);
                if (_photos.isEmpty) {
                  Navigator.pop(context);
                } else if (_currentPhotoIndex >= _photos.length) {
                  _currentPhotoIndex = _photos.length - 1;
                }
                _updateCurrentPhotoMetadata();
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Photo deleted'),
                  backgroundColor: AppTheme.errorLight,
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppTheme.errorLight),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_photos.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'No photos to display',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    final currentPhoto = _photos[_currentPhotoIndex];
    final isOwner = currentPhoto["uploader"] == "You" ||
        currentPhoto["uploader"] == "Sarah Johnson"; // Mock ownership

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          // Swipe down to dismiss
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 300) {
            _closeViewer();
          }
        },
        child: Stack(
          children: [
            // Photo viewer
            PhotoViewerWidget(
              photos: _photos,
              initialIndex: _currentPhotoIndex,
              onPageChanged: _onPageChanged,
              onTap: _toggleOverlay,
            ),

            // Download progress indicator
            if (_isDownloading)
              Center(
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Downloading...',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Metadata overlay
            AnimatedBuilder(
              animation: _overlayAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _overlayAnimation.value,
                  child: PhotoMetadataOverlay(
                    photo: currentPhoto,
                    isVisible: _isOverlayVisible,
                    onClose: _closeViewer,
                    onShare: _sharePhoto,
                    onDownload: _downloadPhoto,
                    onLike: _toggleLike,
                    onComment: _showComments,
                    onDelete: isOwner ? _deletePhoto : null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
