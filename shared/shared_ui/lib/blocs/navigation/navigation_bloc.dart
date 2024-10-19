import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Events for Navigation
abstract class NavigationEvent extends Equatable {
  const NavigationEvent();
}

class SelectTab extends NavigationEvent {
  final int tabIndex;
  const SelectTab(this.tabIndex);
  
  @override
  List<Object> get props => [tabIndex];
}

// States for Navigation
abstract class NavigationState extends Equatable {
  const NavigationState();
}

class HomeTab extends NavigationState {
  @override
  List<Object> get props => [];
}

class ProfileTab extends NavigationState {
  @override
  List<Object> get props => [];
}

class EventTab extends NavigationState {
  @override
  List<Object> get props => [];
}

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(HomeTab());

  Stream<NavigationState> mapEventToState(NavigationEvent event) async* {
    if (event is SelectTab) {
      if (event.tabIndex == 0) {
        yield HomeTab();
      } else if (event.tabIndex == 1) {
        yield EventTab();
      } else if (event.tabIndex == 2) {
        yield ProfileTab();
      }
    }
  }
}
