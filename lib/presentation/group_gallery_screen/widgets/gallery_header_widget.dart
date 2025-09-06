import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GalleryHeaderWidget extends StatelessWidget {
  final String groupName;
  final int memberCount;
  final VoidCallback onSearchTap;
  final VoidCallback onMembersTap;
  final bool isGridView;
  final Function(bool) onViewToggle;

  const GalleryHeaderWidget({
    Key? key,
    required this.groupName,
    required this.memberCount,
    required this.onSearchTap,
    required this.onMembersTap,
    required this.isGridView,
    required this.onViewToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  child: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      groupName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    GestureDetector(
                      onTap: onMembersTap,
                      child: Text(
                        '$memberCount members',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onSearchTap,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onViewToggle(true),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      decoration: BoxDecoration(
                        color: isGridView
                            ? AppTheme.lightTheme.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'grid_view',
                            color: isGridView
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Grid',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: isGridView
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: isGridView
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onViewToggle(false),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      decoration: BoxDecoration(
                        color: !isGridView
                            ? AppTheme.lightTheme.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'view_list',
                            color: !isGridView
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Timeline',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: !isGridView
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: !isGridView
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
