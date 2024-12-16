/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsAudiosGen {
  const $AssetsAudiosGen();

  /// File path: assets/audios/alarm_source.mp3
  String get alarmSource => 'assets/audios/alarm_source.mp3';

  /// List of all assets
  List<String> get values => [alarmSource];
}

class $AssetsGifsGen {
  const $AssetsGifsGen();

  /// File path: assets/gifs/loading.gif
  AssetGenImage get loading => const AssetGenImage('assets/gifs/loading.gif');

  /// List of all assets
  List<AssetGenImage> get values => [loading];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/apple.png
  AssetGenImage get apple => const AssetGenImage('assets/icons/apple.png');

  /// File path: assets/icons/back.svg
  String get back => 'assets/icons/back.svg';

  /// File path: assets/icons/calendar.svg
  String get calendar => 'assets/icons/calendar.svg';

  /// File path: assets/icons/cele.svg
  String get cele => 'assets/icons/cele.svg';

  /// File path: assets/icons/coffeeCup.png
  AssetGenImage get coffeeCup =>
      const AssetGenImage('assets/icons/coffeeCup.png');

  /// File path: assets/icons/facebook.png
  AssetGenImage get facebook =>
      const AssetGenImage('assets/icons/facebook.png');

  /// File path: assets/icons/google.png
  AssetGenImage get google => const AssetGenImage('assets/icons/google.png');

  /// File path: assets/icons/heart.png
  AssetGenImage get heart => const AssetGenImage('assets/icons/heart.png');

  /// File path: assets/icons/hide.svg
  String get hide => 'assets/icons/hide.svg';

  /// File path: assets/icons/info.png
  AssetGenImage get info => const AssetGenImage('assets/icons/info.png');

  /// File path: assets/icons/lang.svg
  String get lang => 'assets/icons/lang.svg';

  /// File path: assets/icons/note.svg
  String get note => 'assets/icons/note.svg';

  /// File path: assets/icons/plus.png
  AssetGenImage get plus => const AssetGenImage('assets/icons/plus.png');

  /// File path: assets/icons/privacyPolicy.png
  AssetGenImage get privacyPolicy =>
      const AssetGenImage('assets/icons/privacyPolicy.png');

  /// File path: assets/icons/selectDate.svg
  String get selectDate => 'assets/icons/selectDate.svg';

  /// File path: assets/icons/selectTime.svg
  String get selectTime => 'assets/icons/selectTime.svg';

  /// File path: assets/icons/settings.png
  AssetGenImage get settings =>
      const AssetGenImage('assets/icons/settings.png');

  /// File path: assets/icons/signout.svg
  String get signout => 'assets/icons/signout.svg';

  /// File path: assets/icons/us.png
  AssetGenImage get us => const AssetGenImage('assets/icons/us.png');

  /// File path: assets/icons/view.svg
  String get view => 'assets/icons/view.svg';

  /// File path: assets/icons/vn.png
  AssetGenImage get vn => const AssetGenImage('assets/icons/vn.png');

  /// List of all assets
  List<dynamic> get values => [
        apple,
        back,
        calendar,
        cele,
        coffeeCup,
        facebook,
        google,
        heart,
        hide,
        info,
        lang,
        note,
        plus,
        privacyPolicy,
        selectDate,
        selectTime,
        settings,
        signout,
        us,
        view,
        vn
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/circle_shape_big.png
  AssetGenImage get circleShapeBig =>
      const AssetGenImage('assets/images/circle_shape_big.png');

  /// File path: assets/images/circle_shape_small.png
  AssetGenImage get circleShapeSmall =>
      const AssetGenImage('assets/images/circle_shape_small.png');

  /// File path: assets/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [circleShapeBig, circleShapeSmall, logo];
}

class Assets {
  Assets._();

  static const String aEnv = '.env';
  static const $AssetsAudiosGen audios = $AssetsAudiosGen();
  static const $AssetsGifsGen gifs = $AssetsGifsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();

  /// List of all assets
  static List<String> get values => [aEnv];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
