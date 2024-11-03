import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/choose_brand/choose_brand_dropdown.dart';
import 'package:organizer_app/choose_brand/choose_brand_dropdown_bloc.dart';
import 'package:organizer_app/event_list/event_filter_bloc.dart';
import 'package:organizer_app/event_list/organizer_event_list.dart';
import 'package:shared/repositories/event_repository.dart';
import 'package:shared/repositories/brand_repository.dart';
import 'package:shared/authentication/auth/auth_service.dart';
import 'package:shared/widgets/custom_padding_button.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  EventListScreenState createState() => EventListScreenState();
}

class EventListScreenState extends State<EventListScreen> {
  String? selectedBrandId; // Store selected brand ID

  // Callback to filter events when a brand is selected.
  void _onBrandSelected(String brandId) {
    print("Brand selected: $brandId"); // Debugging print statement
    selectedBrandId = brandId; // Store the selected brand ID
    context.read<EventFilterBloc>().add(FilterEventsByBrand(brandId: brandId));
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final brandRepository = context.read<BrandRepository>();
    final eventRepository = context.read<EventRepository>();

    return BlocProvider(
      create: (context) => ChooseBrandDropdownBloc(
        brandRepository: brandRepository,
        authService: authService,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ChooseBrandDropdown(
              onBrandSelected: _onBrandSelected,
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          const SizedBox(height: 10),

          // Button to create a new event
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomPaddingButton(
              onPressed: () {
                if (selectedBrandId == null || selectedBrandId!.isEmpty) {
                  print("Error: No brand selected.");
                  // Display a dialog or a snackbar to inform the user
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Please select a brand before creating an event.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  print("Navigating to create event screen for brandId: $selectedBrandId");
                  context.push(
                    '/create_event/$selectedBrandId',
                    extra: {
                      'eventRepository': eventRepository,
                      'authService': authService,
                    },
                  );
                }
              },
              label: 'Create New Event',
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                ),
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey,
                minimumSize: const Size(double.infinity, 40),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          const SizedBox(height: 10),

          // Filter buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton(context, label: 'Drafts', status: 'draft'),
                const SizedBox(width: 8),
                _buildFilterButton(context, label: 'Current', status: 'current'),
                const SizedBox(width: 8),
                _buildFilterButton(context, label: 'Past', status: 'past'),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),

          // Organizer-specific event list
          Expanded(
            child: BlocBuilder<EventFilterBloc, EventFilterState>(
              builder: (context, state) {
                if (state is EventFilterLoading) {
                  print("Loading events..."); // Debugging print statement
                  return const Center(child: CircularProgressIndicator());
                } else if (state is EventFilterLoaded) {
                  print("Events loaded: ${state.filteredEvents.length}"); // Debugging print statement
                  return OrganizerEventList(events: state.filteredEvents);
                } else if (state is EventFilterError) {
                  print("Error loading events: ${state.errorMessage}"); // Debugging print statement
                  return Center(child: Text(state.errorMessage));
                }
                return const Center(child: Text('No events available.'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, {required String label, required String status}) {
    return Expanded(
      child: CustomPaddingButton(
        onPressed: () {
          print("Filter button clicked: $status"); // Debugging print statement
          context.read<EventFilterBloc>().add(FilterEventsByStatus(status: status));
        },
        label: label,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.0),
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.grey,
          minimumSize: const Size(0, 30),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}
