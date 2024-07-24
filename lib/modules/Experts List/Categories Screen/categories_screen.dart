import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/locator.dart';
import 'package:consulting_platform/modules/Experts%20List/cubit/list_screen_cubit.dart';
import 'package:consulting_platform/modules/Experts%20List/cubit/list_screen_state.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: getIt<ListScreenCubit>()..getCategories(),
      listener: (context, state) {},
      builder: (context, state) {
        ListScreenCubit cubit = getIt.get<ListScreenCubit>();
        return Scaffold(
          appBar: AppBar(
            title: cubit.isSearch
                ? cubit.buildSearch()
                : Text(
                    AppLocalizations.of(context)!.categories,
                    style: const TextStyle(color: Colors.black),
                  ),
            leading: cubit.isSearch
                ? null
                : IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
            actions: cubit.buildAppBarAction(context),
          ),
          body: state is FinishLoadingCategorysState ||
                  cubit.allCategories.isNotEmpty
              ? cubit.searchedCharacters == null
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      itemBuilder: (context, index) => Card(
                            color: Colors.grey[100],
                            child: InkWell(
                              onTap: () {
                                cubit.changeCategory(
                                    name:
                                        "${cubit.allCategories[index]["consulting_name"]}");
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Text(
                                      "${cubit.allCategories[index]["consulting_name"]}"),
                                ),
                              ),
                            ),
                          ),
                      itemCount: cubit.allCategories.length)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      itemBuilder: (context, index) => Card(
                            color: Colors.grey[100],
                            child: InkWell(
                              onTap: () {
                                cubit.changeCategory(
                                    name: cubit.searchedCharacters![index]);
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Text(cubit.searchedCharacters![index],
                                    textAlign: TextAlign.center),
                              ),
                            ),
                          ),
                      itemCount: cubit.searchedCharacters!.length)
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }
}
