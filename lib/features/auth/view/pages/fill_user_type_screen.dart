import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/widgets/push_button.dart';
import 'package:parki_dog/core/widgets/step_progress_bar.dart';
import 'package:parki_dog/features/auth/data/user_model.dart';
import 'package:parki_dog/features/auth/view/pages/fill_personal_screen.dart';

class FillUserTypeScreen extends StatefulWidget {
  const FillUserTypeScreen({super.key, required this.userModel,required this.password});

  final UserModel userModel;
  final String password;

  @override
  State<FillUserTypeScreen> createState() => _FillUserTypeScreenState();
}

class _FillUserTypeScreenState extends State<FillUserTypeScreen> {
  String? selectedUserType;
  final int currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('What describes you?'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                StepProgressBar(
                  currentStep: currentStep,
                  totalSteps: 3,
                  height: 8,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildUserTypeCard(
                      'Dog Owner',
                      'I want to find services for my dog',
                      'assets/new-images/dog-owner.svg',
                      'owner',
                    ),
                    _buildUserTypeCard(
                      'Veterinarian',
                      'I want to offer services for dogs',
                      'assets/new-images/vet.svg',
                      'vet',
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildUserTypeCard(
                      'Dog Trainer',
                      'I want to find services for my dog',
                      'assets/new-images/trainer.svg',
                      'trainer',
                    ),
                    _buildUserTypeCard(
                      'Washing Shop',
                      'I want to offer services for dogs',
                      'assets/new-images/washing-shop.svg',
                      'shop',
                    ),
                  ],
                ),

                // const SizedBox(height: 16),
                // _buildUserTypeCard(
                //   'Service Provider',
                //   'I want to offer services for dogs',
                //   Icons.business_center,
                //   'provider',
                // ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        child: PushButton(
          text: 'Next'.tr(),
          onPress: selectedUserType == null
              ? null
              : () {
                  _onNextPressed(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const FillPersonalScreen()),
                  // );
                },
        ),
      ),
    );
  }

  Widget _buildUserTypeCard(
      String title, String description, String icon, String type) {
    final isSelected = selectedUserType == type;

    return InkWell(
      onTap: () {
        setState(() {
          selectedUserType = type;
        });
      },
      child: Container(
        width: 150,
        height: 180,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppColors.primary.withOpacity(0.4)
              : Color(0xFFF3F4F6),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: SvgPicture.asset(
                icon,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.primary : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onNextPressed(BuildContext context) {
    if (selectedUserType == 'owner') {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => FillPersonalScreen(userModel: widget.userModel, password: widget.password,)));
    } else {
      // Navigator.of(context).pushNamed('/auth/signup/fill-provider');
    }
  }
}
