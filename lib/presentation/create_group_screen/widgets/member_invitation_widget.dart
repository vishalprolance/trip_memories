import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MemberInvitationWidget extends StatefulWidget {
  final List<String> invitedMembers;
  final Function(List<String>) onMembersChanged;

  const MemberInvitationWidget({
    Key? key,
    required this.invitedMembers,
    required this.onMembersChanged,
  }) : super(key: key);

  @override
  State<MemberInvitationWidget> createState() => _MemberInvitationWidgetState();
}

class _MemberInvitationWidgetState extends State<MemberInvitationWidget> {
  final TextEditingController _inviteController = TextEditingController();
  final FocusNode _inviteFocusNode = FocusNode();
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  // Mock contacts for demonstration
  final List<Map<String, String>> _mockContacts = [
    {'name': 'Sarah Johnson', 'email': 'sarah.johnson@email.com'},
    {'name': 'Mike Chen', 'email': 'mike.chen@email.com'},
    {'name': 'Emma Wilson', 'email': 'emma.wilson@email.com'},
    {'name': 'David Rodriguez', 'email': 'david.rodriguez@email.com'},
    {'name': 'Lisa Thompson', 'email': 'lisa.thompson@email.com'},
    {'name': 'Alex Kim', 'email': 'alex.kim@email.com'},
    {'name': 'Rachel Brown', 'email': 'rachel.brown@email.com'},
    {'name': 'Tom Anderson', 'email': 'tom.anderson@email.com'},
  ];

  @override
  void initState() {
    super.initState();
    _inviteFocusNode.addListener(() {
      if (!_inviteFocusNode.hasFocus) {
        setState(() {
          _showSuggestions = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _inviteController.dispose();
    _inviteFocusNode.dispose();
    super.dispose();
  }

  void _onInviteTextChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    // Filter suggestions based on input
    final filteredSuggestions = _mockContacts
        .where((contact) =>
            contact['name']!.toLowerCase().contains(value.toLowerCase()) ||
            contact['email']!.toLowerCase().contains(value.toLowerCase()))
        .map((contact) => '${contact['name']} (${contact['email']})')
        .where((suggestion) => !widget.invitedMembers.contains(suggestion))
        .take(5)
        .toList();

    setState(() {
      _suggestions = filteredSuggestions;
      _showSuggestions = filteredSuggestions.isNotEmpty;
    });
  }

  void _addMember(String member) {
    if (member.isNotEmpty && !widget.invitedMembers.contains(member)) {
      final updatedMembers = List<String>.from(widget.invitedMembers)
        ..add(member);
      widget.onMembersChanged(updatedMembers);
      _inviteController.clear();
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  void _removeMember(String member) {
    final updatedMembers = List<String>.from(widget.invitedMembers)
      ..remove(member);
    widget.onMembersChanged(updatedMembers);
  }

  void _selectSuggestion(String suggestion) {
    _addMember(suggestion);
    _inviteFocusNode.unfocus();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _onSubmitted(String value) {
    if (value.trim().isNotEmpty) {
      // Check if it's a valid email or phone number format
      final trimmedValue = value.trim();
      if (_isValidEmail(trimmedValue) ||
          RegExp(r'^\+?[\d\s\-\(\)]+$').hasMatch(trimmedValue)) {
        _addMember(trimmedValue);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid email or phone number'),
            backgroundColor: AppTheme.errorLight,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Invite Members',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: _showSuggestions
                ? [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              TextFormField(
                controller: _inviteController,
                focusNode: _inviteFocusNode,
                onChanged: _onInviteTextChanged,
                onFieldSubmitted: _onSubmitted,
                decoration: InputDecoration(
                  hintText: 'Enter email or phone number',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'person_add',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  suffixIcon: _inviteController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () => _onSubmitted(_inviteController.text),
                          icon: CustomIconWidget(
                            iconName: 'add',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              if (_showSuggestions)
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(12)),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _suggestions.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                    ),
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.primaryContainer,
                          child: CustomIconWidget(
                            iconName: 'person',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                        ),
                        title: Text(
                          _suggestions[index],
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                        onTap: () => _selectSuggestion(_suggestions[index]),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        if (widget.invitedMembers.isNotEmpty) ...[
          SizedBox(height: 2.h),
          Text(
            'Invited Members (${widget.invitedMembers.length})',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.secondary,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: widget.invitedMembers.map((member) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      member.length > 25
                          ? '${member.substring(0, 25)}...'
                          : member,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color:
                            AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    GestureDetector(
                      onTap: () => _removeMember(member),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color:
                            AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
