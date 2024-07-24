import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/components/app_route.dart';
import 'package:consulting_platform/modules/Specialist%20list%20Screen/cubit/list_screen_state.dart';
import '../../../../components/component.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../locator.dart';
import 'cubit/list_screen_cubit.dart';

class SpecialistListScreen extends StatelessWidget {
  const SpecialistListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: getIt<ListScreenCubit>()
        ..setCategories(context: context)
        ..getExperts(),
      builder: (context, state) {
        ListScreenCubit cubit = getIt.get<ListScreenCubit>();
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.book_appointment,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Material(
                  elevation: 4,
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  child: TextFormField(
                    onTap: () {
                      Navigator.pushNamed(context, searchExpertPage);
                    },
                    controller: cubit.searchController,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      labelText: AppLocalizations.of(context)!.search_helper,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      suffixIcon: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          splashRadius: 1,
                          icon: const Icon(Icons.search),
                          color: Colors.white,
                          iconSize: 30,
                          onPressed: () {
                            Navigator.pushNamed(context, searchExpertPage);
                          },
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${AppLocalizations.of(context)!.categories}:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, categoryPage);
                      },
                      child: Row(
                        children: [
                          Text(
                            cubit.selectedCategory!,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.search,
                            color: Colors.indigo,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 110,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 10,
                    ),
                    itemCount: cubit.categories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(20),
                        splashColor: Colors.black12,
                        onTap: () {
                          cubit.changeCard(
                            index: index,
                          );
                        },
                        child: CategoriesCard(
                          icon: cubit.categories[index]['icon'],
                          categorey: cubit.categories[index]['label'],
                          selected: cubit.categories[index]['status'],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  '${AppLocalizations.of(context)!.topRated}:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 15),
                state is LoadingExpertsState
                    ? const Center(child: CircularProgressIndicator())
                    : cubit.expertsList.isEmpty
                        ? Center(
                            child: Text(
                            AppLocalizations.of(context)!.no_expert_found,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ))
                        : spisilizeBuilder(list: cubit.expertsList)
              ],
            ),
          ),
        );
      },
    );
  }
}
