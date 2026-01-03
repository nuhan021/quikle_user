import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:quikle_user/features/profile/controllers/add_address_controller.dart';
import 'package:quikle_user/features/profile/presentation/screens/add_address_screen.dart';

class MapAddressPickerController extends GetxController {
  // Google Maps API Key
  static const String googleApiKey = 'AIzaSyD65cza7lynnmbhCN44gs7HupKMnuoU-bo';

  // Map Controller
  GoogleMapController? mapController;

  // Observables
  final Rxn<LatLng> initialPosition = Rxn<LatLng>();
  final Rxn<LatLng> currentPosition = Rxn<LatLng>();
  final selectedAddress = 'Loading...'.obs;
  final fullAddress = ''.obs;
  final isLoadingAddress = false.obs;
  final isSearching = false.obs;
  final searchText = ''.obs;

  // Search
  final searchController = TextEditingController();
  final searchResults = <Map<String, dynamic>>[].obs;
  Timer? _debounce;

  // Address Components
  final addressComponents = <String, String>{}.obs;
  String city = '';
  String state = '';
  String country = 'India';
  String zipCode = '';
  String streetAddress = '';

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

  @override
  void onClose() {
    mapController?.dispose();
    searchController.dispose();
    _debounce?.cancel();
    // If the user closed the map without confirming, ensure the AddAddressController
    // does not keep the "willOpenMap" flag set.
    try {
      final addController = Get.find<AddAddressController>();
      addController.willOpenMap.value = false;
    } catch (_) {}
    super.onClose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Error', 'Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Error', 'Location permission permanently denied');
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final latLng = LatLng(position.latitude, position.longitude);
      initialPosition.value = latLng;
      currentPosition.value = latLng;

      // Get address for current location
      await _getAddressFromLatLng(latLng);
    } catch (e) {
      print('Error getting location: $e');
      // Default to India coordinates if location fails
      final defaultLatLng = LatLng(28.6139, 77.2090); // New Delhi
      initialPosition.value = defaultLatLng;
      currentPosition.value = defaultLatLng;
      await _getAddressFromLatLng(defaultLatLng);
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // Fetch address for initial position
    if (currentPosition.value != null) {
      _getAddressFromLatLng(currentPosition.value!);
    }
  }

  void onCameraMove(CameraPosition position) {
    currentPosition.value = position.target;
  }

