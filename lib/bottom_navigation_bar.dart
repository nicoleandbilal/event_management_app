import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_management_app/blocs/navigation/navigation_bloc.dart';
import 'package:event_management_app/screens/home/home_screen.dart';
import 'package:event_management_app/screens/profile_screen.dart';
import 'package:event_management_app/screens/event_detail/event_detail_screen.dart';


class HomePage extends StatelessWidget {
  final List<Widget> _pages = [
    HomeScreen(),
    const EventDetailScreen(),
    const ProfileScreen(),
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        int currentIndex = 0;
        if (state is HomeTab) currentIndex = 0;
        if (state is EventTab) currentIndex = 1;
        if (state is ProfileTab) currentIndex = 2;

        return Scaffold(
          body: _pages[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              BlocProvider.of<NavigationBloc>(context).add(SelectTab(index));
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}
