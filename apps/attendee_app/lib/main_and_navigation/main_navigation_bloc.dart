// main_navigation_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Define Events
abstract class MainNavigationEvent extends Equatable {
  const MainNavigationEvent();

  @override
  List<Object> get props => [];
}

class TabSelectedEvent extends MainNavigationEvent {
  final int index;

  const TabSelectedEvent(this.index);

  @override
  List<Object> get props => [index];
}

// Define States
abstract class MainNavigationState extends Equatable {
  const MainNavigationState();

  @override
  List<Object> get props => [];
}

class TabSelectedState extends MainNavigationState {
  final int currentIndex;
  final bool isFullScreenRoute;

  const TabSelectedState(this.currentIndex, this.isFullScreenRoute);

  @override
  List<Object> get props => [currentIndex, isFullScreenRoute];
}

// Main Bloc for Navigation
class MainNavigationBloc extends Bloc<MainNavigationEvent, MainNavigationState> {
  final List<String> _tabs = ['/home', '/search', '/meet', '/mytickets', '/profile'];
  final List<String> _fullScreenRoutes = [
  ];

  MainNavigationBloc() : super(const TabSelectedState(0, false)) {
    on<TabSelectedEvent>((event, emit) {
      final isFullScreenRoute = _isFullScreenRoute(event.index);
      emit(TabSelectedState(event.index, isFullScreenRoute));
    });
  }

  bool _isFullScreenRoute(int index) {
    final currentRoute = _tabs[index];
    return _fullScreenRoutes.contains(currentRoute);
  }

  String getRoute(int index) {
    return _tabs[index];
  }

  String getAppBarTitle(int index) {
    switch (_tabs[index]) {
      case '/home':
        return 'Home';
      case '/search':
        return 'Search';
      case '/meet':
        return 'Meet';
      case '/myTickets':
        return 'My Tickets';
      case '/profile':
        return 'Profile';
      default:
        return 'App Title';
    }
  }
}
