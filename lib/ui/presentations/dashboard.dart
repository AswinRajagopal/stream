import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart'; // For shimmer effect
import '../../blocs/ui_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UIBloc, UIState>(
      builder: (context, state) {
        List<Map<String, String>> defaultMenuItems = [
          {"icon": "home", "label": "Home"},
          {"icon": "dashboard", "label": "Dashboard"},
          {"icon": "profile", "label": "Profile"},
          {"icon": "settings", "label": "Settings"},
        ];

        if (state is UILoaded && state.uiJson != null) {
          final dashboard = state.uiJson['dashboard'];
          final List<dynamic>? menuJson = dashboard?['menu'];

          final menuItems = menuJson != null && menuJson.isNotEmpty
              ? menuJson.cast<Map<String, dynamic>>() // Convert to list of maps
              : defaultMenuItems;

          return Scaffold(
            appBar: _buildAppBar(),
            body: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation, secondaryAnimation) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
              child: _getScreen(menuItems[_currentIndex]['label']),
            ),
            bottomNavigationBar: _buildBottomNavigationBar(menuItems),
          );
        }

        if (state is UIError) {
          return Scaffold(
            appBar: _buildAppBar(),
            body: Center(child: Text("Failed to load UI: ${state.message}")),
          );
        }

        return _shimmerLoadingEffect();
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "Rudo",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      elevation: 5,
    );
  }

  Widget _buildBottomNavigationBar(List<Map<String, dynamic>> menuItems) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 1),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          onTap: (index) => setState(() => _currentIndex = index),
          items: menuItems.map((item) {
            return BottomNavigationBarItem(
              icon: _getIcon(item['icon']),
              label: item['label'] ?? "Unnamed",
            );
          }).toList(),
        ),
      ),
    );
  }

  /// **Dynamic Screens with Animation**
  Widget _getScreen(String? screenName) {
    switch (screenName) {
      case "Home":
        return _animatedHomeScreen();
      case "Dashboard":
        return _animatedDashboardScreen();
      case "Profile":
        return _profileScreen();
      case "Settings":
        return _settingsScreen();
      default:
        return const Center(child: Text("📄 Default Screen"));
    }
  }

  Widget _animatedHomeScreen() {
    return Container(
      decoration: _backgroundGradient(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _animatedIcon(Icons.home, Colors.blueAccent),
            const SizedBox(height: 20),
            const Text(
              "Welcome Home!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _animatedDashboardScreen() {
    return Container(
      decoration: _backgroundGradient(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _animatedCard("📈 Sales Report", "View your latest sales trends", Colors.orange),
          _animatedCard("📊 User Analytics", "Track your user engagement", Colors.blue),
          _animatedCard("⚡ Performance", "Check app performance", Colors.green),
        ],
      ),
    );
  }

  /// **👤 Profile Screen**
  Widget _profileScreen() {
    return Container(
      decoration: _backgroundGradient(),
      child: Center(
        child: Text("👤 Profile Page", style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    );
  }

  /// **⚙️ Settings Screen**
  Widget _settingsScreen() {
    return Container(
      decoration: _backgroundGradient(),
      child: Center(
        child: Text("⚙️ Settings Page", style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    );
  }

  /// **Shimmer Loading Effect**
  Widget _shimmerLoadingEffect() {
    return Scaffold(
      body: Center(
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.white,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  /// **Helper: Animated Icon**
  Widget _animatedIcon(IconData icon, Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.5, end: 1.0),
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Icon(icon, size: 80, color: color),
        );
      },
    );
  }

  /// **Helper: Animated Cards**
  Widget _animatedCard(String title, String subtitle, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Text(title[0], style: TextStyle(fontSize: 20, color: color)),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, color: color),
      ),
    );
  }

  BoxDecoration _backgroundGradient() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blueAccent, Colors.purpleAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  Icon _getIcon(String? iconName) {
    final iconsMap = {
      "home": Icons.home,
      "dashboard": Icons.dashboard,
      "profile": Icons.person,
      "settings": Icons.settings,
    };
    return Icon(iconsMap[iconName] ?? Icons.circle);
  }
}
