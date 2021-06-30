import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_service/models/artwork.dart';
import 'package:home_service/models/booking.dart';
import 'package:home_service/models/users.dart';
import 'package:home_service/provider/artwork_provider.dart';
import 'package:home_service/provider/auth_provider.dart';
import 'package:home_service/provider/user_provider.dart';
import 'package:home_service/route_generator.dart';
import 'package:home_service/service/artwork_service.dart';
import 'package:home_service/service/booking_service.dart';
import 'package:home_service/service/firestore_services.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/onboarding/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? initScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  runApp(EntryPoint());
}

class EntryPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final getAllArtisan = UserService();
    final getPendingBookings = BookingService();
    final getConfirmedBookings = BookingService();
    final getArtworks = ArtworkService();

    return MultiProvider(
      providers: [
        //authentication
        ChangeNotifierProvider.value(value: AuthProvider()),
        //user creation
        ChangeNotifierProvider(create: (context) => UserProvider()),
        //get all artisan
        StreamProvider<List<Artisans>>.value(
          lazy: false,
          initialData: [],
          value: getAllArtisan.getAllArtisans(),
        ),

        //get list of pending bookings
        StreamProvider<List<Bookings>>.value(
          initialData: [],
          value: getPendingBookings.getPendingBookings(),
        ),

        //fetch list of confirmed bookings
        StreamProvider<List<Bookings>>.value(
            value: getConfirmedBookings.getConfirmedBookings(),
            initialData: []),

        ChangeNotifierProvider(create: (context) => ArtworkProvider()),

        StreamProvider<List<ArtworkModel>>.value(
          initialData: [],
          value: getArtworks.fetchAllArtwork(),
        ),

        StreamProvider<List<ArtworkModel>>.value(
          initialData: [],
          value: getArtworks.fetchArtworkById("Artis"),
        ),
      ],
      child: MaterialApp(
        //checks and switches page
        initialRoute: initScreen == 0 || initScreen == null
            ? OnboardingScreen
                .routeName //shows when app data is cleared or newly installed
            : AppState.routeName, //navigate to authentication state page
        onGenerateRoute: RouteGenerator.generateRoute,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          primaryColor: Colors.indigo,
        ),
      ),
    );
  }
}
