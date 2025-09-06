import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_gallery_widget.dart';
import './widgets/gallery_header_widget.dart';
import './widgets/media_context_menu_widget.dart';
import './widgets/media_grid_item_widget.dart';
import './widgets/timeline_section_widget.dart';
import './widgets/upload_options_sheet_widget.dart';

class GroupGalleryScreen extends StatefulWidget {
  const GroupGalleryScreen({Key? key}) : super(key: key);

  @override
  State<GroupGalleryScreen> createState() => _GroupGalleryScreenState();
}

class _GroupGalleryScreenState extends State<GroupGalleryScreen> {
  bool _isGridView = true;
  bool _isLoading = false;
  bool _isRefreshing = false;
  Map<String, dynamic>? _selectedMediaItem;
  bool _showContextMenu = false;

  // Mock data for the gallery
  final List<Map<String, dynamic>> _mediaItems = [
    {
      "id": 1,
      "type": "photo",
      "thumbnailUrl":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=400&fit=crop",
      "fullUrl":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&h=1200&fit=crop",
      "uploaderName": "Sarah Johnson",
      "uploaderAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "uploadTime": "2 hours ago",
      "uploadDate": "Today",
      "metadata": {
        "location": "Santorini, Greece",
        "camera": "iPhone 14 Pro",
        "size": "4.2 MB"
      }
    },
    {
      "id": 2,
      "type": "video",
      "thumbnailUrl":
          "https://images.unsplash.com/photo-1539650116574-75c0c6d73c6e?w=400&h=400&fit=crop",
      "fullUrl":
          "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4",
      "duration": "1:24",
      "uploaderName": "Mike Chen",
      "uploaderAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "uploadTime": "4 hours ago",
      "uploadDate": "Today",
      "metadata": {
        "location": "Mykonos, Greece",
        "duration": "1:24",
        "size": "12.8 MB"
      }
    },
    {
      "id": 3,
      "type": "photo",
      "thumbnailUrl":
          "https://images.unsplash.com/photo-1613395877344-13d4a8e0d49e?w=400&h=400&fit=crop",
      "fullUrl":
          "https://images.unsplash.com/photo-1613395877344-13d4a8e0d49e?w=1200&h=1200&fit=crop",
      "uploaderName": "Emma Wilson",
      "uploaderAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "uploadTime": "6 hours ago",
      "uploadDate": "Today",
      "metadata": {
        "location": "Crete, Greece",
        "camera": "Canon EOS R5",
        "size": "8.1 MB"
      }
    },
    {
      "id": 4,
      "type": "photo",
      "thumbnailUrl":
          "https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=400&h=400&fit=crop",
      "fullUrl":
          "https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=1200&h=1200&fit=crop",
      "uploaderName": "David Rodriguez",
      "uploaderAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "uploadTime": "Yesterday 8:30 PM",
      "uploadDate": "Yesterday",
      "metadata": {
        "location": "Athens, Greece",
        "camera": "Sony A7 III",
        "size": "6.7 MB"
      }
    },
    {
      "id": 5,
      "type": "video",
      "thumbnailUrl":
          "https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&h=400&fit=crop",
      "fullUrl":
          "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4",
      "duration": "2:15",
      "uploaderName": "Lisa Park",
      "uploaderAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "uploadTime": "Yesterday 3:15 PM",
      "uploadDate": "Yesterday",
      "metadata": {
        "location": "Rhodes, Greece",
        "duration": "2:15",
        "size": "24.3 MB"
      }
    },
    {
      "id": 6,
      "type": "photo",
      "thumbnailUrl":
          "https://images.unsplash.com/photo-1533105079780-92b9be482077?w=400&h=400&fit=crop",
      "fullUrl":
          "https://images.unsplash.com/photo-1533105079780-92b9be482077?w=1200&h=1200&fit=crop",
      "uploaderName": "Alex Thompson",
      "uploaderAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "uploadTime": "2 days ago",
      "uploadDate": "September 4",
      "uploadProgress": 0.75,
      "metadata": {
        "location": "Zakynthos, Greece",
        "camera": "iPhone 15 Pro Max",
        "size": "5.4 MB"
      }
    }
  ];

