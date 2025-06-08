import 'package:carousel_slider/carousel_controller.dart' ; 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parki_dog/features/shop/cubit/shop_state.dart';
import 'package:pay/pay.dart';
import '../data/item_model.dart';
import '../data/shop_repository.dart';
import '../view/pages/payment_button.dart';

class ShopCubit extends Cubit<ShopState> {
  ShopCubit() : super(ShopInitial());

  static ShopCubit get(BuildContext context) => BlocProvider.of(context);
  List<ItemDetails> foodContainer = [];
  List<ItemDetails> clothesContainer = [];
  List<ItemDetails> toysContainer = [];
  List<ItemDetails> othersContainer = [];
  List<ItemDetails> bagContainer = [];
  List<ItemDetails> searchContainer = [];
  List<PaymentItem> paymentItem = [];
  double totalItemsPrice = 0.0;
  int callOnce = 0;

  int howManyItemInBag = 0;
  CarouselSliderController carouselController = CarouselSliderController();
  TextEditingController searchController = TextEditingController();
  changeCarouselPosition({required int index}) {
    carouselController.animateToPage(index);
    emit(ChangeCarouselPosition());
  }

  void showToaster() {
    Fluttertoast.showToast(
      msg: 'Item has been added to bag',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP_RIGHT,
      timeInSecForIosWeb: 1,
      fontSize: 16.0,
    );
  }

  void showPaymentButton({required BuildContext context}) {
    changeItemToPayment();
    showDialog(
      useSafeArea: true,
      barrierColor: Colors.black87,
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return PaymentButton(
          paymentItemList: paymentItem,
          onPressed: () {
            ShopRepository.addOrderToFirestore(itemList: bagContainer);
            bagContainer = [];
            totalItemsPrice = 0;
            emit(AddOrderToFireBase());
          },
        ); // Custom widget for your dialog content
      },
    );
  }

  changeItemToPayment() {
    paymentItem = [];
    for (var i in bagContainer) {
      paymentItem.add(
        PaymentItem(
          amount: '${i.quantity! * i.price}',
          label: '${i.name} X ${i.quantity}',
          type: PaymentItemType.total,
        ),
      );
    }
  }

  Future<void> getAllShopItems() async {
    if (shopContainer.isEmpty) {
      shopContainer = await ShopRepository.getShopItems();
      sortShopItems(x: shopContainer);
    }
  }

  // here we got all the shop items
  List<ItemDetails> shopContainer = [];
  void sortShopItems({required List<ItemDetails> x}) {
    foodContainer = [];
    clothesContainer = [];
    toysContainer = [];
    othersContainer = [];
    // by checking each item  category parameter (String value)
    if (callOnce == 0) {
      for (var item in x) {
        // we gonna sort each and every category to his own container (List)
        switch (item.category) {
          case 'food':
            foodContainer.add(item);
            break;
          case 'clothes':
            clothesContainer.add(item);
            break;
          case 'toy':
            toysContainer.add(item);
            break;
          default:
            othersContainer.add(item);
        }
      }

      // emit the state at the end of the cycle
      emit(ShopSortEachCategoryToHisContainerState());
    }
    callOnce = callOnce + 1;
  }

  // add items to user own bag
  addItemToBag({required ItemDetails itemDetails}) {
    // first check if the item in the bag
    bool foundItem = false;
    for (ItemDetails item in bagContainer) {
      // if item in the bag
      if (item.id == itemDetails.id) {
        // increase its quantity by 1
        bagContainer[bagContainer.indexOf(item)].quantity = bagContainer[bagContainer.indexOf(item)].quantity! + 1;
        // add item price to total price variable
        totalItemsPrice = totalItemsPrice + itemDetails.price;
        howManyItemInBag = howManyItemInBag + 1;
        foundItem = true;
      }
    }
    // if item not in bag then set quantity of it to 1
    if (foundItem == false) {
      itemDetails.quantity = 1;
      // then add item price to total price variable
      totalItemsPrice = totalItemsPrice + itemDetails.price;
      howManyItemInBag = howManyItemInBag + 1;
      // then add it to the bag Container (List)
      bagContainer.add(itemDetails);
    }
    emit(AddItemToBagState());
  }

  // remove items from user own bag
  removeItemFromBag({required ItemDetails itemDetails}) {
    // first find the item
    for (ItemDetails item in bagContainer) {
      // then decrease its quantity by 1
      if (item.id == itemDetails.id) {
        if (item.quantity! > 1) {
          totalItemsPrice = totalItemsPrice - item.price;
          howManyItemInBag = howManyItemInBag - 1;
          bagContainer[bagContainer.indexOf(item)].quantity = bagContainer[bagContainer.indexOf(item)].quantity! - 1;
          break;
        }
        // if the quantity = 1 then remove it
        else if (item.quantity! <= 1) {
          totalItemsPrice = totalItemsPrice - itemDetails.price;
          howManyItemInBag = howManyItemInBag - 1;
          bagContainer.remove(bagContainer[bagContainer.indexOf(item)]);
          break;
        }
      }
    }
    emit(RemoveItemFromBagState());
  }

  removeAllOfThisItem({required ItemDetails itemDetails}) {
    totalItemsPrice = totalItemsPrice - (itemDetails.price * itemDetails.quantity!.toDouble());
    howManyItemInBag = howManyItemInBag - itemDetails.quantity!;
    bagContainer.remove(itemDetails);
    emit(RemoveItemFromBagState());
  }

  searchBarMethod() {
    searchContainer = [];
    for (var item in shopContainer) {
      if (item.name.contains(searchController.text) && searchController.text != '') {
        searchContainer.add(item);
      }
    }
    emit(SearchShopState());
  }

  recommendedSearch({required String search}) {
    searchContainer = [];
    searchController.text = search;
    for (var item in shopContainer) {
      if (item.category!.contains(searchController.text) && searchController.text != '') {
        searchContainer.add(item);
      }
    }
    emit(SearchShopState());
  }

  clearSearch() {
    searchContainer = [];
    searchController.text = '';
    emit(SearchShopState());
  }
}
