import 'package:flutter/material.dart';

import '../../../../core/utils/values_manager.dart';

class TermsAndConditionItem extends StatelessWidget {
  final String title;
  final String description;
  const TermsAndConditionItem({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDouble.d16),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: AppDouble.d16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: AppDouble.d8),
            Text(
              description,
              style: TextStyle(
                fontSize: AppDouble.d14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            )
          ]),
    );
  }
}
