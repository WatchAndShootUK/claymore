import 'package:latlong2/latlong.dart';

class CountryLocation {
  final String name;
  final LatLng latLng;

  const CountryLocation({
    required this.name,
    required this.latLng,
  });
}

const countryLocations = [
  CountryLocation(
    name: 'United Kingdom',
    latLng: LatLng(54.7024, -3.2766),
  ),
  CountryLocation(
    name: 'France',
    latLng: LatLng(46.2276, 2.2137),
  ),
  CountryLocation(
    name: 'Germany',
    latLng: LatLng(51.1657, 10.4515),
  ),
  CountryLocation(
    name: 'Poland',
    latLng: LatLng(51.9194, 19.1451),
  ),
  CountryLocation(
    name: 'United States',
    latLng: LatLng(37.0902, -95.7129),
  ),
];