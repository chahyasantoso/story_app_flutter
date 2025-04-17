import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/routes/app_route.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Screen"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<AppRoute>().onHomeDetail("1");
          },
          child: const Text("Detail screen"),
        ),
      ),
    );
  }
}
