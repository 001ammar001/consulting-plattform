import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/Network/remote/dio_helper.dart';
import 'package:consulting_platform/components/app_route.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import 'states.dart';

class SignUpPageCubit extends Cubit<SignUpPageStates> {
  SignUpPageCubit() : super(SignUpPageInitState());

  final formKey = GlobalKey<FormState>();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  bool isExpert = false;
  List<String> data = [];
  String? emailTextError;
  String? passwordTextError;

  void passwordError(BuildContext context, bool isValid) {
    passwordTextError = isValid ? null : AppLocalizations.of(context)!.not_same;
    emit(PasswordErrorState());
  }

  void clearData() {
    firstName.clear();
    lastName.clear();
    email.clear();
    password.clear();
    confirmPassword.clear();
    emailTextError = null;
    passwordTextError = null;
    data = [];
  }

  Future<bool> signUp() async {
    if (data != []) {
      data = [];
    }
    data.add(firstName.text);
    data.add(lastName.text);
    data.add(email.text);
    data.add(password.text);
    data.add(confirmPassword.text);
    data.add(isExpert == true ? '1' : '0');
    emit(ProcessDataState());
    bool res = await DioHelper.signUp(data);
    if (!res) {
      emailTextError = 'The email is used';
      emit(FailDataState());
      return false;
    } else {
      emit(SuccessDataState());
      clearData();
      return true;
    }
  }

  Future<void> onPressed(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState!.validate()) {
      if (password.text != confirmPassword.text) {
        passwordError(context, false);
        return;
      }
      passwordError(context, true);
      if (await signUp()) {
        isExpert
            ? Navigator.pushNamedAndRemoveUntil(
                context, expertPage, (route) => false)
            : Navigator.pushNamedAndRemoveUntil(
                context, mainPage, (route) => false,
                arguments: await DioHelper.userProfile());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The email has already been taken.'),
          ),
        );
      }
    }
  }

  void changeCheckBox(bool value) {
    isExpert = value;
    emit(ChangeCheckBoxState());
  }

  Widget? backButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.1),
        borderRadius: const BorderRadiusDirectional.horizontal(
          end: Radius.circular(10),
        ),
      ),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
