import 'package:flutter/material.dart';
import 'package:home_service/ui/models/userdata.dart';
import 'package:home_service/ui/views/artisan/view_artisan_by_category.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/auth/register.dart';
import 'package:home_service/ui/views/auth/verify.dart';
import 'package:home_service/ui/views/help/help_page.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:home_service/ui/views/onboarding/onboarding_screen.dart';
import 'package:home_service/ui/views/profile/artisan_profile/complete_artisan_profile.dart';
import 'package:home_service/ui/views/profile/edit_profile.dart';
import 'package:home_service/ui/views/profile/user_profile/complete_user_profile.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppState.routeName:
        return MaterialPageRoute(builder: (_) => AppState());
      case OnboardingScreen.routeName:
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

      case RegistrationPage.routeName:
        return MaterialPageRoute(builder: (_) => RegistrationPage());

      case VerificationPage.routeName:
        final data = settings.arguments as UserData;

        return MaterialPageRoute(
            builder: (_) => VerificationPage(
                  phoneNumber: data.phoneNumber,
                  userType: data.userType,
                ));

      case CompleteArtisanProfile.routeName:
        return MaterialPageRoute(builder: (_) => CompleteArtisanProfile());

      case CompleteUserProfile.routeName:
        return MaterialPageRoute(builder: (_) => CompleteUserProfile());

      case EditProfile.routeName:
        return MaterialPageRoute(builder: (_) => EditProfile());

      case Home.routeName:
        return MaterialPageRoute(
            builder: (_) => Home(
                  userType: args as String,
                ));

      case HelpPage.routeName:
        return MaterialPageRoute(builder: (_) => HelpPage());

      case ViewArtisanByCategoryPage.routeName:
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
