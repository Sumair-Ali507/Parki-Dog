import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parki_dog/features/map/cubit/map_cubit.dart';

import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

class SearchThisAreaButton extends StatelessWidget {
  const SearchThisAreaButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<LangCubit, LangState>(builder: (context, state) {
        return IntrinsicWidth(
          child: ElevatedButton(
            onPressed: () async {
              await context.read<MapCubit>().getMapNearbyParks();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, color: Colors.blue.shade600, size: 20),
                const SizedBox(width: 4),
                Text(
                  'Search this area'.tr(),
                  style: TextStyle(
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
