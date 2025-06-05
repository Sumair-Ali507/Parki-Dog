import 'package:flutter/material.dart';

import '../../../../core/utils/values_manager.dart';


class OurMissionHowItWorksComponent extends StatelessWidget {
  final String title;
  final String content;

  const OurMissionHowItWorksComponent({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: AppDouble.d16),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[400],
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}