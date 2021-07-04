import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobService {
  //todo change values
  static String get bannerUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : "ca-app-pub-3940256099942544/2934735716";

  static initialMobileAds() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }

  static BannerAd createBanner() {
    BannerAd bannerAd = BannerAd(
        size: AdSize.largeBanner,
        adUnitId: bannerUnitId,
        listener: BannerAdListener(
            onAdLoaded: (Ad ad) => print('Ad loaded'),
            onAdOpened: (Ad ad) => print('Ad opened'),
            onAdClosed: (Ad ad) => print('Ad closed'),
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
            }),
        request: AdRequest());

    return bannerAd;
  }
}
