import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            ListTile(
              title: const Text('English'),
              trailing: Radio(
                  value: 'en',
                  groupValue: context.read<LangCubit>().lang,
                  onChanged: (v) async {
                    context.read<LangCubit>().changeLang('en', context);
                  }),
            ),
            const SizedBox(
              height: 50,
            ),
            ListTile(
              title: const Text('italiano'),
              trailing: Radio(
                  value: 'it',
                  groupValue: context.read<LangCubit>().lang,
                  onChanged: (v) async {
                    context.read<LangCubit>().changeLang('it', context);
                  }),
            )
          ],
        ),
      );
    });
  }
}
