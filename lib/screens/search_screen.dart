import 'package:flutter/material.dart';
import 'profile_screen.dart';
import '../services/api_service.dart';

/// View 1: login text field + search button.
/// Pushes ProfileScreen on success, shows an error message otherwise.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.api});
  final ApiService api;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  bool _loading = false;

  // free resources when the widget is disposed
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Performs a search for a user by their login.
  Future<void> _search() async {
    setState(() => _loading = true);
    try {
      // fetch user by the login
      final user = await widget.api.fetchUser(_controller.text);
      final imageHeaders = await widget.api.imageHeaders();
      // mounted is a property that indicates whether the widget is still in the widget tree.
      if (!mounted) return;
      // push the ProfileScreen with the fetched user
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileScreen(user: user, imageHeaders: imageHeaders),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      // show a snackbar (small alert at the bottom) with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Swifty Companion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter 42 login'),
              onSubmitted: (_) => _loading ? null : _search(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _search,
              child: _loading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Search'),
            ),
          ],
        )
      )
    );
  }
}
