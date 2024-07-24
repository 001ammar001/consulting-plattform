import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import '../../../locator.dart';
import '../cubit/profile_cubit.dart';
import 'package:consulting_platform/modules/profile%20page/cubit/profile_state.dart';

ProfilePageCubit cubit = getIt<ProfilePageCubit>();

class BookedAppointmentsPage extends StatelessWidget {
  const BookedAppointmentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: getIt<ProfilePageCubit>()
        ..profile().then((value) {
          cubit.setDate(context);
          cubit.resetTime(context);
        }),
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              actions: [
                if (!cubit.addTime)
                  IconButton(
                    onPressed: () {
                      cubit.changeScheduale();
                    },
                    icon: const Icon(Icons.work_history_outlined),
                  ),
                if (!cubit.seeBooked)
                  IconButton(
                    onPressed: () {
                      cubit.changeAddTime();
                    },
                    icon: const Icon(Icons.edit),
                  )
              ],
            ),
            body: state is AddTimeState || state is ProfileLoadingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: cubit.seeBooked
                            ? bookedAppointment(context)
                            : cubit.addTime
                                ? Column(
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: cubit.days.isEmpty
                                            ? 1
                                            : cubit.days.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              cubit.buildAddTimes(
                                                  context, index),
                                              const SizedBox(height: 10),
                                            ],
                                          );
                                        },
                                      ),
                                      ElevatedButton(
                                          onPressed: () async {
                                            await cubit
                                                .addTimes(context)
                                                .then((value) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(value)));
                                            });
                                          },
                                          child: state is SendingNumbers
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                              : Text(
                                                  AppLocalizations.of(context)!
                                                      .submit,
                                                  style: const TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.white))),
                                    ],
                                  )
                                : scheduale(context)),
                  ));
      },
    );
  }
}

Widget scheduale(context) => Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.free_time,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
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
          ],
        ),
        const SizedBox(height: 10),
        cubit.times != null
            ? cubit.times!.isNotEmpty
                ? DataTable(
                    dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.08);
                    }),
                    headingRowColor: MaterialStateProperty.resolveWith<Color?>(
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
                        tooltip: AppLocalizations.of(context)!.start_time,
                        label: Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.start_time,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                      DataColumn(
                        tooltip: AppLocalizations.of(context)!.end_time,
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
                        selected: false,
                        cells: [
                          DataCell(
                            Text(cubit.times![index].toString()),
                          ),
                          DataCell(
                            Text('${(cubit.appbointmentEndTime[index])}'),
                          ),
                        ],
                      ),
                    ),
                  )
                : Text(
                    AppLocalizations.of(context)!.no_free_time,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
            : Text(
                AppLocalizations.of(context)!.no_free_time,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
        const SizedBox(height: 10)
      ],
    );

Widget bookedAppointment(context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'booked appointment',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Colors.indigo),
        ),
        SizedBox(
          height: cubit.ex.bookedAppointments.isNotEmpty ? 15 : 150,
        ),
        cubit.ex.bookedAppointments.isNotEmpty
            ? ListView.builder(
                itemCount: cubit.ex.bookedAppointments.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var ba = cubit.ex.bookedAppointments[index];
                  return bookedAppointmentItem(ba.day - 1, ba.firstName,
                      ba.lastName, ba.numberOfHours, ba.startTime);
                },
              )
            : const Center(child: Text('No booked appointment yet')),
      ],
    );

Widget bookedAppointmentItem(int day, String firstName, String lastName,
        int numberOfHours, String startHour) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Text(
          cubit.daysMenuItems[day],
        ),
        title: Text('$firstName $lastName'),
        trailing: CircleAvatar(
          child: Text('$numberOfHours h'),
        ),
        subtitle: Text("starting from $startHour"),
        tileColor: Colors.grey[200],
      ),
    );
