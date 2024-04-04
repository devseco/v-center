import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? _currentPosition;
  LatLng _first = LatLng( 37.785687,-122.406396);
  LatLng _second = LatLng(37.786810, -122.405891);
  LatLng _third = LatLng(37.786111, -122.405997);
  String _closestPoint = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      _findClosestPoint();
    });
  }

  double _calculateDistance(LatLng point) {
    if (_currentPosition != null) {
      double distanceInMeters = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          point.latitude,
          point.longitude);
      print( _currentPosition!.latitude.toString() + " " + _currentPosition!.longitude.toString());
      return distanceInMeters;
    }
    return double.infinity; // Return infinity if position is null
  }

  void _findClosestPoint() {
    double minDistance = double.infinity;
    String closest = '';
    final Map<String, LatLng> points = {
      'First Point': _first,
      'Second Point': _second,
      'Third Point': _third,
    };

    points.forEach((key, value) {
      double distance = _calculateDistance(value);
      if (distance < minDistance) {
        minDistance = distance;
        closest = key;
      }
    });

    setState(() {
      _closestPoint = closest;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Closest Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Location: (${_currentPosition?.latitude ?? '-'}, ${_currentPosition?.longitude ?? '-'})',
            ),
            SizedBox(height: 20),
            Text(
              'Closest Point: $_closestPoint',
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                _launchMapsUrl(_currentPosition!.latitude,_currentPosition!.longitude);
              },
              child: Text('My Location'),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                _launchMapsUrl(_first.latitude,_first.longitude);
              },
              child: Text('first'),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                _launchMapsUrl(_second.latitude,_second.longitude);
              },
              child: Text('second'),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                _launchMapsUrl(_third.latitude,_third.longitude);
              },
              child: Text('Third'),
            ),
          ],
        ),
      ),
    );
  }
  void _launchMapsUrl(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

