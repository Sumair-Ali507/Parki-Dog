import 'package:flutter/material.dart';

class AccountDetailTile extends StatelessWidget {
  const AccountDetailTile(
      {super.key, required this.icon, required this.title, required this.info});

  final Widget icon;
  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 0,
      contentPadding: EdgeInsets.zero,
      leading: icon,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
      ),
      trailing: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        child: Text(
          info,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
