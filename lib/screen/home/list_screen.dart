import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/routes/app_router_delegate.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Screen"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<AppRouterDelegate>().onDetail();
          },
          child: const Text("Detail screen"),
        ),
      ),
    );
  }
}
