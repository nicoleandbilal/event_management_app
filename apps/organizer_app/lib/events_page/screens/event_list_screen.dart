import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/events_page/blocs/event_filter_bloc.dart';
import 'package:organizer_app/events_page/choose_brand/blocs/choose_brand_dropdown_bloc.dart';
import 'package:organizer_app/events_page/choose_brand/widgets/choose_brand_dropdown.dart';
import 'package:organizer_app/events_page/widgets/organizer_event_list.dart';
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
  List<String>? selectedBrandIds;
  String? selectedStatus;

  // Access dependencies through GetIt
  final AuthService authService = GetIt.I<AuthService>();
  final BrandRepository brandRepository = GetIt.I<BrandRepository>();
  final EventRepository eventRepository = GetIt.I<EventRepository>();

  void _onBrandSelected(List<String> brandIds) {
    setState(() {
      selectedBrandIds = brandIds;
    });
    _applyCombinedFilter();
  }

  void _applyCombinedFilter() {
    if (selectedBrandIds == null || selectedBrandIds!.isEmpty) {
      // No brands selected, we can either show no events or do nothing
      // Here we choose to emit error or a clear state
      context.read<EventFilterBloc>().add(FilterEvents(brandIds: []));
      return;
    }

    context.read<EventFilterBloc>().add(
      FilterEvents(
        brandIds: selectedBrandIds!,
        status: selectedStatus,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ChooseBrandDropdown(
                    onBrandSelected: _onBrandSelected,
                  ),
                ),
                const Divider(height: 1, color: Colors.grey),

                // Create Event Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomPaddingButton(
                    onPressed: () {
                      if (selectedBrandIds == null || selectedBrandIds!.isEmpty) {
                        // Prompt the user to select a brand before creating an event
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
                        // Navigate to create event page for the first selected brand
                        context.push(
                          '/create_event/${selectedBrandIds!.first}',
                          extra: {
                            'eventRepository': eventRepository,
                            'authService': authService,
                          },
                        );
                      }
                    },
                    label: 'Create New Event',
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey,
                      minimumSize: const Size(double.infinity, 40),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const Divider(height: 1, color: Colors.grey),

                // Filters
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFilterButton(context, label: 'Drafts', status: 'draft'),
                      const SizedBox(width: 8),
                      _buildFilterButton(context, label: 'Current', status: 'live'),
                      const SizedBox(width: 8),
                      _buildFilterButton(context, label: 'Past', status: 'past'),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Colors.grey),

                // Event List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: BlocBuilder<EventFilterBloc, EventFilterState>(
                    builder: (context, state) {
                      if (state is EventFilterLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is EventFilterLoaded) {
                        if (state.filteredEvents.isEmpty) {
                          return const Center(child: Text('No events available for the selected filter.'));
                        }
                        return OrganizerEventList(events: state.filteredEvents);
                      } else if (state is EventFilterError) {
                        return Center(child: Text(state.errorMessage));
                      } else {
                        // Initial or empty state
                        return const Center(child: Text('No events available.'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

  Widget _buildFilterButton(BuildContext context, {required String label, required String status}) {
    return Expanded(
      child: CustomPaddingButton(
        onPressed: () {
          setState(() {
            selectedStatus = status;
          });
          _applyCombinedFilter();
        },
        label: label,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.grey,
          minimumSize: const Size(0, 30),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}