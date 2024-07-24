import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:consulting_platform/components/input_field.dart';
import 'package:consulting_platform/components/app_route.dart';
import 'package:consulting_platform/locator.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SignInPageCubit cubit = getIt<SignInPageCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: Form(
              key: cubit.formKey,
              child: BlocConsumer(
                bloc: getIt<SignInPageCubit>(),
                listener: (context, state) {},
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context)!.hello_again,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(color: Colors.indigo),
                      ),
                      const SizedBox(height: 30),
                      InputField(
                        keyboard: TextInputType.emailAddress,
                        labelText: AppLocalizations.of(context)!.email,
                        controller: cubit.email,
                        validator: (value) =>
                            cubit.emailValidator(context, value),
                      ),
                      const SizedBox(height: 10),
                      InputField(
                        labelText: AppLocalizations.of(context)!.password,
                        keyboard: TextInputType.text,
                        obscure: true,
                        controller: cubit.password,
                        validator: (value) =>
                            cubit.passwordValidator(context, value),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () {
                            cubit.onPressed(context);
                          },
                          child: state is SendDataState
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(AppLocalizations.of(context)!.signIn_here,
                                  style: const TextStyle(
                                      fontSize: 17, color: Colors.white))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: FittedBox(
                          child: Row(
                            children: [
                              Text(AppLocalizations.of(context)!.no_account,
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, singUp);
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.create_account,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      decoration: TextDecoration.underline,
                                      fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
