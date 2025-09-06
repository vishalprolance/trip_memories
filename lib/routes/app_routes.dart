import 'package:flutter/material.dart';
import '../presentation/photo_upload_screen/photo_upload_screen.dart';
import '../presentation/group_gallery_screen/group_gallery_screen.dart';
import '../presentation/groups_dashboard/groups_dashboard.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/create_group_screen/create_group_screen.dart';
import '../presentation/fullscreen_photo_viewer/fullscreen_photo_viewer.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String photoUpload = '/photo-upload-screen';
  static const String groupGallery = '/group-gallery-screen';
  static const String groupsDashboard = '/groups-dashboard';
  static const String onboardingFlow = '/onboarding-flow';
  static const String createGroup = '/create-group-screen';
  static const String fullscreenPhotoViewer = '/fullscreen-photo-viewer';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const OnboardingFlow(),
    photoUpload: (context) => const PhotoUploadScreen(),
    groupGallery: (context) => const GroupGalleryScreen(),
    groupsDashboard: (context) => const GroupsDashboard(),
    onboardingFlow: (context) => const OnboardingFlow(),
    createGroup: (context) => const CreateGroupScreen(),
    fullscreenPhotoViewer: (context) => const FullscreenPhotoViewer(),
    // TODO: Add your other routes here
  };
}
