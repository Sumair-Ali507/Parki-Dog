import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Change Language'),
        ),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Divider(
                color: Colors.black12,
              ),
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
