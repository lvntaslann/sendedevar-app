import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../widgets/qibla_compass_view.dart';
import '../widgets/qibla_loading_compass.dart';
import '../widgets/qibla_status_view.dart';

enum _QiblaViewState { loading, serviceDisabled, permissionDenied, permissionDeniedForever, unsupported, ready }

class QiblaPage extends StatefulWidget {
  const QiblaPage({Key? key}) : super(key: key);

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  _QiblaViewState _state = _QiblaViewState.loading;
  bool _minLoadingElapsed = false;
  QiblahDirection? _direction;
  StreamSubscription<QiblahDirection>? _qiblahSubscription;

  @override
  void initState() {
    super.initState();
    _checkStatus();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _minLoadingElapsed = true);
    });
  }

  @override
  void dispose() {
    _qiblahSubscription?.cancel();
    FlutterQiblah().dispose();
    super.dispose();
  }

  Future<void> _checkStatus() async {
    setState(() => _state = _QiblaViewState.loading);

    final locationStatus = await FlutterQiblah.checkLocationStatus();

    if (!locationStatus.enabled) {
      setState(() => _state = _QiblaViewState.serviceDisabled);
      return;
    }

    if (locationStatus.status == LocationPermission.denied) {
      final permission = await FlutterQiblah.requestPermissions();
      if (permission == LocationPermission.denied) {
        setState(() => _state = _QiblaViewState.permissionDenied);
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => _state = _QiblaViewState.permissionDeniedForever);
        return;
      }
    } else if (locationStatus.status == LocationPermission.deniedForever) {
      setState(() => _state = _QiblaViewState.permissionDeniedForever);
      return;
    }

    if (Platform.isAndroid) {
      final supported = await FlutterQiblah.androidDeviceSensorSupport();
      if (supported == false) {
        setState(() => _state = _QiblaViewState.unsupported);
        return;
      }
    }

    try {
      await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      ).timeout(const Duration(seconds: 6));
    } catch (_) {}

    if (!mounted) return;
    setState(() => _state = _QiblaViewState.ready);

    _qiblahSubscription?.cancel();
    _qiblahSubscription = FlutterQiblah.qiblahStream.listen((direction) {
      if (mounted) setState(() => _direction = direction);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(isDarkMode: false);

    return Scaffold(
      backgroundColor: appColors.qiblaPage.pageBgColor,
      appBar: const CustomAppBar(title: "Kıble Bulucu", showBackButton: true),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: _buildBody(appColors),
      ),
    );
  }

  Widget _buildBody(AppColors appColors) {
    switch (_state) {
      case _QiblaViewState.loading:
        return _loadingView(appColors);

      case _QiblaViewState.serviceDisabled:
        return QiblaStatusView(
          key: const ValueKey('serviceDisabled'),
          appColors: appColors,
          icon: Icons.location_off_outlined,
          title: "Konum Servisi Kapalı",
          message: "Kıble yönünü hesaplayabilmemiz için konum servisini açmalısın.",
          actionLabel: "Ayarları Aç",
          onAction: () async {
            await Geolocator.openLocationSettings();
            _checkStatus();
          },
        );

      case _QiblaViewState.permissionDenied:
        return QiblaStatusView(
          key: const ValueKey('permissionDenied'),
          appColors: appColors,
          icon: Icons.location_disabled_outlined,
          title: "Konum İzni Gerekli",
          message: "Kıble yönünü bulmak için konum iznine ihtiyacımız var.",
          actionLabel: "İzin Ver",
          onAction: _checkStatus,
        );

      case _QiblaViewState.permissionDeniedForever:
        return QiblaStatusView(
          key: const ValueKey('permissionDeniedForever'),
          appColors: appColors,
          icon: Icons.settings_outlined,
          title: "Konum İzni Reddedildi",
          message: "İzni uygulama ayarlarından manuel olarak açman gerekiyor.",
          actionLabel: "Ayarları Aç",
          onAction: () async {
            await Geolocator.openAppSettings();
            _checkStatus();
          },
        );

      case _QiblaViewState.unsupported:
        return QiblaStatusView(
          key: const ValueKey('unsupported'),
          appColors: appColors,
          icon: Icons.explore_off_outlined,
          title: "Pusula Desteklenmiyor",
          message: "Cihazının kıble yönü için gerekli pusula sensörü bulunmuyor.",
        );

      case _QiblaViewState.ready:
        final showResult = _direction != null && _minLoadingElapsed;
        if (!showResult) {
          return _loadingView(appColors);
        }
        return QiblaCompassView(
          key: const ValueKey('compass'),
          appColors: appColors,
          data: _direction!,
        );
    }
  }

  Widget _loadingView(AppColors appColors) {
    return QiblaLoadingCompass(
      key: const ValueKey('loading'),
      appColors: appColors,
      title: "Pusula Hazırlanıyor",
      message: "Kıble yönü hesaplanıyor,\nbu birkaç saniye sürebilir",
    );
  }
}
