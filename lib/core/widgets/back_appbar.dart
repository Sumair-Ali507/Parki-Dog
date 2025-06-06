import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parki_dog/core/extensions/extenstions.dart';
import 'package:parki_dog/core/utils/assets_manager.dart';

class BackAppBar extends StatelessWidget {
  const BackAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          context.pop();
        },
        icon: SvgPicture.asset(ImageAssets.back));
  }
}
