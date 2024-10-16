// lib/widgets/event_list_item.dart

import 'package:flutter/material.dart';

class EventListItem extends StatelessWidget {
  final String name;
  final String description;
  final VoidCallback onTap;

  const EventListItem({
    super.key,
    required this.name,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.event),
      title: Text(name),
      subtitle: Text(description),
      onTap: onTap,
    );
  }
}
