import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationInputWidget extends StatefulWidget {
  final String? selectedLocation;
  final Function(String) onLocationChanged;

  const LocationInputWidget({
    Key? key,
    this.selectedLocation,
    required this.onLocationChanged,
  }) : super(key: key);

  @override
  State<LocationInputWidget> createState() => _LocationInputWidgetState();
}

class _LocationInputWidgetState extends State<LocationInputWidget> {
  final TextEditingController _locationController = TextEditingController();
  final FocusNode _locationFocusNode = FocusNode();
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  // Mock location suggestions for demonstration
  final List<String> _mockLocations = [
    'Paris, France',
    'Tokyo, Japan',
    'New York, USA',
    'London, UK',
    'Rome, Italy',
    'Barcelona, Spain',
    'Amsterdam, Netherlands',
    'Sydney, Australia',
    'Bangkok, Thailand',
    'Dubai, UAE',
    'Bali, Indonesia',
    'Santorini, Greece',
    'Machu Picchu, Peru',
    'Iceland',
    'Swiss Alps, Switzerland',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.selectedLocation != null) {
      _locationController.text = widget.selectedLocation!;
    }

    _locationFocusNode.addListener(() {
      if (!_locationFocusNode.hasFocus) {
        setState(() {
          _showSuggestions = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    _locationFocusNode.dispose();
    super.dispose();
  }

  void _onLocationTextChanged(String value) {
    widget.onLocationChanged(value);

    if (value.isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    // Filter suggestions based on input
    final filteredSuggestions = _mockLocations
        .where(
            (location) => location.toLowerCase().contains(value.toLowerCase()))
        .take(5)
        .toList();

    setState(() {
      _suggestions = filteredSuggestions;
      _showSuggestions = filteredSuggestions.isNotEmpty;
    });
  }

  void _selectSuggestion(String suggestion) {
    _locationController.text = suggestion;
    widget.onLocationChanged(suggestion);
    setState(() {
      _showSuggestions = false;
    });
    _locationFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
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
                controller: _locationController,
                focusNode: _locationFocusNode,
                onChanged: _onLocationTextChanged,
                decoration: InputDecoration(
                  hintText: 'Where are you going?',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'location_on',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
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
                        leading: CustomIconWidget(
                          iconName: 'location_on',
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          size: 18,
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
      ],
    );
  }
}
