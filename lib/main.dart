import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/search_screen.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final api = ApiService(AuthService());
  runApp(MyApp(api: api));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.api});
  final ApiService api;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swifty Companion',
      home: SearchScreen(api: api),
    );
  }
}
