// lib/screens/search/search_screen.dart

import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Implement your search screen here
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const Center(
        child: Text('Search Screen'),
      ),
    );
  }
}
