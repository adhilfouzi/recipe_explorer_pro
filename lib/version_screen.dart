import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionScreen extends StatelessWidget {
  const VersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: Text('LOgo'),
        ),
        SizedBox(height: height * 0.01),
        // Image.asset(
        //   Images.madeInBharat,
        //   scale: 4.5,
        // ),
        SizedBox(height: height * 0.01),
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                'Cook Book Version ${snapshot.data!.version}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              );
            } else {
              return Text(
                'Cook Book Version Loading...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              );
            }
          },
        ),
        SizedBox(height: height * 0.02),
      ],
    );
  }
}
