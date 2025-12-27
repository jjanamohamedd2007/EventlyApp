import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app/providers/auth_provider.dart';
import 'package:evently_app/providers/create_event_provider.dart';
import 'package:evently_app/providers/event_filter_provider.dart';
import 'package:evently_app/providers/home_navigation_provider.dart';
import 'package:evently_app/screens/create_event_screen/create_event_screen.dart';
import 'package:evently_app/screens/forget_password_screen/forget_password_screen.dart';
import 'package:evently_app/screens/home_screen/home_screen.dart';
import 'package:evently_app/screens/login_screen/login_screen.dart';
import 'package:evently_app/screens/on_boarding_screen/on_boarding_screen.dart';
import 'package:evently_app/screens/signup_screen/signup_screen.dart';
import 'package:evently_app/screens/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'firebase_options.dart';
import 'providers/my_provider.dart';
import 'core/theme/base_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeNavigationProvider()),
        ChangeNotifierProvider(create: (_) => CreateEventProvider()),
        ChangeNotifierProvider(create: (_) => EventFilterProvider()),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        startLocale: const Locale('en'),
        useOnlyLangCode: true,
        saveLocale: false,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);

    final bool isDark = provider.themeMode == ThemeMode.dark;

    return AnimatedTheme(
      data: isDark ? BaseTheme.dark : BaseTheme.light,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: provider.locale,
        theme: BaseTheme.light,
        darkTheme: BaseTheme.dark,
        themeMode: provider.themeMode,
        routes: {
          SplashScreen.routeName: (_) => const SplashScreen(),
          OnBoardingScreen.routeName: (_) => const OnBoardingScreen(),
          LoginScreen.routeName: (_) => const LoginScreen(),
          ForgetPasswordScreen.routeName: (_) =>  ForgetPasswordScreen(),
          SignupScreen.routeName: (_) => const SignupScreen(),
          HomeScreen.routeName: (_) => const HomeScreen(),
          CreateEventScreen.routeName: (_) => CreateEventScreen(),
        }
        ,
        initialRoute: authProvider.currentUser != null
            ? HomeScreen.routeName
            : OnBoardingScreen.routeName,
      ),
    );
  }
}
