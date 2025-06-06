import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/features/home/data/google_ads_repository.dart';

class GoogleAdBanners extends StatefulWidget {
  const GoogleAdBanners({Key? key, this.largeBanner}) : super(key: key);
  final bool? largeBanner;
  @override
  State<GoogleAdBanners> createState() => _GoogleAdBannersState();
}

class _GoogleAdBannersState extends State<GoogleAdBanners> {
  late List<BannerAd> ads = [];

  @override
  void initState() {
    BannerAd banner1 = BannerAd(
      size: widget.largeBanner ?? false ? AdSize.largeBanner : AdSize.banner,
      adUnitId: AdState.bannerAdUnitIdList[0],
      listener: AdState.adListener,
      request: const AdRequest(),
    )..load();
    BannerAd banner2 = BannerAd(
      size: widget.largeBanner ?? false ? AdSize.largeBanner : AdSize.banner,
      adUnitId: AdState.bannerAdUnitIdList[1],
      listener: AdState.adListener,
      request: const AdRequest(),
    )..load();
    BannerAd banner3 = BannerAd(
      size: widget.largeBanner ?? false ? AdSize.largeBanner : AdSize.banner,
      adUnitId: AdState.bannerAdUnitIdList[2],
      listener: AdState.adListener,
      request: const AdRequest(),
    )..load();

    ads = [banner1, banner2, banner3];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: List.generate(
        3,
        (index) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              color: AppColors.primary, // Set the color of the frame border
              width: 2.0, // Set the width of the frame border
            ),
          ),
          child: AdWidget(
            ad: ads[index],
          ),
        ),
      ),
      options: CarouselOptions(
        initialPage: 0,
        enlargeCenterPage: true,
        autoPlay: true,
        height: 60,
        aspectRatio: 1 / 1,
        autoPlayCurve: Curves.fastOutSlowIn,
        autoPlayInterval: const Duration(seconds: 10),
        autoPlayAnimationDuration: const Duration(seconds: 3),
        enableInfiniteScroll: true,
        viewportFraction: 1.0,
      ),
    );
  }
}

// Row(
// children: [
// SizedBox(
// width: 200,
// child: AdWidget(
// ad: banner1,
// ),
// ),
// SizedBox(
// width: 200,
// child: AdWidget(
// ad: banner2,
// ),
// ),
// SizedBox(
// width: 200,
// child: AdWidget(
// ad: banner3,
// ),
// )
// ],
// ),
