import 'package:flutter/material.dart';
import 'package:ybooks/widgets/bottom_app_bar_widget.dart'; // Import the bottom app bar widget
import 'package:ybooks/pages/home_page.dart'; // Import the home page

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _currentIndex = 2; // Assuming Settings is the third tab (0-indexed)

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        // Navigate to Home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        // Navigate to Favorites page (placeholder)
        // TODO: Implement navigation to Favorites page
        break;
      case 2:
        // Navigate to Settings page (current page)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // TODO: Implement menu action
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
            onPressed: () {
              // TODO: Implement scan action
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // TODO: Implement share action
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image Placeholder
          Positioned.fill(
            child: Image.asset(
              'images/background.png', // Placeholder for background image
              fit: BoxFit.cover,
            ),
          ),
          // Content
          DefaultTabController(
            // DefaultTabController should wrap the TabBar and TabBarView
            length: 3, // Number of tabs for "笔记", "收藏", "赞过"
            child: NestedScrollView(
              headerSliverBuilder: (
                BuildContext context,
                bool innerBoxIsScrolled,
              ) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    expandedHeight: 300.0, // Adjust height as needed
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // User Profile Section
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: AssetImage(
                                        'images/avatar.jpg',
                                      ), // Placeholder for avatar
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: CircleAvatar(
                                              radius: 12,
                                              backgroundColor: Colors.yellow,
                                              child: Icon(
                                                Icons.add,
                                                size: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '胖大施',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '小红书号: 11659947204',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'IP属地: 上海',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  '养生命理爱好者',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Chip(
                                      label: Text(
                                        '36岁',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.white24,
                                    ),
                                    SizedBox(width: 8),
                                    Chip(
                                      label: Text(
                                        '上海杨浦',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.white24,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildStatColumn('10', '关注'),
                                    _buildStatColumn('54', '粉丝'),
                                    _buildStatColumn('113', '获赞与收藏'),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          // TODO: Implement Edit Profile action
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(color: Colors.white),
                                          foregroundColor: Colors.white,
                                        ),
                                        child: Text('编辑资料'),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    CircleAvatar(
                                      backgroundColor: Colors.white24,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.settings,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          // TODO: Implement Settings action
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                // Quick Access Cards
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildQuickAccessCard(
                                        '友好市集',
                                        '户外装备抢先买',
                                        () {
                                          // TODO: Implement Friendly Market action
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: _buildQuickAccessCard(
                                        '订单',
                                        '查看我的订单',
                                        () {
                                          // TODO: Implement Order action
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: _buildQuickAccessCard(
                                        '购物车',
                                        '查看推荐好物',
                                        () {
                                          // TODO: Implement Shopping Cart action
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    bottom: TabBar(
                      indicatorColor: Colors.red, // Highlight color
                      labelColor: Colors.black, // Selected tab color
                      unselectedLabelColor: Colors.grey, // Unselected tab color
                      tabs: [Tab(text: '笔记'), Tab(text: '收藏'), Tab(text: '赞过')],
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  // Content for "Notes" tab
                  Center(
                    child: Text('笔记内容', style: TextStyle(color: Colors.black)),
                  ),
                  // Content for "Collections" tab
                  Center(
                    child: Text('收藏内容', style: TextStyle(color: Colors.black)),
                  ),
                  // Content for "Liked" tab
                  Center(
                    child: Text('赞过内容', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBarWidget(
        // Integrate the bottom app bar
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.white70)),
      ],
    );
  }

  Widget _buildQuickAccessCard(
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      color: Colors.white12,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
