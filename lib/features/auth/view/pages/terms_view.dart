import 'package:flutter/material.dart';
import 'package:parki_dog/core/widgets/back_appbar.dart';
import 'package:parki_dog/features/auth/view/widgets/terms_and_conditions_content.dart';

class TermsView extends StatelessWidget {
  final bool isItalian; // Pass this flag to control language

  const TermsView({super.key, this.isItalian = false});

  @override
  Widget build(BuildContext context) {
    final terms = isItalian
        ? termsAndConditionsContentItalian
        : termsAndConditionsContentEnglish;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Terms & Conditions',
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: terms.length,
        itemBuilder: (context, index) {
          final term = terms[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  term['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  term['content'] ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ));
  }
}
