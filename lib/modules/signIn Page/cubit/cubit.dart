import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/AppCubit/app_cubit.dart';
import 'package:consulting_platform/Network/remote/dio_helper.dart';
import 'package:consulting_platform/components/app_route.dart';
import 'package:consulting_platform/locator.dart';
import 'package:consulting_platform/main.dart';
import 'states.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';

class SignInPageCubit extends Cubit<SignInPageStates> {
  SignInPageCubit() : super(SignInPageInitState());

  final formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  List<String> data = [];

  Future<bool> passData() async {
    if (data != []) {
      data = [];
    }
    data.add(email.text);
    data.add(password.text);
    emit(SendDataState());
    bool res = await DioHelper.signIn(data);
    if (res) {
      AppCubit cubit = getIt<AppCubit>();
      await cubit.getAccountType();
      return true;
    }
    return false;
  }

  void clearData() {
    email.clear();
    password.clear();
  }

  Future<void> onPressed(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState!.validate()) {
      if (await passData()) {
        if (cubit.isExpert && cubit.dataCompleted == false) {
          Navigator.pushReplacementNamed(context, expertPage);
          clearData();
        } else {
          await DioHelper.getAccountType().then((isExpert) {
            DioHelper.userProfile().then((data) {
              Navigator.pushReplacementNamed(context, mainPage,
                  arguments: Arg(isExpert, data));
              clearData();
            });
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.invalid),
          ),
        );
      }
      emit(FinishSendDataState());
    }
  }

  String? emailValidator(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.not_empty;
    }
    if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value)) {
      return AppLocalizations.of(context)!.invalid;
    }
    return null;
  }

  String? passwordValidator(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.not_empty;
    }
    if (value.length < 6) {
      return AppLocalizations.of(context)!.passwordMore4;
    }
    return null;
  }
}
