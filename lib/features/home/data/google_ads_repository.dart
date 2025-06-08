import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  static late Future<InitializationStatus> initialization;

  static initAdState({required Future<InitializationStatus> init}) {
    initialization = init;
  }

  static String get singleBannerAdUnitIdList =>
      Platform.isAndroid ? 'ca-app-pub-7821159916623436/4568572411' : 'ca-app-pub-7821159916623436/3317718858';
  static List<String> get bannerAdUnitIdList => Platform.isAndroid
      ? [
          'ca-app-pub-7821159916623436/4568572411',
          'ca-app-pub-7821159916623436/4979689854',
          'ca-app-pub-7821159916623436/8906492420',
        ]
      : [
          'ca-app-pub-7821159916623436/3317718858',
          'ca-app-pub-7821159916623436/7222709814',
          'ca-app-pub-7821159916623436/3091893113',
        ];

  static get adListener => BannerAdListener(
        onAdClicked: (v) {
          print(v.responseInfo);
          print(v.responseInfo?.adapterResponses?[0] ?? '');
          print(v.responseInfo?.loadedAdapterResponseInfo?.description);
          print(v.responseInfo?.responseExtras);
          print(v.responseInfo?.mediationAdapterClassName);
        },
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) => print('Ad loaded.'),
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {
          print(ad.responseInfo);
          print(ad.responseInfo?.adapterResponses?[0] ?? '');
          print(ad.responseInfo?.loadedAdapterResponseInfo?.description);
          print(ad.responseInfo?.responseExtras);
          print(ad.responseInfo?.mediationAdapterClassName);
        },
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.'),
        // Called when an ad is in the process of leaving the application.
      );
}
