import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/widgets/frost.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/home/view/widgets/blurred_dog_tile.dart';

import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

class ViewAllDogs extends StatelessWidget {
  const ViewAllDogs(this.dogs, {super.key});

  final List<DogModel> dogs;

  @override
  Widget build(BuildContext context) {
    return Frost(
      child: BlocBuilder<LangCubit, LangState>(builder: (context, state) {
        return Scaffold(
          extendBody: true,
          backgroundColor: Colors.black.withOpacity(0.8),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Checked in dogs'.tr(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ),
          body: Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.all(24),
                itemBuilder: (BuildContext context, int index) {
                  return BlurredDogTile(dogs[index]);
                },
                itemCount: dogs.length,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                        backgroundColor: MaterialStateProperty.all(Colors.transparent),
                        elevation: MaterialStateProperty.all(0),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48),
                            side: const BorderSide(
                              width: 2,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
