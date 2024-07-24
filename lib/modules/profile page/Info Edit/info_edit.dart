import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import '../../../components/input_field.dart';
import '../../../locator.dart';
import '../cubit/profile_cubit.dart';
import 'package:consulting_platform/modules/profile%20page/cubit/profile_state.dart';

class InofEdit extends StatelessWidget {
  const InofEdit({super.key});

  @override
  Widget build(BuildContext context) {
    String forE = 'http://10.0.2.2:8000/storage/';
    ProfilePageCubit cubit = getIt<ProfilePageCubit>();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: cubit.infoKey,
            child: BlocBuilder(
              bloc: getIt<ProfilePageCubit>(),
              builder: (context, state) {
                return Column(
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      alignment: Alignment.bottomRight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 1),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {
                              Image.asset('assets/images/big.png');
                              // const Icon(Icons.error,color: Colors.indigo,);
                            },
                            image: cubit.pickedFile != null
                                ? FileImage(File(cubit.pickedFile!.path))
                                : NetworkImage('$forE${cubit.ex.image}')
                                    as ImageProvider),
                      ),
                      child: Container(
                        transform: Matrix4.translationValues(15, 15, 0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.indigo,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt),
                          color: Colors.white,
                          iconSize: 30,
                          onPressed: () {
                            cubit.changeImage();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            labelText: AppLocalizations.of(context)!.city,
                            keyboard: TextInputType.text,
                            controller: cubit.cityController,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InputField(
                            labelText: AppLocalizations.of(context)!.country,
                            keyboard: TextInputType.text,
                            controller: cubit.countyController,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            labelText: AppLocalizations.of(context)!.street,
                            keyboard: TextInputType.streetAddress,
                            controller: cubit.streetController,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InputField(
                            labelText: AppLocalizations.of(context)!.price,
                            keyboard: TextInputType.number,
                            controller: cubit.priceController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    cubit.buildExpDetails(cubit.expName, cubit.expDesc),
                    const SizedBox(height: 10),
                    InputField(
                      labelText: AppLocalizations.of(context)!.password,
                      keyboard: TextInputType.visiblePassword,
                      controller: cubit.password,
                      obscure: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (cubit.infoKey.currentState!.validate()) {
                          await cubit.sendInfo().then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(value == '1'
                                  ? AppLocalizations.of(context)!.succsess
                                  : value == '2'
                                      ? AppLocalizations.of(context)!
                                          .password_incorect
                                      : AppLocalizations.of(context)!
                                          .unknow_error),
                            ));
                            if (value == '1') {
                              cubit.password.clear();
                              Navigator.pop(context);
                            }
                          });
                        }
                      },
                      child: state is UpdatingInfoState
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context)!.submit,
                              style: const TextStyle(
                                fontSize: 17,
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
    );
  }
}
