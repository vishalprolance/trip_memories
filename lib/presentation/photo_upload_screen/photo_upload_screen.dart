import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/photo_grid_widget.dart';
import './widgets/smart_selection_widget.dart';
import './widgets/upload_header_widget.dart';
import './widgets/upload_queue_widget.dart';

class PhotoUploadScreen extends StatefulWidget {
  const PhotoUploadScreen({Key? key}) : super(key: key);

  @override
  State<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  List<String> selectedPhotos = [];
  List<Map<String, dynamic>> uploadQueue = [];
  bool isUploading = false;
  bool uploadOnWifiOnly = true;
  bool hasPermission = false;

  // Mock photo data - in real app this would come from device gallery
  final List<Map<String, dynamic>> mockPhotos = [
    {
      "id": "1",
      "name": "IMG_001.jpg",
      "thumbnail":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300&h=300&fit=crop",
      "fullUrl":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&h=1200&fit=crop",
      "size": "2.4 MB",
      "sizeInMB": 2.4,
      "date": "2025-01-06",
      "isToday": true,
      "isRecentTrip": true,
    },
    {
      "id": "2",
      "name": "IMG_002.jpg",
      "thumbnail":
          "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=300&h=300&fit=crop",
      "fullUrl":
          "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200&h=1200&fit=crop",
      "size": "3.1 MB",
      "sizeInMB": 3.1,
      "date": "2025-01-06",
      "isToday": true,
      "isRecentTrip": true,
    },
    {
      "id": "3",
      "name": "IMG_003.jpg",
      "thumbnail":
          "https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=300&h=300&fit=crop",
      "fullUrl":
          "https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&h=1200&fit=crop",
      "size": "1.8 MB",
      "sizeInMB": 1.8,
      "date": "2025-01-05",
      "isToday": false,
      "isRecentTrip": true,
    },
    {
      "id": "4",
      "name": "IMG_004.jpg",
      "thumbnail":
          "https://images.unsplash.com/photo-1501436513145-30f24e19fcc4?w=300&h=300&fit=crop",
      "fullUrl":
          "https://images.unsplash.com/photo-1501436513145-30f24e19fcc4?w=1200&h=1200&fit=crop",
      "size": "2.7 MB",
      "sizeInMB": 2.7,
      "date": "2025-01-05",
      "isToday": false,
      "isRecentTrip": true,
    },
    {
      "id": "5",
      "name": "IMG_005.jpg",
      "thumbnail":
          "https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=300&h=300&fit=crop",
      "fullUrl":
          "https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=1200&h=1200&fit=crop",
      "size": "3.5 MB",
      "sizeInMB": 3.5,
      "date": "2025-01-04",
      "isToday": false,
      "isRecentTrip": false,
    },
    {
      "id": "6",
      "name": "IMG_006.jpg",
      "thumbnail":
          "https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=300&h=300&fit=crop",
      "fullUrl":
          "https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=1200&h=1200&fit=crop",
      "size": "2.1 MB",
      "sizeInMB": 2.1,
      "date": "2025-01-04",
      "isToday": false,
      "isRecentTrip": false,
    },
    {
      "id": "7",
      "name": "IMG_007.jpg",
      "thumbnail":
          "https://images.unsplash.com/photo-1506197603052-3cc9c3a201bd?w=300&h=300&fit=crop",
      "fullUrl":
          "https://images.unsplash.com/photo-1506197603052-3cc9c3a201bd?w=1200&h=1200&fit=crop",
      "size": "4.2 MB",
      "sizeInMB": 4.2,
      "date": "2025-01-03",
      "isToday": false,
      "isRecentTrip": false,
    },
    {
      "id": "8",
      "name": "IMG_008.jpg",
      "thumbnail":
          "https://images.unsplash.com/photo-1448375240586-882707db888b?w=300&h=300&fit=crop",
      "fullUrl":
          "https://images.unsplash.com/photo-1448375240586-882707db888b?w=1200&h=1200&fit=crop",
      "size": "1.9 MB",
      "sizeInMB": 1.9,
      "date": "2025-01-03",
      "isToday": false,
      "isRecentTrip": false,
    },
    {
      "id": "9",
      "name": "IMG_009.jpg",
      "thumbnail":
          "https://images.unsplash.com/photo-1493246507139-91e8fad9978e?w=300&h=300&fit=crop",
      "fullUrl":
          "https://images.unsplash.com/photo-1493246507139-91e8fad9978e?w=1200&h=1200&fit=crop",
      "size": "3.8 MB",
      "sizeInMB": 3.8,
      "date": "2025-01-02",
      "isToday": false,
      "isRecentTrip": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (kIsWeb) {
      setState(() => hasPermission = true);
      return;
    }

    final status = await Permission.photos.request();
    setState(() => hasPermission = status.isGranted);

    if (!status.isGranted) {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Photo Access Required'),
        content: Text(
            'This app needs access to your photos to upload them to your trip gallery.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _onPhotoTap(String photoId) {
    setState(() {
      if (selectedPhotos.contains(photoId)) {
        selectedPhotos.remove(photoId);
        uploadQueue.removeWhere((item) => item['id'] == photoId);
      } else {
        selectedPhotos.add(photoId);
        final photo = mockPhotos.firstWhere((p) => p['id'] == photoId);
        uploadQueue.add({
          'id': photo['id'],
          'name': photo['name'],
          'thumbnail': photo['thumbnail'],
          'fullUrl': photo['fullUrl'],
          'sizeInMB': photo['sizeInMB'],
          'progress': null,
        });
      }
    });
  }

  void _onSelectAllToday() {
    final todayPhotos =
        mockPhotos.where((photo) => photo['isToday'] == true).toList();
    setState(() {
      for (final photo in todayPhotos) {
        final photoId = photo['id'].toString();
        if (!selectedPhotos.contains(photoId)) {
          selectedPhotos.add(photoId);
          uploadQueue.add({
            'id': photo['id'],
            'name': photo['name'],
            'thumbnail': photo['thumbnail'],
            'fullUrl': photo['fullUrl'],
            'sizeInMB': photo['sizeInMB'],
            'progress': null,
          });
        }
      }
    });
  }

  void _onSelectRecentTrip() {
    final tripPhotos =
        mockPhotos.where((photo) => photo['isRecentTrip'] == true).toList();
    setState(() {
      for (final photo in tripPhotos) {
        final photoId = photo['id'].toString();
        if (!selectedPhotos.contains(photoId)) {
          selectedPhotos.add(photoId);
          uploadQueue.add({
            'id': photo['id'],
            'name': photo['name'],
            'thumbnail': photo['thumbnail'],
            'fullUrl': photo['fullUrl'],
            'sizeInMB': photo['sizeInMB'],
            'progress': null,
          });
        }
      }
    });
  }

  void _onSelectAll() {
    setState(() {
      selectedPhotos.clear();
      uploadQueue.clear();
      for (final photo in mockPhotos) {
        final photoId = photo['id'].toString();
        selectedPhotos.add(photoId);
        uploadQueue.add({
          'id': photo['id'],
          'name': photo['name'],
          'thumbnail': photo['thumbnail'],
          'fullUrl': photo['fullUrl'],
          'sizeInMB': photo['sizeInMB'],
          'progress': null,
        });
      }
    });
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  void _onUpload() {
    if (selectedPhotos.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => UploadQueueWidget(
          uploadQueue: uploadQueue,
          isUploading: isUploading,
          uploadOnWifiOnly: uploadOnWifiOnly,
          onWifiToggle: (value) => setState(() => uploadOnWifiOnly = value),
          onStartUpload: _startUpload,
          onRemoveAll: _removeAllFromQueue,
          onRemoveItem: _removeFromQueue,
        ),
      ),
    );
  }

  void _startUpload() async {
    setState(() => isUploading = true);

    // Simulate upload progress
    for (int i = 0; i < uploadQueue.length; i++) {
      for (int progress = 0; progress <= 100; progress += 10) {
        await Future.delayed(Duration(milliseconds: 100));
        setState(() {
          uploadQueue[i]['progress'] = progress;
        });
      }
    }

    setState(() => isUploading = false);
    Navigator.pop(context); // Close bottom sheet
    _showUploadSuccess();
  }

  void _showUploadSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text('Upload Complete'),
          ],
        ),
        content: Text(
            '${uploadQueue.length} photos uploaded successfully to your trip gallery.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/group-gallery-screen');
            },
            child: Text('View in Gallery'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  void _removeAllFromQueue() {
    setState(() {
      selectedPhotos.clear();
      uploadQueue.clear();
    });
  }

  void _removeFromQueue(String photoId) {
    setState(() {
      selectedPhotos.remove(photoId);
      uploadQueue.removeWhere((item) => item['id'] == photoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!hasPermission) {
      return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'photo_library',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20.w,
                ),
                SizedBox(height: 4.h),
                Text(
                  'Photo Access Required',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                Text(
                  'To upload photos to your trip gallery, please grant access to your photo library.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                ElevatedButton(
                  onPressed: () => openAppSettings(),
                  child: Text('Open Settings'),
                ),
                SizedBox(height: 2.h),
                TextButton(
                  onPressed: _onCancel,
                  child: Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          UploadHeaderWidget(
            selectedCount: selectedPhotos.length,
            onCancel: _onCancel,
            onUpload: _onUpload,
          ),
          SmartSelectionWidget(
            onSelectAllToday: _onSelectAllToday,
            onSelectRecentTrip: _onSelectRecentTrip,
            onSelectAll: _onSelectAll,
          ),
          Expanded(
            child: PhotoGridWidget(
              photos: mockPhotos,
              selectedPhotos: selectedPhotos,
              onPhotoTap: _onPhotoTap,
            ),
          ),
        ],
      ),
    );
  }
}
