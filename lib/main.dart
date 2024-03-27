import 'package:flutter/material.dart';
import 'package:sbbwu_google_maps/screens/my_peshawar_screen.dart';

// AIzaSyCNzxkMNNGAM9w8Edx9qzjkHq4h50VsChY
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyPeshawarScreen(),
    );
  }
}
