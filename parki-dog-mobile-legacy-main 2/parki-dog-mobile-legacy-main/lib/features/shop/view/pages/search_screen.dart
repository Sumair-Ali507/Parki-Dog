import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';
import '../../cubit/shop_cubit.dart';
import '../../cubit/shop_state.dart';
import '../widget/recommended_widget.dart';
import 'on_search_body.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopCubit, ShopState>(
      builder: (BuildContext context, ShopState state) {
        var cubit = ShopCubit.get(context);
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: BlocBuilder<LangCubit, LangState>(builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                forceMaterialTransparency: true,
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: cubit.searchController,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      suffixIconColor: Colors.black,
                      prefixIconColor: Colors.grey,
                      prefixIcon: const Icon(
                        Icons.search,
                      ),
                      suffixIcon: InkWell(
                        onTap: () => cubit.clearSearch(),
                        child: const Icon(
                          Icons.close,
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                    onChanged: (v) => cubit.searchBarMethod(),
                  ),
                ),
              ),
              body: cubit.searchController.text == ''
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Recommended search'.tr()),
                          const SizedBox(
                            height: 10,
                          ),
                          RecommendedSearchWidget(
                            searchText: 'Food'.tr(),
                            onTap: () {
                              cubit.recommendedSearch(search: 'food');
                            },
                          ),
                          RecommendedSearchWidget(
                            searchText: 'Toys'.tr(),
                            onTap: () {
                              cubit.recommendedSearch(search: 'toy');
                            },
                          ),
                          RecommendedSearchWidget(
                            searchText: 'Clothes'.tr(),
                            onTap: () {
                              cubit.recommendedSearch(search: 'clothes');
                            },
                          ),
                        ],
                      ),
                    )
                  : OnSearchBody(cubit: cubit),
            );
          }),
        );
      },
    );
  }
}
