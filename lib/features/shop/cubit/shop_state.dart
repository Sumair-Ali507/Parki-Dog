import 'package:flutter/cupertino.dart';

@immutable
abstract class ShopState {}

class ShopInitial extends ShopState {}

class ShopSortEachCategoryToHisContainerState extends ShopState {}

class AddItemToBagState extends ShopState {}

class RemoveItemFromBagState extends ShopState {}

class SearchShopState extends ShopState {}

class AddOrderToFireBase extends ShopState {}

class ChangeCarouselPosition extends ShopState {}
