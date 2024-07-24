import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:consulting_platform/locator.dart';
import 'package:consulting_platform/modules/profile%20page/cubit/profile_cubit.dart';
import 'package:consulting_platform/modules/profile%20page/cubit/profile_state.dart';

class ProfilePhone extends StatelessWidget {
  const ProfilePhone({super.key});

  @override
  Widget build(BuildContext context) {
    ProfilePageCubit cubit = getIt.get<ProfilePageCubit>();
    return BlocBuilder(
      bloc: getIt<ProfilePageCubit>(),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              cubit.isAddPhone
                  ? IconButton(
                      onPressed: () {
                        cubit.changePhoneAdd();
                      },
                      icon: const Icon(Icons.close))
                  : cubit.phoneChange
                      ? IconButton(
                          onPressed: () {
                            cubit.changePhoneEdit();
                          },
                          icon: const Icon(Icons.done))
                      : IconButton(
                          onPressed: () {
                            cubit.changePhoneEdit();
                          },
                          icon: const Icon(Icons.edit)),
            ],
          ),
          body: state is ProfileLoadingState
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  height: double.infinity,
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.phone_number,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(color: Colors.indigo),
                      ),
                      Expanded(
                        child: !cubit.isAddPhone
                            ? !cubit.phoneChange
                                ? ListView.builder(
                                    itemCount: cubit.ex.phoneNumbers.length,
                                    itemBuilder: (context, index) => phoneItem(
                                      cubit.ex.phoneNumbers[index].number,
                                      index,
                                    ),
                                  )
                                : Form(
                                    key: cubit.editPhoneKey,
                                    child: cubit.buildListView(
                                        cubit.currentPhones,
                                        AppLocalizations.of(context)!.phone,
                                        TextInputType.number,
                                        edit: true,
                                        phys: null),
                                  )
                            : Form(
                                key: cubit.formKey,
                                child: cubit.buildListView(
                                    cubit.listPhone,
                                    AppLocalizations.of(context)!.phone,
                                    TextInputType.number,
                                    phys: null),
                              ),
                      ),
                      if (!cubit.phoneChange)
                        ElevatedButton(
                            onPressed: () async {
                              if (!cubit.isAddPhone && !cubit.phoneChange) {
                                cubit.changePhoneAdd();
                              } else if (cubit.isAddPhone) {
                                if (cubit.formKey.currentState!.validate()) {
                                  await cubit
                                      .addNewNumber(context)
                                      .then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                                    cubit.isAddPhone
                                        ? AppLocalizations.of(context)!.submit
                                        : AppLocalizations.of(context)!
                                            .add_new_phone,
                                    style: const TextStyle(
                                        fontSize: 17, color: Colors.white))),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

Widget phoneItem(var number, forIndex) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
        leading: CircleAvatar(
          child: Text("${forIndex + 1}"),
        ),
        title: Text(number.toString()),
        tileColor: Colors.grey[200],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        trailing: const Icon(
          Icons.phone,
          color: Colors.indigo,
        )),
  );
}
