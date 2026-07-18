import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/themes/app_colors.dart';

class MosqueMapPage extends StatefulWidget {
  final double userLat;
  final double userLng;
  final double mosqueLat;
  final double mosqueLng;
  final String mosqueName;
  final AppColors appColors;

  const MosqueMapPage({
    Key? key,
    required this.userLat,
    required this.userLng,
    required this.mosqueLat,
    required this.mosqueLng,
    required this.mosqueName,
    required this.appColors,
  }) : super(key: key);

  @override
  State<MosqueMapPage> createState() => _MosqueMapPageState();
}

class _MosqueMapPageState extends State<MosqueMapPage> {
  // Varsayılan ikon
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueGreen,
  );

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  // YENİ EKLENEN FONKSİYON: Resmi istediğimiz genişliğe göre yeniden boyutlandırır
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width, // İkonun genişliğini burası belirliyor
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();
  }

  // İkonu yükleyen güncel fonksiyon
  Future<void> _loadCustomMarker() async {
    try {
      // 100 değerini büyüterek (örn: 150) veya küçülterek (örn: 80) ikon boyutunu ayarlayabilirsin
      final Uint8List markerIcon = await getBytesFromAsset(
        'assets/mosque/mosque_icon.png',
        100,
      );

      final icon = BitmapDescriptor.fromBytes(markerIcon);

      setState(() {
        customIcon = icon;
      });
    } catch (e) {
      debugPrint("Özel ikon yüklenemedi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mosqueName,
          style: TextStyle(color: widget.appColors.prayerPage.titleTextColor),
        ),
        backgroundColor: widget.appColors.prayerPage.pageBgColor,
        iconTheme: IconThemeData(
          color: widget.appColors.prayerPage.titleTextColor,
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.mosqueLat, widget.mosqueLng),
          zoom: 16,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        markers: {
          Marker(
            markerId: const MarkerId('mosque_marker'),
            position: LatLng(widget.mosqueLat, widget.mosqueLng),
            infoWindow: InfoWindow(title: widget.mosqueName),
            icon: customIcon, // Boyutlandırılmış ikonumuz
          ),
        },
      ),
    );
  }
}
