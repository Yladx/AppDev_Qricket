import 'package:flutter/material.dart';
import 'screens/event_selection_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Mark Tech Conference 2024 and Music Festival as participated
  await SharedPreferencesStorageService.setParticipatedEventIds([
    '1000000001', // Tech Conference 2024 (ongoing)
    '1000000002', // Music Festival (ended)
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qricket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF00B388)),
        useMaterial3: true,
      ),
      home: const EventSelectionScreen(),
    );
  }
}
