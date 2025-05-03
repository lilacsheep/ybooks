import 'package:flutter/material.dart';
import 'package:ybooks/widgets/bottom_app_bar_widget.dart'; // Import the bottom app bar widget, though not used in this page as per the image

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350.0, // Increased height to accommodate user info
            flexibleSpace: FlexibleSpaceBar(
              background: Stack( // Use Stack to layer background and user info
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'images/background.png', // Placeholder for background image
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill( // Add a black overlay
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                  Positioned( // Position the user info at the bottom left
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: AssetImage('images/avatar.png'), // Placeholder for avatar
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '胖大施', // Placeholder for username
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Row(
                                      children: [
                                        const Text(
                                          '小红书号: 11659947204', // Placeholder for ID
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const Icon(Icons.copy, size: 14.0, color: Colors.white),
                                      ],
                                    ),
                                    const SizedBox(height: 4.0),
                                    Row(
                                      children: [
                                        const Text(
                                          'IP属地: 上海', // Placeholder for IP location
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const Icon(Icons.info_outline, size: 14.0, color: Colors.white),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            '养生命理爱好者', // Placeholder for bio
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: const Text('36岁', style: TextStyle(color: Colors.white)), // Placeholder for age
                              ),
                              const SizedBox(width: 8.0),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: const Text('上海杨浦', style: TextStyle(color: Colors.white)), // Placeholder for location
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround, // Change to spaceAround for equal spacing
                            children: [
                              Column(
                                children: const [
                                  Text(
                                    '10', // Placeholder for followers
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '关注',
                                    style: TextStyle(
                                      fontSize: 12.0, // Smaller font size
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: const [
                                  Text(
                                    '113', // Placeholder for likes and collections
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '获赞与收藏',
                                    style: TextStyle(
                                      fontSize: 12.0, // Smaller font size
                                      color: Colors.white,
                                    ),
                                  ),
                                ]),
                              // Remove the SizedBox spacer
                              OutlinedButton( // Removed SizedBox
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.grey[800]!.withOpacity(0.3), // 30% opacity
                                  side: const BorderSide(color: Colors.white), // White border
                                ),
                                onPressed: () {
                                  // TODO: Implement edit profile action
                                },
                                child: const Text('编辑资料'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                // TODO: Implement menu action
              },
            ),
            actions: [
            ],
          ),
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.red,
                tabs: const [
                  Tab(text: '笔记'),
                  Tab(text: '收藏'),
                  Tab(text: '赞过'),
                ],
              ),
            ),
            pinned: true,
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Center(child: Text('笔记内容')), // Placeholder for content
                Center(child: Text('收藏内容')), // Placeholder for content
                Center(child: Text('赞过内容')), // Placeholder for content
              ],
            ),
          ),
        ],
      ),
      // BottomNavigationBar is not used here as per the image
      bottomNavigationBar: BottomAppBarWidget(
        currentIndex: 2, // Assuming index 2 is the settings icon
        onTap: (index) {
          if (index == 0) { // Assuming index 0 is the home icon
            Navigator.pushReplacementNamed(context, '/');
          }
          // TODO: Handle other indices if needed
        },
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}