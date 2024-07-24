import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/locator.dart';
import '../../components/app_route.dart';
import '../../components/component.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: getIt<ProfilePageCubit>()..profile(),
      builder: (context, state) {
        ProfilePageCubit cubit = getIt<ProfilePageCubit>();
        return state is ProfileLoadingState
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Container(
                                width: 125,
                                height: 125,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(55),
                                ),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    '$forE/${cubit.ex.image}',
                                  ),
                                  onBackgroundImageError:
                                      (exception, stackTrace) =>
                                          const AssetImage(
                                    'assets/images/big.png',
                                  ),
                                )),
                            const SizedBox(height: 15),
                            Text(
                              "${cubit.ex.firstName} ${cubit.ex.lastName}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              cubit.ex.email,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      Text('my balance : ${cubit.ex.balance}'),
                      ListTile(
                        title: Row(
                          children: [
                            const Icon(Icons.attach_money),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                "${AppLocalizations.of(context)!.price}: ${cubit.ex.cost}",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            const Icon(Icons.location_on_outlined),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.address,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        subtitle: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 45),
                          child: Text(
                            "${AppLocalizations.of(context)!.country}: ${cubit.ex.country}"
                            " \n${AppLocalizations.of(context)!.city}: ${cubit.ex.city}"
                            "\n${AppLocalizations.of(context)!.street}: ${cubit.ex.street}",
                          ),
                        ),
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            const Icon(Icons.local_phone),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.phone_number,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            const Icon(Icons.arrow_forward)
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 45),
                          child: Text('${cubit.ex.phoneNumbers[0].number}'),
                        ),
                        onTap: (() {
                          Navigator.pushNamed(context, profilePhones);
                        }),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.indigo,
                        ),
                        child: ListTile(
                          title: Row(children: [
                            const Icon(Icons.info_outline, color: Colors.white),
                            const SizedBox(width: 20),
                            Expanded(
                                child: Text(
                              AppLocalizations.of(context)!.other_details,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.white),
                            )),
                          ]),
                          onTap: () {
                            Navigator.pushNamed(context, profileDetails);
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.indigo,
                        ),
                        child: ListTile(
                          title: Row(
                            children: [
                              const Icon(Icons.date_range, color: Colors.white),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .list_of_schedule,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              bookedAppointmentsPage,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
