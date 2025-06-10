import 'package:flutter/material.dart';

class SignInSecurityScreen extends StatelessWidget {
  const SignInSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Sign-in & security',
          style: TextStyle(
            fontSize: 20, // matches image
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            _buildTile(
              icon: Icons.email_outlined,
              title: 'Email Address',
              subtitle: 'ahmednafee361@gmail.com',
              onTap: () {},
            ),
            const SizedBox(height: 28),
            _buildTile(
              icon: Icons.vpn_key_outlined,
              title: 'Password',
              subtitle: 'Last Update 02/03/2024',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: const Color(0xFFF2F2F2),
          child: Icon(
            icon,
            size: 22, // matches image
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5, // lighter/smaller label
                  color: Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12, // bold visible value
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: const Text(
            'Change',
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF875CFF),
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }
}
