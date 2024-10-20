import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditEventScreen extends StatefulWidget {
  final String eventId;

  const EditEventScreen({super.key, required this.eventId});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String _eventName = '';
  String _description = '';
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  String _category = '';
  String _venue = '';
  String? _imageUrl;

  // Fetch current event data
  Future<void> _fetchEventData() async {
    DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .get();

    if (eventSnapshot.exists) {
      Map<String, dynamic> data = eventSnapshot.data() as Map<String, dynamic>;

      setState(() {
        _eventName = data['eventName'] ?? '';
        _description = data['description'] ?? '';
        _startDateTime = (data['startDateTime'] as Timestamp).toDate();
        _endDateTime = (data['endDateTime'] as Timestamp).toDate();
        _category = data['category'] ?? '';
        _venue = data['venue'] ?? '';
        _imageUrl = data['imageUrl'] ?? '';
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
        'eventName': _eventName,
        'description': _description,
        'startDateTime': Timestamp.fromDate(_startDateTime!),
        'endDateTime': Timestamp.fromDate(_endDateTime!),
        'category': _category,
        'venue': _venue,
        'imageUrl': _imageUrl,
      });

      Navigator.pop(context, true);  // <--- Return true after successful update
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
        child: (_eventName.isEmpty && _description.isEmpty)
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _eventName,
                      decoration: const InputDecoration(labelText: 'Event Name'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter event name' : null,
                      onSaved: (value) => _eventName = value ?? '',
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
      ),
    );
  }
}
