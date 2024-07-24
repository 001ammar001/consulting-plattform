import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/components/app_route.dart';
import 'package:consulting_platform/modules/Experts%20List/cubit/list_screen_state.dart';
import '../../../../components/component.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../locator.dart';
import 'cubit/list_screen_cubit.dart';

class SpecialisestListScreen extends StatelessWidget {
  const SpecialisestListScreen({super.key});

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
                InkWell(
                  onTap: (() {
                    Navigator.pushNamed(context, searchExpertPage);
                  }),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          AppLocalizations.of(context)!.search,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
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
