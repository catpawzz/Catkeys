import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'drive.dart';
import 'posts.dart';
import 'profile.dart';

class DisplayPage extends StatefulWidget {
  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  int _selectedIndex = 0;
  String appVersion = '-';

  static List<Widget> _widgetOptions = <Widget>[
    PostsPage(),
    DriveScreen(),
    DriveScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void fetchAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  void initState() {
    super.initState();
    // ...existing code...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Color(0xFF173138),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Catkeys",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              'Ver. $appVersion | Connected to example.com', // Add your subtitle text here
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'Settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings_rounded),
                      SizedBox(width: 10),
                      Text('Settings'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'Refresh Notes',
                  child: Row(
                    children: [
                      Icon(Icons.refresh_rounded),
                      SizedBox(width: 10),
                      Text('Refresh Notes'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'Source Code',
                  child: Row(
                    children: [
                      Icon(Icons.source_rounded),
                      SizedBox(width: 10),
                      Text('Source Code'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'Announcements',
                  child: Row(
                    children: [
                      Icon(Icons.announcement_rounded),
                      SizedBox(width: 10),
                      Text('Announcements'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'Log Out',
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded),
                      SizedBox(width: 10),
                      Text('Log Out'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'newui',
                  child: Row(
                    children: [
                      Icon(Icons.new_releases_rounded),
                      SizedBox(width: 10),
                      Text('New UI (WIP)'),
                    ],
                  ),
                ),
              ];
            },
            onSelected: (value) async {
              // Handle menu item selection
            },
          ),
        ],
        elevation: 0.0,
        bottom: _selectedIndex != 0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: Theme.of(context).colorScheme.primary,
                  height: 2.0,
                ),
              )
            : null,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SizedBox(
        height: 60, // Adjust the height as desired
        child: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: <Widget>[
            const NavigationDestination(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.analytics_rounded),
              label: 'Stats',
            ),
            const NavigationDestination(
              icon: Icon(Icons.cloud_rounded),
              label: 'Drive',
            ),
            NavigationDestination(
              selectedIcon: CircleAvatar(
                backgroundImage: NetworkImage('https://example.com/profile_picture.png'), // Replace with actual profile picture URL
                radius: 16, // Adjust the radius to make the image smaller
              ),
              icon: CircleAvatar(
                backgroundImage: NetworkImage('https://example.com/profile_picture.png'), // Replace with actual profile picture URL
                radius: 16, // Adjust the radius to make the image smaller
              ),
              label: 'Profile',
            ),
          ].where((destination) => destination != null).toList(),
        ),
      ),
    );
  }
}