import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/components/component.dart';
import 'package:consulting_platform/locator.dart';
import 'cubit/search_expert_cubit.dart';

class SearchExpertPage extends StatelessWidget {
  const SearchExpertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: getIt<SearchExpertCubit>(),
      builder: (context, state) {
        SearchExpertCubit cubit = getIt<SearchExpertCubit>();
        return Scaffold(
          appBar: AppBar(
            title: cubit.buildSearch(context),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
            actions: cubit.buildAppBarAction(context),
          ),
          body: state is FinishExpertSearch || state is SearchExpertInitial
              ? cubit.expertResult.isEmpty
                  ? cubit.searchController.text.trim() == ''
                      ? const Center(child: Text('search for an expert'))
                      : const Center(
                          child: Text('no expert found'),
                        )
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: spisilizeBuilder(list: cubit.ex),
                    )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }
}
