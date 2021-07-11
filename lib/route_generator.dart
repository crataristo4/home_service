import 'package:flutter/material.dart';
import 'package:home_service/ui/views/artisan/history.dart';
import 'package:home_service/ui/views/artisan/view_all_artisans.dart';
import 'package:home_service/ui/views/artisan/view_artisan_by_category.dart';
import 'package:home_service/ui/views/artisan/view_top_experts.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/auth/register.dart';
import 'package:home_service/ui/views/auth/verify.dart';
import 'package:home_service/ui/views/bottomsheet/show_user_profile.dart';
import 'package:home_service/ui/views/help/help_page.dart';
import 'package:home_service/ui/views/home/bookings.dart';
import 'package:home_service/ui/views/home/bookings/artisan_booking_page/received_bookings.dart';
import 'package:home_service/ui/views/home/bookings/artisan_booking_page/sent_bookings.dart';
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

      //edit user / artisan profile
      case EditProfile.routeName:
        return MaterialPageRoute(builder: (_) => EditProfile());

      // user profile
      case UserProfile.routeName:
        final data = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => UserProfile(
                  userId: data,
                ));

      // artisan profile
      case ArtisanProfile.routeName:
        final data = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => ArtisanProfile(
                  artisanId: data,
                ));

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

      //view all top expert artisans
      case ViewAllTopExperts.routeName:
        return MaterialPageRoute(builder: (_) => ViewAllTopExperts());

      // bookings PAGE
      case BookingPage.routeName:
        return MaterialPageRoute(builder: (_) => BookingPage());

      //sent bookings - artisan
      case SentBookingsPage.routeName:
        return MaterialPageRoute(builder: (_) => SentBookingsPage());
      //received bookings artisan
      case ReceivedBookingsPage.routeName:
        return MaterialPageRoute(builder: (_) => ReceivedBookingsPage());

      //received bookings artisan
      case HistoryPage.routeName:
        return MaterialPageRoute(builder: (_) => HistoryPage());

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
