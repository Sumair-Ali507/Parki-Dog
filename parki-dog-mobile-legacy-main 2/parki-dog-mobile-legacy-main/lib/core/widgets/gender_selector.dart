import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/widgets/push_button.dart';

class GenderSelector extends StatefulWidget {
  const GenderSelector({super.key, this.selectionMode = 'single', this.initialValue});

  final String selectionMode;
  final List<String>? initialValue;

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  List<String> selected = [];
  List<String> initVal = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      for (var element in widget.initialValue!) {
        initVal.add(element);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<List<String>>(
      name: 'Gender'.tr(),
      builder: (field) {
        return InputDecorator(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            errorText: field.errorText,
            errorBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
            border: const UnderlineInputBorder(borderSide: BorderSide.none),
          ),
          child: Row(
            children: [
              Expanded(child: buildButton('Male'.tr(), field)),
              const SizedBox(width: 8),
              Expanded(child: buildButton('Female'.tr(), field))
            ],
          ),
        );
      },
      validator: (value) {
        if (widget.selectionMode == 'multiple'.tr()) return null;

        if (value == null || value.isEmpty) {
          return 'Required';
        }

        return null;
      },
    );
  }

  void toggleSelectionMultiple(String value, FormFieldState field) {
    if (selected.contains(value)) {
      selected.remove(value);
    } else {
      selected.add(value);
    }
    field.didChange(selected);

    setState(() {});

    // if (widget.selected.contains(value) && widget.selected.length > 1) {
    //   widget.selected.remove(value);
    // } else if (!widget.selected.contains(value)) {
    //   widget.selected.add(value);
    // }
    // setState(() {});
  }

  void toggleSelection(String value, FormFieldState field) {
    if (!selected.contains(value)) {
      selected.clear();
      selected.add(value);
      field.didChange(selected);
      setState(() {});
    }
  }

  PushButton buildButton(String text, FormFieldState field) {
    if (initVal.contains(text)) {
      Future.delayed(Duration.zero, () async {
        toggleSelectionMultiple(text, field);
        initVal.remove(text);
      });
    }
    return PushButton(
      text: text,
      onPress: () {
        widget.selectionMode == 'single' ? toggleSelection(text, field) : toggleSelectionMultiple(text, field);
      },
      height: 40,
      borderRadius: 8,
      fontSize: 14,
      icon: Image.asset(
        'assets/icons/${text.toLowerCase()}.png',
        color: selected.contains(text) ? Colors.white : Colors.black,
      ),
      fontWeight: selected.contains(text) ? FontWeight.w600 : FontWeight.w300,
      color: selected.contains(text) ? AppColors.secondary : Colors.transparent,
      fill: selected.contains(text) ? true : false,
      textColor: selected.contains(text) ? Colors.white : Colors.black,
    );
  }
}
