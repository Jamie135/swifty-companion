import 'package:flutter/material.dart';

/// View 1: login text field + search button. Pushes ProfileScreen on success,
/// shows an error message otherwise.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Search')));
  }
}
