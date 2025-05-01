import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

Location location = new Location();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MapboxOptions.setAccessToken(
    "pk.eyJ1Ijoia2FzZWhhdCIsImEiOiJja3l4MWhvMHcwZTR6MndwODQ3enJ1NjZnIn0.gNGR3e7IXAkbUAOG4bu44w",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Homepage());
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Location location = new Location();
  MapboxMap? mapboxMap;
  late LocationData _locationData = LocationData.fromMap({});

  loadLocation() async {
    bool _serviceEnabled;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _locationData = await location.getLocation();
    if (mapboxMap != null) {
      _moveToCurrentLocation();
    }
  }

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    if (_locationData != null) {
      _moveToCurrentLocation();
    }
  }

  void _moveToCurrentLocation() {
    mapboxMap?.flyTo(
      CameraOptions(
        center: Point(
          coordinates: Position(
            _locationData.latitude!,
            _locationData.longitude!,
          ),
        ),
      ),
      MapAnimationOptions(duration: 1500),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Location App')),
      body: MapWidget(
        onMapCreated: _onMapCreated,
        styleUri: MapboxStyles.MAPBOX_STREETS,
      ),
    );
  }
}
