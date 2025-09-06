import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

enum PrivacyOption {
  anyoneCanAdd,
  adminApproval,
}

class PrivacySettingsWidget extends StatefulWidget {
  final PrivacyOption selectedOption;
  final Function(PrivacyOption) onOptionChanged;

  const PrivacySettingsWidget({
    Key? key,
    required this.selectedOption,
    required this.onOptionChanged,
  }) : super(key: key);

  @override
  State<PrivacySettingsWidget> createState() => _PrivacySettingsWidgetState();
}

class _PrivacySettingsWidgetState extends State<PrivacySettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Privacy Settings',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
          ),
          child: Column(
            children: [
              _buildPrivacyOption(
                option: PrivacyOption.anyoneCanAdd,
                title: 'Anyone can add photos',
                subtitle: 'All group members can upload photos and videos',
                icon: 'group',
                isFirst: true,
              ),
              Divider(
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              _buildPrivacyOption(
                option: PrivacyOption.adminApproval,
                title: 'Admin approval required',
                subtitle: 'Only admins can approve photo uploads',
                icon: 'admin_panel_settings',
                isFirst: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyOption({
    required PrivacyOption option,
    required String title,
    required String subtitle,
    required String icon,
    required bool isFirst,
  }) {
    final bool isSelected = widget.selectedOption == option;

    return InkWell(
      onTap: () => widget.onOptionChanged(option),
      borderRadius: BorderRadius.vertical(
        top: isFirst ? Radius.circular(12) : Radius.zero,
        bottom: !isFirst ? Radius.circular(12) : Radius.zero,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primaryContainer
                    : AppTheme.lightTheme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.secondary,
                size: 20,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.w400,
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Radio<PrivacyOption>(
              value: option,
              groupValue: widget.selectedOption,
              onChanged: (PrivacyOption? value) {
                if (value != null) {
                  widget.onOptionChanged(value);
                }
              },
              activeColor: AppTheme.lightTheme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
