import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';

import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

class TermsView extends StatelessWidget {
  const TermsView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthCubit>().getTerms();
    return SafeArea(
      child: BlocBuilder<LangCubit, LangState>(builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Terms and conditions".tr()),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return state is LoadTermsState
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : state is SuccessTermsState
                        ? ListView.builder(
                            itemCount: state.terms.length,
                            itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${state.terms[index].title} :",
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.only(start: 10),
                                        child: Text(
                                          state.terms[index].body,
                                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                        : Center(
                            child: Text(
                              "No Data".tr(),
                              style: const TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          );
              },
            ),
          ),
        );
      }),
    );
  }
}
