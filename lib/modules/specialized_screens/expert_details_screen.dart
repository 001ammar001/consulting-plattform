import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:consulting_platform/components/app_route.dart';
import 'package:consulting_platform/locator.dart';

import 'cubit/specialized_details_cubit.dart';
import 'cubit/specialized_details_states.dart';

String ip = '43.12:80';
String forE = 'http://10.0.2.2:8000/storage/';
String forM = 'http://192.168.$ip/programming-languages/public/storage/';
String baseForMobile =
    'http://192.168.43.12:80/back/consultings-back/public/storage/';

class ExpertDetailsScreen extends StatelessWidget {
  final int id;

  const ExpertDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder(
        bloc: getIt<DetailsScreenCubit>()
          ..loadEexpertData(id, context)
          ..setDate(context),
        builder: (context, state) {
          DetailsScreenCubit cubit = getIt<DetailsScreenCubit>();
          var expert = cubit.expert;
          return state is! LoadingExepertDataState
              ? Padding(
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
                                child: expert?.image != null
                                    ? CircleAvatar(
                                        foregroundColor: Colors.redAccent,
                                        foregroundImage: NetworkImage(
                                          '$forE/${expert!.image}',
                                        ),
                                        onForegroundImageError:
                                            (exception, stackTrace) =>
                                                const Icon(Icons.error),
                                      )
                                    : const CircleAvatar(
                                        child: Icon(Icons.person)),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "${expert!.firstName} ${expert.lastName}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await cubit.creatChannel(context).then(
                                            (value) => value != -1
                                                ? Navigator.pushNamed(
                                                    context, chatPage,
                                                    arguments: value)
                                                : ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                    content: Text("erro"),
                                                  )));
                                      },
                                      icon: const Icon(Icons.chat),
                                    ),
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow.shade900,
                                        ),
                                        Text(
                                          '${cubit.expert!.totalRate}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              AppLocalizations.of(context)!
                                                  .please_wait,
                                            ),
                                          ),
                                        );
                                        !cubit.isFavorite
                                            ? cubit
                                                .addToFavorite()
                                                .then((value) {
                                                cubit.changeFavorite();
                                                ScaffoldMessenger.of(context)
                                                    .clearSnackBars();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .add_successful),
                                                  ),
                                                );
                                              })
                                            : cubit
                                                .removeFromFavorite()
                                                .then((value) {
                                                cubit.changeFavorite();
                                                ScaffoldMessenger.of(context)
                                                    .clearSnackBars();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .remove_successful),
                                                  ),
                                                );
                                              });
                                      },
                                      icon: cubit.isFavorite
                                          ? const Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : const Icon(Icons.favorite_border),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              const Icon(Icons.attach_money),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  "${AppLocalizations.of(context)!.price}: ${expert.cost}",
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
                            padding:
                                const EdgeInsetsDirectional.only(start: 45),
                            child: Text(
                              "${AppLocalizations.of(context)!.country}: ${expert.country}"
                              " \n${AppLocalizations.of(context)!.city}: ${expert.city}"
                              "\n${AppLocalizations.of(context)!.street}: ${expert.street}",
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
                            padding:
                                const EdgeInsetsDirectional.only(start: 45),
                            child: Text('${expert.phoneNumbers[0].number}'),
                          ),
                          onTap: (() =>
                              Navigator.pushNamed(context, phoneNumberPage)),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.indigo,
                          ),
                          child: ListTile(
                            title: Row(children: [
                              const Icon(Icons.info_outline,
                                  color: Colors.white),
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
                              Navigator.pushNamed(context, detailsPage);
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
                                const Icon(Icons.date_range,
                                    color: Colors.white),
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
                              Navigator.pushNamed(context, schedulePage,
                                  arguments: cubit.expert);
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
