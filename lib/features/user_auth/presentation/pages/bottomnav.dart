import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:foodevenproject/features/user_auth/presentation/pages/home_page.dart';
import 'package:foodevenproject/features/user_auth/presentation/pages/order.dart';
import 'package:foodevenproject/features/user_auth/presentation/pages/order_history.dart';
import 'package:foodevenproject/features/user_auth/presentation/pages/profile.dart';

class BottomNav extends StatefulWidget {
  final String userId;

  const BottomNav({required this.userId, Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Home homepage;
  late Profile profile;
  late Order order;
  late OrderHistoryPage orderHistory;

  @override
  void initState() {
    super.initState();
    homepage = Home();
    order = Order();
    profile = Profile();
    orderHistory = OrderHistoryPage(userId: widget.userId);
    print("User ID in BottomNav: ${widget.userId}");
    pages = [
      homepage,
      order,
      orderHistory,
      profile,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Color(0xFFff5c30),
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Icon(
            Icons.home_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.history_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.person_outline,
            color: Colors.white,
          )
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
