import 'dart:io';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/Network/remote/dio_helper.dart';
import 'package:consulting_platform/components/input_field.dart';
import 'package:consulting_platform/components/app_route.dart';
import 'package:consulting_platform/locator.dart';
import 'cubit/add_expert_cubit.dart';
import 'cubit/add_expert_states.dart';

class AddExpertPage extends StatelessWidget {
  const AddExpertPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddExpertPageCubit cubit = getIt<AddExpertPageCubit>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: cubit.formKey,
              child: BlocBuilder(
                bloc: getIt<AddExpertPageCubit>(),
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
                              image: cubit.pickedFile != null
                                  ? FileImage(File(cubit.pickedFile!.path))
                                  : const AssetImage('assets/images/big.png')
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
                      cubit.buildListView(
                          cubit.listPhone,
                          AppLocalizations.of(context)!.phone,
                          TextInputType.number),
                      cubit.buildListView(
                          cubit.listConsult,
                          AppLocalizations.of(context)!.consluting,
                          TextInputType.text),
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
                      const SizedBox(height: 20),
                      Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            AppLocalizations.of(context)!.enter_dates,
                            style: const TextStyle(fontSize: 18),
                          )),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cubit.days.isEmpty ? 1 : cubit.days.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              cubit.buildAddTimes(context, index),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (cubit.formKey.currentState!.validate()) {
                            // print(cubit.days == ['Chose day']);
                            // print(cubit.endTimes);
                            // print(cubit.startTimes);
                            if (cubit.days[0] == 'Chose day' ||
                                cubit.endTimes[0] == 'End Time 1' ||
                                cubit.startTimes[0] == 'Start Time 1') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('fill the dates')));
                            } else {
                              if (await cubit.sendData(context) ==
                                  AppLocalizations.of(context)!.succsess) {
                                Navigator.pushReplacementNamed(
                                    context, mainPage,
                                    arguments: Arg(
                                        true, await DioHelper.userProfile()));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("${cubit.msg}")));
                              }
                            }
                          }
                        },
                        child: state is SendingDataLoadingState
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
      ),
    );
  }
}
