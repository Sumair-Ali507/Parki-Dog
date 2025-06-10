import 'package:flutter/material.dart';
import 'package:parki_dog/core/utils/values_manager.dart';

//need to custom styles of popup
class CustomPopupMenuButton<T> extends StatelessWidget {
  // final Widget items;
  final List<CustomPopupMenuItem<T>> items;
  final Widget child;
  final Function(T) onSelected;

  const CustomPopupMenuButton(
      {super.key,
      required this.items,
      required this.child,
      required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      onSelected: onSelected,
      position: PopupMenuPosition.under,
      splashRadius: AppDouble.d16,
      tooltip: '',
      constraints: BoxConstraints(
          minWidth: MediaQuery.sizeOf(context).width - AppDouble.d48),
      // elevation: 1.5,
      // shadowColor: Colors.grey.shade400,
      // surfaceTintColor: Colors.white,
      // padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context) {
        return items;
      },
      child: child,
    );
  }
}

class CustomPopupMenuItem<T> extends PopupMenuItem<T> {
  const CustomPopupMenuItem(
      {super.key, required Widget child, required T value})
      : super(value: value, child: child);

  @override
  PopupMenuItemState<T, CustomPopupMenuItem<T>> createState() =>
      _CustomPopupMenuItemState<T>();
}

class _CustomPopupMenuItemState<T>
    extends PopupMenuItemState<T, CustomPopupMenuItem<T>> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, widget.value);
      },
      borderRadius: BorderRadius.circular(AppDouble.d16),
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: AppDouble.d10, horizontal: AppDouble.d20),
        child: widget.child,
      ),
    );
  }
}
