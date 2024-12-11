import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/event_creation/shared/blocs/event_creation_bloc.dart';
import 'package:organizer_app/event_creation/shared/blocs/event_creation_event.dart';
import 'package:organizer_app/event_creation/shared/blocs/event_creation_state.dart';

class EventCreationNavigationBar extends StatelessWidget {
  final PageController pageController;

  const EventCreationNavigationBar({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCreationBloc, EventCreationState>(
      builder: (context, state) {
        if (state is! EventCreationReady) return const SizedBox.shrink();

        final currentPageIndex = state.currentPageIndex;
        final totalPages = 3; // Update if the total number of pages changes

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey, width: 0.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              if (currentPageIndex > 0)
                ElevatedButton(
                  onPressed: () {
                    context.read<EventCreationBloc>().add(NavigateBack());
                    pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Back'),
                )
              else
                const SizedBox(width: 80), // Placeholder for alignment

              // Next/Finish Button
              ElevatedButton(
                onPressed: () {
                  if (currentPageIndex < totalPages - 1) {
                    context.read<EventCreationBloc>().add(NavigateNext());
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    context.read<EventCreationBloc>().add(
                      FinalizeEventCreation(state.event),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(currentPageIndex == totalPages - 1
                    ? 'Finish'
                    : 'Next'),
              ),
            ],
          ),
        );
      },
    );
  }
}