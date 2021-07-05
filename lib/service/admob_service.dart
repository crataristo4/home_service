import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobService {
  //todo change values
  static String get bannerUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : "ca-app-pub-3940256099942544/2934735716";

  //TODO CHANGE ID'S
  static String get interstitialId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/1033173712 ';

  InterstitialAd? _interstitialAd;
  int numOfAttempts = 0;

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
            onAdClosed: (Ad ad) {
              print('Ad closed');
              ad.dispose();
            },
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
            }),
        request: AdRequest());

    return bannerAd;
  }

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: interstitialId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            this._interstitialAd = ad;
            numOfAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
            numOfAttempts++;
            _interstitialAd = null;

            if (numOfAttempts <= 2) createInterstitialAd();
          },
        ));
  }

  void showInterstitialAd() {
    if (interstitialId == null) return;

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdWillDismissFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        print('$ad onAdWillDismissFullScreenContent.');
      },
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        // createInterstitialAd();
      },
      onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),
    );

    _interstitialAd!.show();
  }
}
