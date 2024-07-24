import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:consulting_platform/components/input_field.dart';
import 'package:consulting_platform/modules/SignUp%20Page/cubit/cubit.dart';
import 'package:consulting_platform/locator.dart';
import 'package:consulting_platform/modules/SignUp%20Page/cubit/states.dart';
import 'package:consulting_platform/modules/signIn%20Page/cubit/cubit.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static SignUpPageCubit cubit = getIt<SignUpPageCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: cubit.backButton(context),
      ),
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: cubit.formKey,
              child: BlocConsumer(
                  bloc: cubit,
                  listener: (context, state) {},
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)!.hello_sing_up,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(color: Colors.indigo),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: InputField(
                                keyboard: TextInputType.text,
                                labelText:
                                    AppLocalizations.of(context)!.firstName,
                                controller: cubit.firstName,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: InputField(
                                keyboard: TextInputType.text,
                                labelText:
                                    AppLocalizations.of(context)!.lastName,
                                controller: cubit.lastName,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        InputField(
                          keyboard: TextInputType.emailAddress,
                          labelText: AppLocalizations.of(context)!.email,
                          validator: (value) => getIt<SignInPageCubit>()
                              .emailValidator(context, value!),
                          controller: cubit.email,
                          errorText: cubit.emailTextError,
                        ),
                        const SizedBox(height: 10),
                        InputField(
                            labelText: AppLocalizations.of(context)!.password,
                            keyboard: TextInputType.text,
                            obscure: true,
                            controller: cubit.password,
                            errorText: cubit.passwordTextError,
                            validator: (value) => getIt<SignInPageCubit>()
                                .passwordValidator(context, value)),
                        const SizedBox(height: 10),
                        InputField(
                          labelText:
                              AppLocalizations.of(context)!.confirm_password,
                          keyboard: TextInputType.text,
                          obscure: true,
                          controller: cubit.confirmPassword,
                          errorText: cubit.passwordTextError,
                          validator: (value) => getIt<SignInPageCubit>()
                              .passwordValidator(context, value),
                        ),
                        CheckboxListTile(
                          title: Text(
                            AppLocalizations.of(context)!.expert_account,
                          ),
                          value: cubit.isExpert,
                          controlAffinity: ListTileControlAffinity.platform,
                          onChanged: (value) {
                            cubit.changeCheckBox(value!);
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            cubit.onPressed(context);
                          },
                          child: state is ProcessDataState
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  AppLocalizations.of(context)!.create_account,
                                  style: const TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: FittedBox(
                            child: Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.have_account,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.signIn_here,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
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
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
