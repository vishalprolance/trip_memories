import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './timeline_media_item_widget.dart';

class TimelineSectionWidget extends StatelessWidget {
  final String date;
  final List<Map<String, dynamic>> mediaItems;
  final Function(Map<String, dynamic>) onMediaTap;
  final Function(Map<String, dynamic>) onMediaLongPress;

  const TimelineSectionWidget({
    Key? key,
    required this.date,
    required this.mediaItems,
    required this.onMediaTap,
    required this.onMediaLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Text(
            date,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: mediaItems.length,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            final mediaItem = mediaItems[index];
            return TimelineMediaItemWidget(
              mediaItem: mediaItem,
              onTap: () => onMediaTap(mediaItem),
              onLongPress: () => onMediaLongPress(mediaItem),
              isUploading: (mediaItem['uploadProgress'] as double?) != null &&
                  (mediaItem['uploadProgress'] as double) < 1.0,
            );
          },
        ),
        SizedBox(height: 3.h),
      ],
    );
  }
}
