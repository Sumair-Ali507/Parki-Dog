import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/features/home/view/widgets/park_rating.dart';
import 'package:parki_dog/features/map/cubit/map_cubit.dart';
import 'package:parki_dog/features/park/view/widgets/carousel.dart';

import '../../../park/data/single_park_model.dart';
import '../../../shop/view/pages/web_view.dart';

class SingleCityPark extends StatelessWidget {
  const SingleCityPark({super.key, required this.result, required this.parkImageList});
  final Result result;
  final List<String> parkImageList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Carousel(photoUrls: parkImageList.isEmpty ? [''] : parkImageList),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  result.name ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              ParkRating(rating: result.rating?.toDouble() ?? 0, totalRatings: result.userRatingsTotal ?? 0),
            ],
          ),
        ),
        Expanded(
            child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 16),
            result.reviews?.isEmpty ?? true
                ? Center(child: Text('No Reviews'.tr()))
                : Column(
                    children: List.generate(
                      result.reviews?.length ?? 0,
                      (index) => Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage: NetworkImage(result.reviews?[index].profilePhotoUrl ?? ''),
                                ),
                                const SizedBox(width: 8.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      result.reviews?[index].authorName ?? '',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      result.reviews?[index].relativeTimeDescription ?? '',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                Text('${result.reviews?[index].rating ?? 0}/5'),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Text(result.reviews?[index].text ?? ''),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        )),
        buttonReview(() {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => WebView(
              url: result.url!,
              itemName: result.name!,
            ),
          ));
        }, 'Review us'.tr()),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

Widget buttonReview(final VoidCallback onPressed, final String text) => ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        backgroundColor: AppColors.primary, // Button color
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Text color
        ),
      ),
    );
