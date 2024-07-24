import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/AppCubit/app_cubit.dart';
import 'package:consulting_platform/components/app_route.dart';
import 'package:consulting_platform/components/splash_screen.dart';
import 'package:consulting_platform/locator.dart';
import 'Network/remote/cache_helper.dart';
import 'bloc_observer.dart';

AppCubit cubit = getIt<AppCubit>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Bloc.observer = MyBlocObserver();
  setup();
  await CacheHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    cubit.setLanguage();
    // print(cubit.locale);
    // print(CacheHelper.getToken());
    // print(CacheHelper.getId());
    return BlocBuilder(
      bloc: cubit,
      builder: (context, state) => MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.generateRoute,
        locale: cubit.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.indigo,
              size: 30,
            ),
          ),
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.indigo,
          primaryColor: Colors.indigo,
          textTheme: const TextTheme(
              overline: TextStyle(overflow: TextOverflow.ellipsis)),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.indigo,
            accentColor: Colors.indigoAccent,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 4,
              minimumSize: const Size(double.infinity, 50),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