  Future<void> onCameraIdle() async {
    if (currentPosition.value != null) {
      await _getAddressFromLatLng(currentPosition.value!);
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      isLoadingAddress.value = true;
      selectedAddress.value = 'Loading...';

      print(
        '🗺️ Fetching address for: ${position.latitude}, ${position.longitude}',
      );

      // Use Google Geocoding API for more detailed results
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleApiKey',
      );

      final response = await http.get(url);

      print('🗺️ Geocoding API status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print('🗺️ Geocoding API response: ${data['status']}');

        if (data['status'] == 'OK' &&
            data['results'] != null &&
            data['results'].isNotEmpty) {
          final result = data['results'][0];
          fullAddress.value = result['formatted_address'] ?? '';

          print('🗺️ Full address: ${fullAddress.value}');

          // Parse address components
          if (result['address_components'] != null) {
            _parseAddressComponents(result['address_components']);
          }

          // Set selected address to the street address or first line
          selectedAddress.value = streetAddress.isNotEmpty
              ? streetAddress
              : fullAddress.value.split(',').first;

          print('🗺️ Selected address: ${selectedAddress.value}');
          print('🗺️ City: $city, State: $state, Zip: $zipCode');
        } else {
          print('⚠️ Geocoding API returned status: ${data['status']}');
          await _fallbackToGeocodingPackage(position);
        }
      } else {
        print('⚠️ Geocoding API failed with status: ${response.statusCode}');
        await _fallbackToGeocodingPackage(position);
      }
    } catch (e) {
      print('❌ Error getting address: $e');
      await _fallbackToGeocodingPackage(position);
    } finally {
      isLoadingAddress.value = false;
    }
  }

  Future<void> _fallbackToGeocodingPackage(LatLng position) async {
    try {
      print('🔄 Using fallback geocoding package...');
      // Fallback to geocoding package
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        streetAddress = '${place.street ?? ''} ${place.subLocality ?? ''}'
            .trim();
        city = place.locality ?? '';
        state = place.administrativeArea ?? '';
        country = place.country ?? 'India';
        zipCode = place.postalCode ?? '';

        selectedAddress.value = streetAddress.isNotEmpty
            ? streetAddress
            : place.name ?? 'Unknown location';
        fullAddress.value =
            '${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''} ${place.postalCode ?? ''}'
                .trim();

        print('✅ Fallback address: ${selectedAddress.value}');
      } else {
        selectedAddress.value = 'Unable to get address';
        fullAddress.value =
            'Lat: ${position.latitude}, Lng: ${position.longitude}';
      }
    } catch (e) {
      print('❌ Fallback geocoding failed: $e');
      selectedAddress.value = 'Unable to get address';
      fullAddress.value =
          'Lat: ${position.latitude}, Lng: ${position.longitude}';
    }
  }

  void _parseAddressComponents(List<dynamic> components) {
    addressComponents.clear();
    streetAddress = '';
    city = '';
    state = '';
    country = 'India';
    zipCode = '';

    String streetNumber = '';
    String route = '';
    String sublocality = '';
    String locality = '';

    for (var component in components) {
      final types = component['types'] as List<dynamic>;
      final longName = component['long_name'] as String;

      if (types.contains('street_number')) {
        streetNumber = longName;
      } else if (types.contains('route')) {
        route = longName;
      } else if (types.contains('sublocality') ||
          types.contains('sublocality_level_1')) {
        sublocality = longName;
      } else if (types.contains('sublocality_level_2') && sublocality.isEmpty) {
        sublocality = longName;
      } else if (types.contains('locality')) {
        locality = longName;
        city = longName;
      } else if (types.contains('administrative_area_level_2') &&
          city.isEmpty) {
        // Sometimes city is in level 2
        city = longName;
      } else if (types.contains('administrative_area_level_1')) {
        state = longName;
      } else if (types.contains('country')) {
        country = longName;
      } else if (types.contains('postal_code')) {
        zipCode = longName;
      }
    }

    // Build street address from components
    List<String> addressParts = [];
    if (streetNumber.isNotEmpty) addressParts.add(streetNumber);
    if (route.isNotEmpty) addressParts.add(route);
    if (addressParts.isEmpty && sublocality.isNotEmpty) {
      addressParts.add(sublocality);
    }

    streetAddress = addressParts.join(' ');

    // If street address is still empty, use sublocality or first component
    if (streetAddress.isEmpty) {
      if (sublocality.isNotEmpty) {
        streetAddress = sublocality;
      } else if (components.isNotEmpty) {
        streetAddress = components[0]['long_name'] ?? '';
      }
    }

    // Ensure we have a city
    if (city.isEmpty && locality.isNotEmpty) {
      city = locality;
    }

    print('📍 Parsed address components:');
    print('   Street: $streetAddress');
    print('   City: $city');
    print('   State: $state');
    print('   Country: $country');
    print('   Zip: $zipCode');
  }

  Future<void> goToCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final latLng = LatLng(position.latitude, position.longitude);
      currentPosition.value = latLng;

      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 15),
        ),
      );

      await _getAddressFromLatLng(latLng);
    } catch (e) {
      print('Error going to current location: $e');
      Get.snackbar('Error', 'Could not get current location');
    }
  }

  void onSearchChanged(String query) {
    searchText.value = query;

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchPlaces(query);
    });
  }

  Future<void> _searchPlaces(String query) async {
    try {
      isSearching.value = true;
      searchResults.clear();

      print('🔍 Searching for: $query');

      // Use Google Places Autocomplete API
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(query)}&key=$googleApiKey&components=country:in',
      );

      print('🔍 Request URL: $url');

      final response = await http.get(url);

      print('🔍 Search API status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print('🔍 Search API response status: ${data['status']}');

        if (data['status'] == 'OK' && data['predictions'] != null) {
          searchResults.value = (data['predictions'] as List).map((prediction) {
            return {
              'place_id': prediction['place_id'],
              'main_text': prediction['structured_formatting']['main_text'],
              'secondary_text':
                  prediction['structured_formatting']['secondary_text'] ?? '',
              'description': prediction['description'],
            };
          }).toList();

          print('🔍 Found ${searchResults.length} results');
        } else {
          print('⚠️ Search returned status: ${data['status']}');
          if (data['error_message'] != null) {
            print('⚠️ Error message: ${data['error_message']}');
          }
        }
      } else {
        print('⚠️ Search API failed with status: ${response.statusCode}');
        print('⚠️ Response: ${response.body}');
      }
    } catch (e) {
      print('❌ Error searching places: $e');
      Get.snackbar(
        'Search Error',
        'Unable to search locations. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> selectSearchResult(Map<String, dynamic> result) async {
    try {
      isLoadingAddress.value = true;
      searchText.value = result['description'] ?? '';

      print('🔍 Selected: ${result['description']}');
      print('🔍 Place ID: ${result['place_id']}');

      // Get place details using Place ID
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=${result['place_id']}&key=$googleApiKey&fields=geometry,formatted_address,address_components',
      );

      print('🔍 Details URL: $url');

      final response = await http.get(url);

      print('🔍 Details API status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print('🔍 Details API response status: ${data['status']}');

        if (data['status'] == 'OK' && data['result'] != null) {
          final resultData = data['result'];
          final location = resultData['geometry']['location'];
          final latLng = LatLng(location['lat'], location['lng']);

          currentPosition.value = latLng;

          print('🔍 Moving to: ${location['lat']}, ${location['lng']}');

          // Animate camera to selected location
          mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: latLng, zoom: 15),
            ),
          );

          // Parse address components
          if (resultData['address_components'] != null) {
            _parseAddressComponents(resultData['address_components']);
          }

          fullAddress.value = resultData['formatted_address'] ?? '';
          selectedAddress.value = streetAddress.isNotEmpty
              ? streetAddress
              : result['main_text'] ?? '';

          print('🔍 Full address set: ${fullAddress.value}');
        } else {
          print('⚠️ Details API returned status: ${data['status']}');
          if (data['error_message'] != null) {
            print('⚠️ Error message: ${data['error_message']}');
          }
        }
      } else {
        print('⚠️ Details API failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error selecting place: $e');
      Get.snackbar(
        'Error',
        'Unable to get location details. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingAddress.value = false;
    }
  }

  void confirmAddress() {
    if (selectedAddress.value.isEmpty ||
        selectedAddress.value == 'Loading...') {
      Get.snackbar('Error', 'Please wait while we load the address');
      return;
    }

    // Get the AddAddressController and populate it
    final addAddressController = Get.find<AddAddressController>();

    print('📍 Confirming address:');
    print('   Street: $streetAddress');
    print('   City: $city');
    print('   State: $state');
    print('   Country: $country');
    print('   Zip: $zipCode');
    print('   Full: ${fullAddress.value}');

    // Set the full address field - use the complete formatted address
    addAddressController.addressController.text = fullAddress.value.isNotEmpty
        ? fullAddress.value
        : streetAddress;
    addAddressController.isAddressFromMap.value = true; // Mark as from map

    // Set country first
    if (country.isNotEmpty) {
      addAddressController.setCountry(country);
      print('✅ Set country: $country');
    }

    // Set state and city with proper delays for dropdown loading
    if (state.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 200), () {
        // Check if state exists in the list
        if (addAddressController.states.contains(state)) {
          addAddressController.setState(state);
          print('✅ Set state: $state');

          // Set city after state is set
          if (city.isNotEmpty) {
            Future.delayed(const Duration(milliseconds: 200), () {
              // Check if city exists in the list
              if (addAddressController.cities.contains(city)) {
                addAddressController.setCity(city);
                print('✅ Set city: $city');
              } else {
                print('⚠️ City "$city" not found in list');
                print(
                  '   Available cities: ${addAddressController.cities.take(5)}...',
                );

                // Try to find a similar city name
                final similarCity = addAddressController.cities.firstWhere(
                  (c) =>
                      c.toLowerCase().contains(city.toLowerCase()) ||
                      city.toLowerCase().contains(c.toLowerCase()),
                  orElse: () => '',
                );

                if (similarCity.isNotEmpty) {
                  addAddressController.setCity(similarCity);
                  print('✅ Set similar city: $similarCity');
                } else {
                  // City not found and no similar match - set it manually (user can type any city)
                  print('➕ Setting city manually: $city');
                  addAddressController.setCityManually(city);
                  addAddressController.cityTextController.text = city;
                  print('✅ Set custom city: $city');
                }
              }
            });
          }
        } else {
          print('⚠️ State "$state" not found in list');
          print(
            '   Available states: ${addAddressController.states.take(5)}...',
          );
          // Try to find a similar state name
          final similarState = addAddressController.states.firstWhere(
            (s) =>
                s.toLowerCase().contains(state.toLowerCase()) ||
                state.toLowerCase().contains(s.toLowerCase()),
            orElse: () => '',
          );

          if (similarState.isNotEmpty) {
            addAddressController.setState(similarState);
            print('✅ Set similar state: $similarState');

            // Set city after state is set
            if (city.isNotEmpty) {
              Future.delayed(const Duration(milliseconds: 200), () {
                // Check if city exists in the list
                if (addAddressController.cities.contains(city)) {
                  addAddressController.setCity(city);
                  print('✅ Set city: $city');
                } else {
                  print('⚠️ City "$city" not found in list');
                  print(
                    '   Available cities: ${addAddressController.cities.take(5)}...',
                  );

                  // Try to find a similar city name
                  final similarCity = addAddressController.cities.firstWhere(
                    (c) =>
                        c.toLowerCase().contains(city.toLowerCase()) ||
                        city.toLowerCase().contains(c.toLowerCase()),
                    orElse: () => '',
                  );

                  if (similarCity.isNotEmpty) {
                    addAddressController.setCity(similarCity);
                    print('✅ Set similar city: $similarCity');
                  } else {
                    // City not found and no similar match - set it manually (user can type any city)
                    print('➕ Setting city manually: $city');
                    addAddressController.setCityManually(city);
                    addAddressController.cityTextController.text = city;
                    print('✅ Set custom city: $city');
                  }
                }
              });
            }
          } else {
            // State not found and no similar match - set it manually (user can type any state)
            print('➕ Setting state manually: $state');
            addAddressController.setStateManually(state);
            addAddressController.stateTextController.text = state;
            print('✅ Set custom state: $state');

            // Also set the city manually since we can't load cities for a custom state
            if (city.isNotEmpty) {
              print('➕ Setting city manually: $city');
              addAddressController.setCityManually(city);
              addAddressController.cityTextController.text = city;
              print('✅ Set custom city: $city');
            }
          }
        }
      });
    }

    // Set zip code
    if (zipCode.isNotEmpty) {
      addAddressController.zipCodeController.text = zipCode;
      print('✅ Set zip code: $zipCode');
    }

    // Go back to close the map screen
    // We are confirming selection — clear the navigation flag and mark as from map
    addAddressController.willOpenMap.value = false;
    Get.back();

    // Show the address details sheet after a small delay (after navigation completes)
    Future.delayed(const Duration(milliseconds: 10), () {
      // Import is needed at top: import 'package:quikle_user/features/profile/presentation/screens/add_address_screen.dart';
      // Show the address details bottom sheet
      if (Get.context != null) {
        showModalBottomSheet(
          context: Get.context!,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const AddressDetailsScreen(addressToEdit: null),
        );
      }

      // // Show success message
      // Get.snackbar(
      //   'Success',
      //   'Address selected from map',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.green[600],
      //   colorText: Colors.white,
      //   duration: const Duration(seconds: 2),
      //   margin: const EdgeInsets.all(12),
      //   borderRadius: 8,
      //   icon: const Icon(Icons.check_circle, color: Colors.white),
      // );
    });
  }
}
