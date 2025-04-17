import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/routes/app_route.dart';

class FavScreen extends StatelessWidget {
  const FavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fav Screen"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<AppRoute>().onFavDetail("1");
          },
          child: const Text("Detail screen"),
        ),
      ),
    );
  }
}
