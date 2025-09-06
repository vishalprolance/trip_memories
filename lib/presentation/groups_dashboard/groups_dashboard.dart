import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/create_join_bottom_sheet.dart';
import './widgets/empty_state_widget.dart';
import './widgets/group_card_widget.dart';
import './widgets/search_bar_widget.dart';

class GroupsDashboard extends StatefulWidget {
  const GroupsDashboard({Key? key}) : super(key: key);

  @override
  State<GroupsDashboard> createState() => _GroupsDashboardState();
}

class _GroupsDashboardState extends State<GroupsDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<Map<String, dynamic>> _allGroups = [];
  List<Map<String, dynamic>> _filteredGroups = [];
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isOffline = false;
  int _newActivityCount = 0;

  // Mock data for groups
  final List<Map<String, dynamic>> _mockGroups = [
    {
      "id": 1,
      "tripName": "Bali Adventure 2024",
      "coverPhoto":
          "https://images.pexels.com/photos/2166559/pexels-photo-2166559.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "memberCount": 8,
      "members": [
        {
          "id": 1,
          "name": "Sarah Johnson",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "id": 2,
          "name": "Mike Chen",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "id": 3,
          "name": "Emma Davis",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "id": 4,
          "name": "Alex Rodriguez",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
      ],
      "lastActivity": "2 hours ago",
      "isPinned": true,
      "isMuted": false,
      "newPhotos": 12,
    },
    {
      "id": 2,
      "tripName": "Tokyo Food Tour",
      "coverPhoto":
          "https://images.pexels.com/photos/2070033/pexels-photo-2070033.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "memberCount": 5,
      "members": [
        {
          "id": 5,
          "name": "David Kim",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "id": 6,
          "name": "Lisa Wang",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "id": 7,
          "name": "Tom Wilson",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
      ],
      "lastActivity": "1 day ago",
      "isPinned": false,
      "isMuted": true,
      "newPhotos": 24,
    },
    {
      "id": 3,
      "tripName": "European Backpacking",
      "coverPhoto":
          "https://images.pexels.com/photos/1388030/pexels-photo-1388030.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "memberCount": 12,
      "members": [
        {
          "id": 8,
          "name": "Anna Schmidt",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "id": 9,
          "name": "Carlos Lopez",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "id": 10,
          "name": "Sophie Martin",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "id": 11,
          "name": "James Brown",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
      ],
      "lastActivity": "3 days ago",
      "isPinned": false,
      "isMuted": false,
      "newPhotos": 45,
    },
    {
      "id": 4,
      "tripName": "Family Reunion 2024",
      "coverPhoto":
          "https://images.pexels.com/photos/1128678/pexels-photo-1128678.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "memberCount": 15,
      "members": [
        {
          "id": 12,
          "name": "Mary Johnson",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "id": 13,
          "name": "Robert Smith",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "id": 14,
          "name": "Jennifer Davis",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "id": 15,
          "name": "Michael Wilson",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
      ],
      "lastActivity": "1 week ago",
      "isPinned": false,
      "isMuted": false,
      "newPhotos": 67,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadGroups();
    _calculateNewActivityCount();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadGroups() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _allGroups = List.from(_mockGroups);
          _filteredGroups = List.from(_allGroups);
          _isLoading = false;
        });
      }
    });
  }

  void _calculateNewActivityCount() {
    _newActivityCount = _allGroups.fold(0, (sum, group) {
      return sum + ((group['newPhotos'] as int?) ?? 0);
    });
  }

  Future<void> _refreshGroups() async {
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(seconds: 1));
    _loadGroups();
    _calculateNewActivityCount();
  }

  void _filterGroups(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredGroups = List.from(_allGroups);
      } else {
        _filteredGroups = _allGroups.where((group) {
          final tripName = (group['tripName'] as String).toLowerCase();
          return tripName.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _showCreateJoinBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CreateJoinBottomSheet(
        onCreateGroup: () => _navigateToCreateGroup(),
        onJoinWithCode: () => _showJoinWithCodeDialog(),
        onScanQR: () => _scanQRCode(),
      ),
    );
  }

  void _navigateToCreateGroup() {
    Navigator.pushNamed(context, '/create-group-screen');
  }

  void _navigateToGroupGallery(Map<String, dynamic> group) {
    Navigator.pushNamed(
      context,
      '/group-gallery-screen',
      arguments: group,
    );
  }

  void _showJoinWithCodeDialog() {
    final TextEditingController codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Join Group',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter the group code to join an existing trip group.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                hintText: 'Enter group code',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'vpn_key',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _joinGroupWithCode(codeController.text);
            },
            child: Text('Join'),
          ),
        ],
      ),
    );
  }

  void _joinGroupWithCode(String code) {
    if (code.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Joining group with code: $code'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      );
    }
  }

  void _scanQRCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('QR Code scanner would open here'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _toggleGroupPin(int groupId) {
    setState(() {
      final groupIndex = _allGroups.indexWhere((g) => g['id'] == groupId);
      if (groupIndex != -1) {
        _allGroups[groupIndex]['isPinned'] =
            !(_allGroups[groupIndex]['isPinned'] as bool);
        _filterGroups(_searchQuery);
      }
    });
    HapticFeedback.lightImpact();
  }

  void _toggleGroupMute(int groupId) {
    setState(() {
      final groupIndex = _allGroups.indexWhere((g) => g['id'] == groupId);
      if (groupIndex != -1) {
        _allGroups[groupIndex]['isMuted'] =
            !(_allGroups[groupIndex]['isMuted'] as bool);
        _filterGroups(_searchQuery);
      }
    });
    HapticFeedback.lightImpact();
  }

  void _leaveGroup(int groupId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Leave Group'),
        content: Text(
            'Are you sure you want to leave this group? You won\'t be able to see new photos or videos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _allGroups.removeWhere((g) => g['id'] == groupId);
                _filterGroups(_searchQuery);
              });
              HapticFeedback.lightImpact();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Leave'),
          ),
        ],
      ),
    );
  }

  void _showGroupSettings(Map<String, dynamic> group) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Group settings for ${group['tripName']}'),
      ),
    );
  }

  void _shareGroupInvite(Map<String, dynamic> group) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing invite for ${group['tripName']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(),
            // Tab Bar
            _buildTabBar(),
            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGroupsTab(),
                  _buildProfileTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: _showCreateJoinBottomSheet,
              child: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
            )
          : null,
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          // Logo/Title
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomIconWidget(
                    iconName: 'photo_camera',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  'Trip Memories',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // Offline indicator
          if (_isOffline)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'cloud_off',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Offline',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'groups',
                  color: _tabController.index == 0
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text('Groups'),
                if (_newActivityCount > 0 && _tabController.index != 0)
                  Container(
                    margin: EdgeInsets.only(left: 1.w),
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _newActivityCount > 99
                          ? '99+'
                          : _newActivityCount.toString(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onError,
                        fontSize: 8.sp,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'person',
                  color: _tabController.index == 1
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text('Profile'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsTab() {
    return Column(
      children: [
        // Search Bar
        SearchBarWidget(
          onSearchChanged: _filterGroups,
          hintText: 'Search your trip groups...',
        ),
        // Groups List
        Expanded(
          child: _filteredGroups.isEmpty
              ? _searchQuery.isNotEmpty
                  ? _buildNoSearchResults()
                  : EmptyStateWidget(
                      onCreateGroup: _navigateToCreateGroup,
                      onJoinGroup: _showCreateJoinBottomSheet,
                    )
              : RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _refreshGroups,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _filteredGroups.length,
                    itemBuilder: (context, index) {
                      final group = _filteredGroups[index];
                      return GroupCardWidget(
                        groupData: group,
                        onTap: () => _navigateToGroupGallery(group),
                        onMute: () => _toggleGroupMute(group['id'] as int),
                        onLeave: () => _leaveGroup(group['id'] as int),
                        onPin: () => _toggleGroupPin(group['id'] as int),
                        onSettings: () => _showGroupSettings(group),
                        onShare: () => _shareGroupInvite(group),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'No groups found',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try searching with different keywords or create a new group.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile Avatar
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
              ),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                size: 48,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'John Doe',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'john.doe@example.com',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 4.h),
            // Profile Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildProfileStat('Groups', '${_allGroups.length}'),
                _buildProfileStat('Photos',
                    '${_allGroups.fold(0, (sum, g) => sum + ((g['newPhotos'] as int?) ?? 0))}'),
                _buildProfileStat('Friends', '24'),
              ],
            ),
            SizedBox(height: 4.h),
            // Profile Actions
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Profile settings coming soon!')),
                  );
                },
                child: Text('Edit Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
