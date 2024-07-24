import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import '../../../locator.dart';
import '../cubit/specialized_details_cubit.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: BlocBuilder(
          bloc: getIt<DetailsScreenCubit>()..setConslutings(),
          builder: (context, state) {
            DetailsScreenCubit cubit = getIt.get<DetailsScreenCubit>();
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.book_appointment,
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.indigo),
                        ),
                        const Icon(
                          Icons.date_range,
                          size: 75,
                          color: Colors.indigo,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.chose_consulting,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        DropdownButton(
                          items: cubit.conslutingsDropDownItems,
                          value: cubit.chosedConsluting,
                          hint: Text(AppLocalizations.of(context)!.chose),
                          onChanged: (value) {
                            value != null
                                ? cubit.changeConsluting(value)
                                : null;
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.day,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        DropdownButton(
                          value: cubit.daySelected,
                          onChanged: (value) {
                            if (value != null) cubit.changeDay(value);
                          },
                          items: cubit.daysDropDownItems,
                        ),
                        Text(
                          AppLocalizations.of(context)!.hour,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        DropdownButton(
                          value: cubit.hoursSelected,
                          items: cubit.hoursDropDownItems,
                          onChanged: (value) {
                            if (value != null) cubit.changeHour(value);
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    cubit.chosedConsluting != null
                        ? cubit.times != null
                            ? DataTable(
                                dataRowColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                  return Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.08);
                                }),
                                headingRowColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                  return Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.6);
                                }),
                                border: TableBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                columns: [
                                  DataColumn(
                                    tooltip: AppLocalizations.of(context)!
                                        .start_time,
                                    label: Expanded(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .start_time,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    tooltip:
                                        AppLocalizations.of(context)!.end_time,
                                    label: Expanded(
                                      child: Text(
                                        AppLocalizations.of(context)!.end_time,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: List.generate(
                                  cubit.times!.length,
                                  (index) => DataRow(
                                    onSelectChanged: (val) {
                                      val == true
                                          ? showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                  AppLocalizations.of(context)!
                                                      .alert,
                                                ),
                                                content: Text(
                                                    '${AppLocalizations.of(context)!.book_the_date} ${AppLocalizations.of(context)!.from} ${cubit.times![index]} ${AppLocalizations.of(context)!.to} ${cubit.endTime[index]}'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .cancel),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await cubit
                                                          .bookAppointment(
                                                              index, context)
                                                          .then((value) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    value)));
                                                        Navigator.pop(context);
                                                        cubit.loadEexpertData(
                                                            cubit.expert!
                                                                .expertId,
                                                            context,
                                                            update: true);
                                                      });
                                                    },
                                                    child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .confirm),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : null;
                                    },
                                    selected: false,
                                    cells: [
                                      DataCell(
                                        Text(cubit.times![index].toString()),
                                      ),
                                      DataCell(
                                        Text('${cubit.endTime[index]}'),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Text(
                                AppLocalizations.of(context)!.no_free_time,
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              )
                        : Text(AppLocalizations.of(context)!
                            .chose_consulting_first),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
            );
          },
        ));
  }
}
