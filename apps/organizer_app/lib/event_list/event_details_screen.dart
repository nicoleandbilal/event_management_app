import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:organizer_app/event_list/edit_event_details_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final CollectionReference _eventsCollection =
      FirebaseFirestore.instance.collection('events');

  bool _isLoading = true;
  bool _isError = false;
  String? _errorMessage;
  DocumentSnapshot<Object?>? _eventData;

  @override
  void initState() {
    super.initState();
    _fetchEventDetails();
  }

  Future<void> _fetchEventDetails() async {
    try {
      final DocumentSnapshot<Object?> eventSnapshot =
          await _eventsCollection.doc(widget.eventId).get();
      if (eventSnapshot.exists) {
        setState(() {
          _eventData = eventSnapshot;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isError = true;
          _errorMessage = "Event not found";
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isError = true;
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteEvent(BuildContext context) async {
    try {
      await _eventsCollection.doc(widget.eventId).delete();
      Navigator.pop(context); // Go back to the previous screen after deletion
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting event: $error')),
      );
    }
  }

  void _navigateToEditEvent(BuildContext context) async {
    final bool? isUpdated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventScreen(eventId: widget.eventId),
      ),
    );

    if (isUpdated == true) {
      _fetchEventDetails(); // Refresh event details after editing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : _isError
              ? Center(child: Text(_errorMessage ?? 'An error occurred')) // Handle errors
              : _buildEventDetails(context), // Build UI if no error
    );
  }

  Widget _buildEventDetails(BuildContext context) {
    final data = _eventData!.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Name
            Text(
              data['eventName'] ?? 'No Name',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Event Description
            Text(
              data['description'] ?? 'No Description',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Event Date and Time
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 5),
                Text(
                  data['startDateTime'] != null
                      ? (data['startDateTime'] as Timestamp).toDate().toLocal().toString()
                      : 'No Date',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Buttons: Edit and Delete
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _navigateToEditEvent(context),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Event'),
                        content: const Text('Are you sure you want to delete this event?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      _deleteEvent(context); // Delete the event if confirmed
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
