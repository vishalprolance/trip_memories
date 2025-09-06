import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/date_picker_widget.dart';
import './widgets/group_image_picker_widget.dart';
import './widgets/location_input_widget.dart';
import './widgets/member_invitation_widget.dart';
import './widgets/privacy_settings_widget.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tripNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _scrollController = ScrollController();

  File? _groupImage;
  DateTime? _startDate;
  DateTime? _endDate;
  String _location = '';
  PrivacyOption _privacyOption = PrivacyOption.anyoneCanAdd;
  List<String> _invitedMembers = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _tripNameController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _tripNameController.text.trim().isNotEmpty &&
        _startDate != null &&
        _location.trim().isNotEmpty;
  }

  Future<void> _createGroup() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate group creation process
      await Future.delayed(Duration(seconds: 2));

      // Mock group data
      final groupData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _tripNameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'location': _location,
        'startDate': _startDate?.toIso8601String(),
        'endDate': _endDate?.toIso8601String(),
        'privacy': _privacyOption == PrivacyOption.anyoneCanAdd
            ? 'open'
            : 'admin_approval',
        'members': _invitedMembers,
        'createdAt': DateTime.now().toIso8601String(),
        'createdBy': 'current_user@email.com',
      };

      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Trip group "${_tripNameController.text}" created successfully!'),
          backgroundColor: AppTheme.successLight,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Navigate to group gallery
      Navigator.pushReplacementNamed(context, '/group-gallery-screen');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create group. Please try again.'),
          backgroundColor: AppTheme.errorLight,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onImageSelected(File? image) {
    setState(() {
      _groupImage = image;
    });
  }

  void _onStartDateChanged(DateTime? date) {
    setState(() {
      _startDate = date;
    });
  }

  void _onEndDateChanged(DateTime? date) {
    setState(() {
      _endDate = date;
    });
  }

  void _onLocationChanged(String location) {
    setState(() {
      _location = location;
    });
  }

  void _onPrivacyOptionChanged(PrivacyOption option) {
    setState(() {
      _privacyOption = option;
    });
  }

  void _onMembersChanged(List<String> members) {
    setState(() {
      _invitedMembers = members;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: _isLoading
                  ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  : AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ),
        leadingWidth: 20.w,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: TextButton(
              onPressed: _isFormValid && !_isLoading ? _createGroup : null,
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    )
                  : Text(
                      'Create',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: _isFormValid
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3.h),

                // Header
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Create Trip Group',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Share memories with friends and family',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 4.h),

                // Group Image Picker
                Center(
                  child: GroupImagePickerWidget(
                    onImageSelected: _onImageSelected,
                  ),
                ),

                SizedBox(height: 4.h),

                // Trip Name
                Text(
                  'Trip Name *',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _tripNameController,
                  maxLength: 50,
                  onChanged: (value) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Enter trip name',
                    counterText: '${_tripNameController.text.length}/50',
                    counterStyle:
                        AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Trip name is required';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 3.h),

                // Description
                Text(
                  'Description',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _descriptionController,
                  maxLength: 200,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Tell us about your trip (optional)',
                    counterText: '${_descriptionController.text.length}/200',
                    counterStyle:
                        AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                // Date Picker
                DatePickerWidget(
                  startDate: _startDate,
                  endDate: _endDate,
                  onStartDateChanged: _onStartDateChanged,
                  onEndDateChanged: _onEndDateChanged,
                ),

                SizedBox(height: 3.h),

                // Location Input
                LocationInputWidget(
                  selectedLocation: _location.isNotEmpty ? _location : null,
                  onLocationChanged: _onLocationChanged,
                ),

                SizedBox(height: 3.h),

                // Privacy Settings
                PrivacySettingsWidget(
                  selectedOption: _privacyOption,
                  onOptionChanged: _onPrivacyOptionChanged,
                ),

                SizedBox(height: 3.h),

                // Member Invitation
                MemberInvitationWidget(
                  invitedMembers: _invitedMembers,
                  onMembersChanged: _onMembersChanged,
                ),

                SizedBox(height: 6.h),

                // Create Button (Mobile)
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed:
                        _isFormValid && !_isLoading ? _createGroup : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      foregroundColor:
                          AppTheme.lightTheme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                'Creating Group...',
                                style: AppTheme.lightTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Create Trip Group',
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
