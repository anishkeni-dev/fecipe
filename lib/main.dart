import 'package:fecipe/meal_plan/bloc/meal_plan_bloc.dart';
import 'package:fecipe/recipedescription/bloc/recipe_description_bloc.dart';
import 'package:fecipe/repository/auth_repository.dart';
import 'package:fecipe/repository/user_repository.dart';
import 'package:fecipe/schedule_meal/bloc/schedule_meal_bloc.dart';
import 'package:fecipe/search/bloc/search_bloc.dart';
import 'package:fecipe/shopping_list/bloc/shoppinglist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

import '/userpreferences/user_preferences.dart';
import 'auth/bloc/auth_bloc.dart';
import 'auth/firebase_options.dart';
import 'commons/colors.dart';
import '/forgotpassword/bloc/forgotpassword_bloc.dart';
import 'dashboard/bloc/dashboard_bloc.dart';
import 'editprofile/bloc/editprofile_bloc.dart';
import 'splashscreen/splashscreen.dart';
import '/internet_connectivity/bloc/internet_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors();
    MaterialColor customTeal =
        MaterialColor(0xff81BAB4, customColors.tealColorCodes);
    MaterialColor backgroundGrey =
        MaterialColor(0xffF4F4F4, customColors.primaryDark);
    MaterialColor customLightGrey =
        MaterialColor(0xffE6EBF2, customColors.lightGreyColorCodes);
    MaterialColor customYellow =
        MaterialColor(0xffFBD180, customColors.yellowColorCodes);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider(create: (context) => InternetBloc()),
        RepositoryProvider(create: (context) => ForgotPasswordBloc()),
        RepositoryProvider(create: (context) => SearchPageBloc()),
        RepositoryProvider(create: (context) => DashboardBloc()),
        RepositoryProvider(create: (context) => RecipeDescriptionBloc()),
        RepositoryProvider(create: (context) => ShoppingListBloc()),
        RepositoryProvider(create: (context) => ScheduleMealBloc()),
        RepositoryProvider(create: (context) => MealPlanBloc()),
        RepositoryProvider(create: (context) => EditProfileBloc()),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        ),
        child: GetMaterialApp(
          routes: {
            '/userPrefFromSignup': (context) => const UserPreferences(),
          },
          title: 'Fecipe',
          theme: ThemeData(
            textTheme: TextTheme(
              displayLarge: GoogleFonts.dmSans(
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
              titleLarge: GoogleFonts.dmSans(fontSize: 22),
              bodyLarge: GoogleFonts.dmSans(fontSize: 18),
              bodyMedium: GoogleFonts.dmSans(fontSize: 16),
            ),
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: customTeal,
                accentColor: Colors.white,
                errorColor: Colors.red,
                backgroundColor: backgroundGrey,
                cardColor: customLightGrey),
          ),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
