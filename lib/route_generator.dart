import 'package:flutter/material.dart';
import 'package:home_service/ui/views/artisan/view_all_artisans.dart';
import 'package:home_service/ui/views/artisan/view_artisan_by_category.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/auth/register.dart';
import 'package:home_service/ui/views/auth/verify.dart';
import 'package:home_service/ui/views/help/help_page.dart';
import 'package:home_service/ui/views/home/bookings.dart';
import 'package:home_service/ui/views/home/bookings/confirmed_bookings.dart';
import 'package:home_service/ui/views/home/bookings/pending_bookings.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:home_service/ui/views/onboarding/onboarding_screen.dart';
import 'package:home_service/ui/views/profile/artisan_profile.dart';
import 'package:home_service/ui/views/profile/complete_profile.dart';
import 'package:home_service/ui/views/profile/edit_profile.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      //user config state checker Screen
      case AppState.routeName:
        return MaterialPageRoute(builder: (_) => AppState());

      //shows when user newly installs the application
      case OnboardingScreen.routeName:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());

      //screen to register new users / login
      case RegistrationPage.routeName:
        return MaterialPageRoute(builder: (_) => RegistrationPage());

      //verify users phone number
      case VerificationPage.routeName:
        final data = settings.arguments as String;

        return MaterialPageRoute(
            builder: (_) => VerificationPage(
                  phoneNumber: data,
                ));

      //account completion
      case CompleteProfile.routeName:
        return MaterialPageRoute(builder: (_) => CompleteProfile());

      //edit user profile
      case EditProfile.routeName:
        return MaterialPageRoute(builder: (_) => EditProfile());

      //edit artisan profile
      case ArtisanProfile.routeName:
        // final data = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ArtisanProfile());

      //default home page for all users
      case Home.routeName:
        final tabIndex = settings.arguments as int;
        return MaterialPageRoute(
            builder: (_) => Home(
                  tabIndex: tabIndex,
                ));

      //help and support page where users can contact us
      case HelpPage.routeName:
        return MaterialPageRoute(builder: (_) => HelpPage());

      //view all available artisans
      case ViewAllArtisans.routeName:
        return MaterialPageRoute(builder: (_) => ViewAllArtisans());

      // bookings PAGE
      case BookingPage.routeName:
        return MaterialPageRoute(builder: (_) => BookingPage());

      //pending bookings
      case PendingBookings.routeName:
        return MaterialPageRoute(builder: (_) => PendingBookings());
      //confirmed bookings
      case ConfirmedBookings.routeName:
        return MaterialPageRoute(builder: (_) => ConfirmedBookings());

      //view artisans by category
      case ViewArtisanByCategoryPage.routeName:
        return MaterialPageRoute(
            builder: (_) => ViewArtisanByCategoryPage(
                  categoryName: args as String,
                ));

      default:
        return _errorRoute();
    }
  }

  //error page ..
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text("Page not Found"),
        ),
      );
    });
  }
}
