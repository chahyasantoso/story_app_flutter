import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/firebase_auth_provider.dart';
import 'package:story_app/provider/story_auth_provider.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/routes/app_router_delegate.dart';
import 'package:story_app/static/auth_status.dart';

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
          onPressed: () async {
            await context.read<StoryAuthProvider>().logoutUser();

            if (!context.mounted) return;
            context.read<AppRoute>().onLanding();
          },
          child: Consumer<StoryAuthProvider>(
            builder: (context, authProvider, child) {
              return switch (authProvider.authStatus) {
                SigningOut() => const CircularProgressIndicator(),
                _ => const Text("Log out"),
              };
            },
          ),
        ),
      ),
    );
  }
}
