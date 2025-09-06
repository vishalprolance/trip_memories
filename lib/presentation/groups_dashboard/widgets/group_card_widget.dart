import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class GroupCardWidget extends StatelessWidget {
  final Map<String, dynamic> groupData;
  final VoidCallback onTap;
  final VoidCallback onMute;
  final VoidCallback onLeave;
  final VoidCallback onPin;
  final VoidCallback onSettings;
  final VoidCallback onShare;

  const GroupCardWidget({
    Key? key,
    required this.groupData,
    required this.onTap,
    required this.onMute,
    required this.onLeave,
    required this.onPin,
    required this.onSettings,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final memberCount = (groupData['memberCount'] as int?) ?? 0;
    final members = (groupData['members'] as List?) ?? [];
    final lastActivity = groupData['lastActivity'] as String? ?? '';
    final isPinned = (groupData['isPinned'] as bool?) ?? false;
    final isMuted = (groupData['isMuted'] as bool?) ?? false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(groupData['id']),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onMute(),
              backgroundColor: isMuted
                  ? AppTheme.lightTheme.colorScheme.secondary
                  : AppTheme.lightTheme.colorScheme.tertiary,
              foregroundColor: AppTheme.lightTheme.colorScheme.surface,
              icon: isMuted ? Icons.volume_up : Icons.volume_off,
              label: isMuted ? 'Unmute' : 'Mute',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onLeave(),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.surface,
              icon: Icons.exit_to_app,
              label: 'Leave',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          onLongPress: () => _showContextMenu(context),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              height: 20.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppTheme.lightTheme.colorScheme.surface,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover Photo Section
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        color: AppTheme.lightTheme.colorScheme.surfaceContainer,
                      ),
                      child: Stack(
                        children: [
                          // Cover Photo
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            child: CustomImageWidget(
                              imageUrl:
                                  groupData['coverPhoto'] as String? ?? '',
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Gradient Overlay
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  AppTheme.lightTheme.colorScheme.surface
                                      .withValues(alpha: 0.8),
                                ],
                              ),
                            ),
                          ),
                          // Pin Indicator
                          if (isPinned)
                            Positioned(
                              top: 2.h,
                              right: 3.w,
                              child: Container(
                                padding: EdgeInsets.all(1.w),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: CustomIconWidget(
                                  iconName: 'push_pin',
                                  color:
                                      AppTheme.lightTheme.colorScheme.surface,
                                  size: 16,
                                ),
                              ),
                            ),
                          // Mute Indicator
                          if (isMuted)
                            Positioned(
                              top: 2.h,
                              left: 3.w,
                              child: Container(
                                padding: EdgeInsets.all(1.w),
                                decoration: BoxDecoration(
                                  color: AppTheme
                                      .lightTheme.colorScheme.secondary
                                      .withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: CustomIconWidget(
                                  iconName: 'volume_off',
                                  color:
                                      AppTheme.lightTheme.colorScheme.surface,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // Content Section
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Trip Name
                          Text(
                            groupData['tripName'] as String? ?? 'Untitled Trip',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          // Member Avatars and Count
                          Row(
                            children: [
                              Expanded(
                                child:
                                    _buildMemberAvatars(members, memberCount),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                '$memberCount member${memberCount != 1 ? 's' : ''}',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          // Last Activity
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'access_time',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 14,
                              ),
                              SizedBox(width: 1.w),
                              Expanded(
                                child: Text(
                                  lastActivity,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberAvatars(List members, int memberCount) {
    const maxAvatars = 4;
    final displayMembers = members.take(maxAvatars).toList();
    final remainingCount = memberCount - maxAvatars;

    return SizedBox(
      height: 6.w,
      child: Stack(
        children: [
          ...displayMembers.asMap().entries.map((entry) {
            final index = entry.key;
            final member = entry.value as Map<String, dynamic>;
            return Positioned(
              left: index * 4.w,
              child: Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: member['avatar'] as String? ?? '',
                    width: 6.w,
                    height: 6.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }).toList(),
          if (remainingCount > 0)
            Positioned(
              left: maxAvatars * 4.w,
              child: Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+$remainingCount',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                      fontSize: 8.sp,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    final isPinned = (groupData['isPinned'] as bool?) ?? false;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: isPinned ? 'push_pin_outlined' : 'push_pin',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                isPinned ? 'Unpin from Top' : 'Pin to Top',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onPin();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Group Settings',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onSettings();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Share Invite',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onShare();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}