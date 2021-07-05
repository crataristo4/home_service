import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:home_service/models/artisan/bookings.dart';
import 'package:home_service/models/artwork.dart';
import 'package:home_service/models/booking.dart';
import 'package:home_service/models/users.dart';
import 'package:home_service/provider/artwork_provider.dart';
import 'package:home_service/provider/auth_provider.dart';
import 'package:home_service/provider/bookings_provider.dart';
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
  MobileAds.instance.initialize();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  runApp(EntryPoint());
}

class EntryPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //authentication
        ChangeNotifierProvider.value(value: AuthProvider()),
        //user creation
        ChangeNotifierProvider(create: (context) => UserProvider()),

        //get all users
        StreamProvider<List<Users>>.value(
          lazy: false,
          initialData: [],
          value: UserService().getAllUsers(),
        ),

        //get all artisan
        StreamProvider<List<Artisans>>.value(
          lazy: false,
          initialData: [],
          value: UserService().getAllArtisans(),
        ),

        ChangeNotifierProvider(
          create: (context) => BookingsProvider(),
        ),

        //all bookings - user
        StreamProvider<List<Bookings>>.value(
            lazy: false,
            value: BookingService().getUserBookings(),
            initialData: []),

        //get received bookings made to artisans (for Artisan page)
        StreamProvider<List<ReceivedBookings>>.value(
          lazy: false,
          initialData: [],
          value: BookingService().getReceivedBookings(),
        ),

        //get sent bookings made .Artisan to artisans (for Artisan page)
        StreamProvider<List<SentBookings>>.value(
            lazy: false,
            value: BookingService().getSentBookings(),
            initialData: []),

        ChangeNotifierProvider(create: (context) => ArtworkProvider()),

        StreamProvider<List<ArtworkModel>>.value(
          lazy: false,
          initialData: [],
          value: ArtworkService().fetchAllArtwork(),
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
