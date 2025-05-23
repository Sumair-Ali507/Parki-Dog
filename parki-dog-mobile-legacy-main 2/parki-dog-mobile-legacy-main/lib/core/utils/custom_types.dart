import 'package:flutter/material.dart';

typedef WidgetItemBuilder<T> = Widget Function(T item, int index);

typedef DataParser<T> = T Function(dynamic);

typedef WidgetItemGetter = Widget Function(int position);

typedef SetterGetterFunction<T, V> = T Function(V);

typedef DropDownItemName<T> = String Function(T);

typedef DropDownItemChange<T> = void Function(T);

typedef UpdateDropDownChild<T> = void Function(int, int, T?);

typedef OnFilterCriteriaSelectionChange<T> = void Function(String, List<T>);
