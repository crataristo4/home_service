import 'package:flutter/material.dart';
import 'package:home_service/ui/views/artisan/view_artisan_by_category.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/auth/register.dart';
import 'package:home_service/ui/views/auth/verify.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:home_service/ui/views/onboarding/onboarding_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => AppState());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      /*    case '/editProfile':
        return MaterialPageRoute(
            builder: (_) => EditProfile(
                  userName: args,
                  photoUrl: args,
                  phoneNumber: args,
                  email: args,
                  id: args,
                ));

      case '/feedBack':
        return MaterialPageRoute(builder: (_) => FeedbackScreen());
      case '/inviteFriend':
        return MaterialPageRoute(builder: (_) => InviteFriend());*/

      case '/registerPage':
        return MaterialPageRoute(builder: (_) => RegistrationPage());

      case '/verifyPage':
        return MaterialPageRoute(
            builder: (_) => VerificationPage(phoneNumber: args));

      case '/homePage':
        return MaterialPageRoute(
            builder: (_) => Home(
                  initialIndex: 1,
                ));

      case '/viewArtisanByCategoryPage':
        return MaterialPageRoute(
            builder: (_) => ViewArtisanByCategoryPage(
                  categoryName: args,
                ));

      default:
        return _errorRoute();
    }
  }

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
