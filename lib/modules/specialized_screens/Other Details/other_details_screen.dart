import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:consulting_platform/models/expert_profile.dart';
import '../../../locator.dart';
import '../cubit/specialized_details_cubit.dart';

class OtherDetails extends StatelessWidget {
  const OtherDetails({super.key});

  @override
  Widget build(BuildContext context) {
    DetailsScreenCubit cubit = getIt.get<DetailsScreenCubit>();
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder(
          bloc: getIt.get<DetailsScreenCubit>(),
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.other_details,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: Colors.indigo),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "1. ${AppLocalizations.of(context)!.expert_conslutings}",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.indigo),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 3,
                    runSpacing: 3,
                    children: [
                      for (int i = 0;
                          i < cubit.expert!.consultingsRates.length;
                          i++)
                        consultingItem(
                            cubit.expert!.consultingsRates.keys.toList()[i],
                            cubit.expert!.consultingsRates.values
                                .toList()[i]
                                .toDouble(),
                            context),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "2. ${AppLocalizations.of(context)!.experience_details}",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.indigo),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) =>
                          detailItem(cubit.expert!.experiences[index], context),
                      itemCount: cubit.expert!.experiences.length,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

Widget consultingItem(String consName, double consRate, context) {
  DetailsScreenCubit cubit = getIt.get<DetailsScreenCubit>();
  int consId = cubit.expert!.idsOfConsultings[consName];
  return Chip(
    labelPadding: const EdgeInsets.all(10),
    label: Text(
      consName,
      style: const TextStyle(fontSize: 12),
    ),
    avatar: CircleAvatar(
      radius: 25,
      child: Text('$consRate'),
    ),
    deleteIcon: const Icon(Icons.star),
    deleteButtonTooltipMessage: AppLocalizations.of(context)!.rate,
    onDeleted: () {
      showDialog(
        context: context,
        builder: (contextShowDialog) => AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.rate,
          ),
          content: RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.indigoAccent,
                  ),
              onRatingUpdate: (value) => cubit.changeRating(value)),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(contextShowDialog)!.cancel),
              onPressed: () {
                Navigator.of(contextShowDialog).pop();
              },
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(contextShowDialog);
                await cubit.sendRating(context, consId);
              },
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ],
        ),
      );
    },
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
