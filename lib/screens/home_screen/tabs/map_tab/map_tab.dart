import 'package:evently_app/screens/home_screen/tabs/map_tab/location_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/base_theme.dart' show BaseTheme;
import '../../../../providers/my_provider.dart';

class MapTab extends StatefulWidget {
  final bool fromCreatePage; // لو جاي من الكيريت

  MapTab({super.key, required this.fromCreatePage});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  CameraPosition initCamera = CameraPosition(
    target: LatLng(37.43296265331129, -122.08832357078792),
  );

  late Set<Marker> markers = {
    Marker(
      markerId: MarkerId("1"),
      position: initCamera.target,
      icon: BitmapDescriptor.defaultMarker,
    ),
  };

  late GoogleMapController controller;
  bool mapReady = false; // لتحديد جاهزية الخريطة

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    final bool isDark = provider.themeMode == ThemeMode.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: isDark
            ? BaseTheme.dark.scaffoldBackgroundColor
            : AppColors.primary,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        // FAB في الزاوية العليا
        floatingActionButton: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: mapReady
                ? FloatingActionButton(
              heroTag: 'map_fab', // tag مميز
              backgroundColor: isDark
                  ? BaseTheme.dark.scaffoldBackgroundColor
                  : AppColors.primary,
              shape: CircleBorder(),
              onPressed: updateLocation,
              child: Icon(
                Icons.location_searching_sharp,
                color: Colors.white,
              ),
            )
                : null,
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              onTap: (LatLng position) async {
                List<Placemark> places = await placemarkFromCoordinates(
                  position.latitude,
                  position.longitude,
                );
                if (places.isNotEmpty) {
                  markers.add(
                    Marker(
                      markerId: MarkerId(position.toString()),
                      position: position,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueAzure,
                      ),
                    ),
                  );
                  print(places[0].country);
                }
                setState(() {});
                if (widget.fromCreatePage) {
                  Navigator.pop(context, position);
                }
              },
              markers: markers,
              onMapCreated: (GoogleMapController googleController) {
                controller = googleController;
                setState(() {
                  mapReady = true; // الخريطة جاهزة
                });
              },
              initialCameraPosition: initCamera,
            ),

            if (widget.fromCreatePage)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  width: double.infinity,
                  color: isDark? BaseTheme.dark.scaffoldBackgroundColor:AppColors.primary,
                  child: Center(
                    child: Text(
                      'Tap on Location To Select',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void updateLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    Position current = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    LatLng place = LatLng(current.latitude, current.longitude);

    controller.animateCamera(CameraUpdate.newLatLngZoom(place, 15));

    markers = {
      Marker(
        markerId: MarkerId("current_location"),
        position: place,
      )
    };

    setState(() {});
  }
}
