import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:consulting_platform/AppCubit/app_cubit.dart';
import 'package:consulting_platform/Network/remote/dio_helper.dart';
import 'package:consulting_platform/locator.dart';
import 'package:consulting_platform/modules/Add%20Expert%20Page/add_expert_page.dart';
import 'package:consulting_platform/modules/Main%20Screen/main_screen.dart';
import 'package:consulting_platform/modules/signIn%20Page/sign_in_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  Future<Widget> futureCall() async {
    AppCubit cubit = getIt<AppCubit>();
    await Future.delayed(const Duration(seconds: 2));
    if (cubit.checkToken) await cubit.getAccountType();
    return cubit.checkToken
        ? cubit.isExpert && cubit.dataCompleted == false
            ? Future.value(const AddExpertPage())
            : Future.value(MainScreen(
                isExpert: cubit.isExpert,
                infoProf: await DioHelper.userProfile(),
              ))
        : Future.value(const SignInPage());
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset(
        'assets/images/image.png',
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.error,
            color: Colors.white,
            size: 20,
          );
        },
      ),
      backgroundColor: Colors.indigo,
      showLoader: true,
      loaderColor: Colors.white,
      title:
          const Text('Istishara', style: TextStyle(color: Colors.indigoAccent)),
      futureNavigator: futureCall(),
    );
  }
}
