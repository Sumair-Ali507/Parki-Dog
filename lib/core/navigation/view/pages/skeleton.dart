import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parki_dog/core/navigation/cubit/navigation_cubit.dart';
import 'package:parki_dog/core/navigation/view/widgets/nav_bar.dart';
import 'package:parki_dog/features/home/view/pages/home_screen.dart';
import 'package:parki_dog/features/map/view/pages/map_screen.dart';

import '../../../../features/account/view/pages/account_screen.dart';
import '../../../../features/lang/lang_cubit.dart';
import '../../../../features/lang/lang_state.dart';
import '../../../../features/shop/view/pages/shop_page.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationCubit, NavigationState>(
      listenWhen: (previous, current) => current is NavigationBottomSheet,
      listener: (context, state) => showModalBottomSheet(
        context: context,
        builder: (_) => (state as NavigationBottomSheet).child,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        showDragHandle: true,
      ),
      child: BlocBuilder<LangCubit, LangState>(builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              // Top safe area black container
              Container(
                color: Colors.black,
                height: MediaQuery.of(context).padding.top,
              ),
              Expanded(
                child: BlocConsumer<NavigationCubit, NavigationState>(
                    bloc: context.read<NavigationCubit>()..changeIndex(0),
                    listenWhen: (previous, current) =>
                        current is NavigationIndex && current.index == 2,
                    listener: (context, state) {},
                    buildWhen: (previous, current) =>
                        current is NavigationIndex,
                    builder: (context, state) {
                      return IndexedStack(
                        index: (state as NavigationIndex).index,
                        children: [
                          HomeScreen(
                            parks: [],
                          ),
                          MapScreen(),
                          AccountScreen()
                        ],
                      );
                    }),
              ),
            ],
          ),
          bottomNavigationBar: const NavBar(), // Our custom navigation bar
          extendBody: true,
        );
      }),
    );
  }
}
