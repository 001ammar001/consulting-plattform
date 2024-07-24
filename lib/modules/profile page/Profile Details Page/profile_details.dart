import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:consulting_platform/locator.dart';
import 'package:consulting_platform/models/expert_profile.dart';
import 'package:consulting_platform/modules/profile%20page/cubit/profile_cubit.dart';
import 'package:consulting_platform/modules/profile%20page/cubit/profile_state.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    ProfilePageCubit cubit = getIt.get<ProfilePageCubit>();
    return BlocBuilder(
      bloc: getIt<ProfilePageCubit>(),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              cubit.isAddCons
                  ? IconButton(
                      onPressed: () {
                        cubit.changeAddCons();
                      },
                      icon: const Icon(Icons.close))
                  : cubit.consChange
                      ? IconButton(
                          onPressed: () {
                            cubit.changeCons();
                          },
                          icon: const Icon(Icons.done))
                      : IconButton(
                          onPressed: () {
                            cubit.changeCons();
                          },
                          icon: const Icon(Icons.edit)),
            ],
          ),
          body: state is ProfileLoadingState
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "1. ${AppLocalizations.of(context)!.expert_conslutings}",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.indigo),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        !cubit.isAddCons
                            ? !cubit.consChange
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return consultingItem(
                                          cubit.ex.consultingsRates.keys
                                              .toList()[index],
                                          cubit.ex.consultingsRates.values
                                              .toList()[index]
                                              .toDouble(),
                                          context);
                                    },
                                    itemCount: cubit.ex.consultingsRates.length,
                                  )
                                : Form(
                                    key: cubit.editConsKey,
                                    child: cubit.buildConsListView(
                                        cubit.currentCons,
                                        AppLocalizations.of(context)!
                                            .consluting,
                                        TextInputType.text,
                                        edit: true,
                                        phys: null),
                                  )
                            : Form(
                                key: cubit.consKey,
                                child: cubit.buildConsListView(
                                    cubit.listConsult,
                                    AppLocalizations.of(context)!.consluting,
                                    TextInputType.text,
                                    phys: null),
                              ),
                        Text(
                          "2. ${AppLocalizations.of(context)!.experience_details}",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.indigo),
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) =>
                              detailItem(cubit.ex.experiences[index], context),
                          itemCount: cubit.ex.experiences.length,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (!cubit.consChange)
                          ElevatedButton(
                              onPressed: () async {
                                if (!cubit.isAddCons && !cubit.consChange) {
                                  cubit.changeAddCons();
                                } else if (cubit.isAddCons) {
                                  if (cubit.consKey.currentState!.validate()) {
                                    await cubit
                                        .addNewCons(context)
                                        .then((value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBar(content: Text(value)));
                                    });
                                  }
                                }
                              },
                              child: state is SendingNumbers
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      cubit.isAddCons
                                          ? AppLocalizations.of(context)!.submit
                                          : AppLocalizations.of(context)!
                                              .add_new_consluting,
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.white))),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

Widget consultingItem(String consName, double consRate, context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      leading: CircleAvatar(
        child: Text("$consRate"),
      ),
      title: Text(consName),
      tileColor: Colors.grey[200],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    ),
  );
}

Widget detailItem(Experiences elm, context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ExpansionTile(
        title: Text(
          elm.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.indigo[10],
        children: [
          ListTile(
            title: Text(
              elm.description,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
