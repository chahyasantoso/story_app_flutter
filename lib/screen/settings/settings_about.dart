import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:story_app/static/flavor_type.dart';
import 'package:story_app/style/typography/story_text_styles.dart';

class SettingsAbout extends StatelessWidget {
  const SettingsAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 4,
        children: [
          FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
              if (!snapshot.hasData) return SizedBox();
              PackageInfo? packageInfo = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 4,
                children: [
                  Text(
                    "${packageInfo?.appName}",
                    style: StoryTextStyles.titleLarge,
                  ),
                  Text(
                    "${packageInfo?.packageName}",
                    style: StoryTextStyles.bodySmall,
                  ),
                  Text(
                    "Version: ${packageInfo?.version}",
                    style: StoryTextStyles.bodySmall,
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 16),
          Text("Flavor: ${FlavorConfig.instance.flavor.name}"),
          Text("Mode: ${FlutterModeConfig.flutterMode}"),
        ],
      ),
    );
  }
}
