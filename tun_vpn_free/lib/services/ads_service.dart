import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  static AdsService? _instance;
  static AdsService get instance => _instance ??= AdsService._();
  AdsService._();

  // Test ad unit IDs (replace with real ones from AdMob console)
  static const String _interstitialAdUnitIdAndroid =
      'ca-app-pub-3940256099942544/1033173712'; // Test ID
  static const String _bannerAdUnitIdAndroid =
      'ca-app-pub-3940256099942544/6300978111'; // Test ID

  // Production IDs (replace these with your real AdMob IDs)
  // static const String _interstitialAdUnitIdAndroid =
  //     'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  // static const String _bannerAdUnitIdAndroid =
  //     'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';

  InterstitialAd? _interstitialAd;
  BannerAd? _bannerAd;
  bool _isInterstitialReady = false;
  bool _isBannerReady = false;

  bool get isBannerReady => _isBannerReady;
  BannerAd? get bannerAd => _bannerAd;

  Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
      _loadInterstitialAd();
      _loadBannerAd();
    } catch (e) {
      debugPrint('Ads init error: $e');
    }
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitIdAndroid,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialReady = true;
          ad.setImmersiveMode(true);
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial failed to load: $error');
          _isInterstitialReady = false;
          // Retry after 30 seconds
          Future.delayed(const Duration(seconds: 30), _loadInterstitialAd);
        },
      ),
    );
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitIdAndroid,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _isBannerReady = true;
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner failed to load: $error');
          _isBannerReady = false;
          ad.dispose();
          _bannerAd = null;
        },
      ),
    )..load();
  }

  Future<void> showInterstitialAd() async {
    if (_isInterstitialReady && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialReady = false;
          _loadInterstitialAd(); // Preload next ad
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialReady = false;
          _loadInterstitialAd();
        },
      );
      await _interstitialAd!.show();
    } else {
      debugPrint('Interstitial ad not ready');
      _loadInterstitialAd();
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
    _bannerAd?.dispose();
  }
}
