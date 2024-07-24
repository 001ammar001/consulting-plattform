import 'package:flutter/material.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';

import '../../../locator.dart';
import '../cubit/specialized_details_cubit.dart';

class PhoneNumberScreen extends StatelessWidget {
  const PhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DetailsScreenCubit cubit = getIt.get<DetailsScreenCubit>();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => phoneItem(
                    cubit.expert!.phoneNumbers[index].number, index + 1),
                itemCount: cubit.expert!.phoneNumbers.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget phoneItem(var number, index) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text("$index"),
        ),
        title: Text(number.toString()),
        tileColor: Colors.grey[200],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        trailing: const Icon(
          Icons.phone,
          color: Colors.indigo,
        ),
      ),
    );
