import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/routes/auth_router_delegate.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings Screen"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<AuthRouterDelegate>().onLogout();
          },
          child: const Text("Log out"),
        ),
      ),
    );
  }
}