  final Map<String, dynamic> _groupInfo = {
    "name": "Greece Adventure 2024",
    "memberCount": 8,
    "members": [
      {
        "name": "Sarah Johnson",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "isOnline": true
      },
      {
        "name": "Mike Chen",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "isOnline": false
      },
      {
        "name": "Emma Wilson",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "isOnline": true
      },
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                GalleryHeaderWidget(
                  groupName: _groupInfo['name'] as String,
                  memberCount: _groupInfo['memberCount'] as int,
                  onSearchTap: _handleSearchTap,
                  onMembersTap: _handleMembersTap,
                  isGridView: _isGridView,
                  onViewToggle: _handleViewToggle,
                ),
                Expanded(
                  child: _buildGalleryContent(),
                ),
              ],
            ),
            if (_showContextMenu && _selectedMediaItem != null)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _hideContextMenu,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: Center(
                      child: MediaContextMenuWidget(
                        mediaItem: _selectedMediaItem!,
                        onDownload: _handleDownload,
                        onDelete: _handleDelete,
                        onReport: _handleReport,
                        onClose: _hideContextMenu,
                        canDelete: _canDeleteMedia(_selectedMediaItem!),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showUploadOptions,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        child: CustomIconWidget(
          iconName: 'camera_alt',
          color: Colors.white,
          size: 6.w,
        ),
      ),
    );
  }

  Widget _buildGalleryContent() {
    if (_mediaItems.isEmpty) {
      return EmptyGalleryWidget(
        onAddPhotos: _showUploadOptions,
      );
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: _isGridView ? _buildGridView() : _buildTimelineView(),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: EdgeInsets.all(4.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.w,
        mainAxisSpacing: 2.w,
        childAspectRatio: 1.0,
      ),
      itemCount: _mediaItems.length,
      itemBuilder: (context, index) {
        final mediaItem = _mediaItems[index];
        final isUploading = (mediaItem['uploadProgress'] as double?) != null &&
            (mediaItem['uploadProgress'] as double) < 1.0;

        return MediaGridItemWidget(
          mediaItem: mediaItem,
          onTap: () => _handleMediaTap(mediaItem),
          onLongPress: () => _handleMediaLongPress(mediaItem),
          isUploading: isUploading,
        );
      },
    );
  }

  Widget _buildTimelineView() {
    final groupedMedia = _groupMediaByDate();

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      itemCount: groupedMedia.keys.length,
      itemBuilder: (context, index) {
        final date = groupedMedia.keys.elementAt(index);
        final mediaItems = groupedMedia[date]!;

        return TimelineSectionWidget(
          date: date,
          mediaItems: mediaItems,
          onMediaTap: _handleMediaTap,
          onMediaLongPress: _handleMediaLongPress,
        );
      },
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupMediaByDate() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final item in _mediaItems) {
      final date = item['uploadDate'] as String;
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(item);
    }

    return grouped;
  }

  void _handleViewToggle(bool isGridView) {
    setState(() {
      _isGridView = isGridView;
    });
  }

  void _handleSearchTap() {
    // Navigate to search/filter screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Search functionality coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleMembersTap() {
    _showMembersBottomSheet();
  }

  void _handleMediaTap(Map<String, dynamic> mediaItem) {
    Navigator.pushNamed(
      context,
      '/fullscreen-photo-viewer',
      arguments: {
        'mediaItems': _mediaItems,
        'initialIndex': _mediaItems.indexOf(mediaItem),
      },
    );
  }

  void _handleMediaLongPress(Map<String, dynamic> mediaItem) {
    setState(() {
      _selectedMediaItem = mediaItem;
      _showContextMenu = true;
    });
  }

  void _hideContextMenu() {
    setState(() {
      _showContextMenu = false;
      _selectedMediaItem = null;
    });
  }

  bool _canDeleteMedia(Map<String, dynamic> mediaItem) {
    // In a real app, check if current user is the uploader or admin
    return (mediaItem['uploaderName'] as String) == 'Sarah Johnson';
  }

  void _handleDownload() {
    _hideContextMenu();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading media...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleDelete() {
    _hideContextMenu();
    _showDeleteConfirmation();
  }

  void _handleReport() {
    _hideContextMenu();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Media reported successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network refresh
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gallery refreshed'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => UploadOptionsSheetWidget(
        onTakePhoto: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/photo-upload-screen',
              arguments: {'mode': 'camera'});
        },
        onTakeVideo: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/photo-upload-screen',
              arguments: {'mode': 'video'});
        },
        onChooseFromLibrary: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/photo-upload-screen',
              arguments: {'mode': 'library'});
        },
        onBulkUpload: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/photo-upload-screen',
              arguments: {'mode': 'bulk'});
        },
      ),
    );
  }

  void _showMembersBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
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
              'Group Members (${_groupInfo['memberCount']})',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            ListView.separated(
              shrinkWrap: true,
              itemCount: (_groupInfo['members'] as List).length,
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                final member = (_groupInfo['members'] as List)[index];
                return ListTile(
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: 6.w,
                        backgroundImage:
                            NetworkImage(member['avatar'] as String),
                      ),
                      if (member['isOnline'] as bool)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 3.w,
                            height: 3.w,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(
                    member['name'] as String,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  subtitle: Text(
                    (member['isOnline'] as bool) ? 'Online' : 'Offline',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: (member['isOnline'] as bool)
                              ? Colors.green
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                );
              },
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Media'),
        content: Text(
            'Are you sure you want to delete this media? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _mediaItems.removeWhere(
                    (item) => item['id'] == _selectedMediaItem!['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Media deleted successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
