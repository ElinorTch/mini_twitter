import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined, size: 28,),
          selectedIcon: Icon(Icons.home, size: 28,),
          label: 'Feed',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_box_outlined, size: 28,),
          selectedIcon: Icon(Icons.add_box, size: 28,),
          label: 'Post',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline, size: 28,),
          selectedIcon: Icon(Icons.person, size: 28,),
          label: 'Profil',
        ),
      ],
      )
    );
  }
}