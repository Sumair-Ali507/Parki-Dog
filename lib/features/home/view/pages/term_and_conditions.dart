// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:parki_dog/core/extensions/extenstions.dart';

// import '../../../../core/utils/values_manager.dart';
// import '../../../../core/widgets/back_appbar.dart';
// import '../../../../generated/locale_keys.g.dart';
// import '../widgets/term_and_condition_item.dart';

// class TermsAndConditionsScreen extends StatelessWidget {
//   const TermsAndConditionsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(LocaleKeys.menu_termsAndConditions).tr(),
//         leading: const BackAppBar(),
//       ),
//       body: ListView.builder(
//         padding: EdgeInsets.all(AppDouble.d16),
//         itemCount: termsAndConditionsContentEnglish.length,
//         itemBuilder: (context, index) => TermsAndConditionItem(
//             title: context.isEnglish
//                 ? termsAndConditionsContentEnglish[index]['title'] ?? ''
//                 : termsAndConditionsContentItalian[index]['title'] ?? '',
//             description: context.isEnglish
//                 ? termsAndConditionsContentEnglish[index]['content'] ?? ''
//                 : termsAndConditionsContentItalian[index]['content'] ?? ''),
//       ),
//     );
//   }
// }
