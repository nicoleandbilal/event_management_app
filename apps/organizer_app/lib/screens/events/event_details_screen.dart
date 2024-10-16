// lib/screens/event_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventDetailsScreen extends StatelessWidget {
  final String eventId;

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    // Fetch the specific event document from Firestore
    CollectionReference events = FirebaseFirestore.instance.collection('events');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: events.doc(eventId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          // Handle error state
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong: ${snapshot.error}'),
            );
          }

          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Check if document exists
          if (!snapshot.data!.exists) {
            return const Center(
              child: Text('Event does not exist'),
            );
          }

          // Retrieve event data
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Name
                  Text(
                    data['name'] ?? 'No Name',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Event Description
                  Text(
                    data['description'] ?? 'No Description',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Event Timestamp
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        data['timestamp'] != null
                            ? (data['timestamp'] as Timestamp)
                                .toDate()
                                .toLocal()
                                .toString()
                            : 'No Date',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Optional: Edit and Delete Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to Edit Event Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditEventScreen(eventId: eventId),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () async {
                          // Confirm deletion
                          bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Event'),
                              content:
                                  const Text('Are you sure you want to delete this event?'),
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

                          if (confirm != null && confirm) {
                            // Delete the event
                            await events.doc(eventId).delete();
                            Navigator.pop(context); // Go back after deletion
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
        },
      ),
    );
  }
}

// Optional: EditEventScreen for editing existing events
class EditEventScreen extends StatefulWidget {
  final String eventId;

  const EditEventScreen({super.key, required this.eventId});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';

  // Fetch current event data
  Future<void> _fetchEventData() async {
    DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .get();

    if (eventSnapshot.exists) {
      Map<String, dynamic> data =
          eventSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _name = data['name'] ?? '';
        _description = data['description'] ?? '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchEventData();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Update the event in Firestore
      await FirebaseFirestore.instance.collection('events').doc(widget.eventId).update({
        'name': _name,
        'description': _description,
        'timestamp': FieldValue.serverTimestamp(),
      });
      Navigator.pop(context); // Go back after updating
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Event'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: (_name.isEmpty && _description.isEmpty)
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _name,
                        decoration: const InputDecoration(labelText: 'Event Name'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Enter event name' : null,
                        onSaved: (value) => _name = value ?? '',
                      ),
                      TextFormField(
                        initialValue: _description,
                        decoration: const InputDecoration(labelText: 'Event Description'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter event description'
                            : null,
                        onSaved: (value) => _description = value ?? '',
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submit,
                        child: const Text('Update Event'),
                      ),
                    ],
                  ),
                ),
        ));
  }
}
