import 'package:flutter/material.dart';

class RecommendedSearchWidget extends StatelessWidget {
  final String searchText;
  final void Function() onTap;
  const RecommendedSearchWidget({
    super.key,
    required this.searchText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(searchText),
                const Icon(Icons.search),
              ],
            ),
          ),
          const Divider()
        ],
      ),
    );
  }
}
