import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/Network/remote/dio_helper.dart';

import '../../../models/show_experts.dart';

part 'search_expert_state.dart';

class SearchExpertCubit extends Cubit<SearchExpertState> {
  SearchExpertCubit() : super(SearchExpertInitial());

  TextEditingController searchController = TextEditingController();
  bool focus = true;
  Map expertResult = {};
  List<Map<String, dynamic>> experts = [];
  List<ExpertList> ex = [];

  Widget buildSearch(BuildContext context) {
    return TextField(
      controller: searchController,
      autofocus: focus,
      decoration: const InputDecoration(
        hintText: 'find a expert',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 18,
        ),
      ),
      onChanged: (value) async {
        emit(ChangeExpertSearch());
        expertResult = await DioHelper.getExpertsByName(value);
        await format().then((value) {
          emit(FinishExpertSearch());
        });
      },
    );
  }

  Future<void> format({bool clear = false}) async {
    experts = [];
    ex = [];
    if (expertResult.isNotEmpty && !clear) {
      for (int i = 0; i < expertResult["user_datails"][0].length; i++) {
        experts.add({});
        for (var element in expertResult["user_datails"]) {
          experts[i].addAll(element[i]);
        }
      }
      for (var element in expertResult["expert_datails"]) {
        experts[expertResult["expert_datails"].indexOf(element)]
            .addAll(element);
      }
      for (int i = 0; i < experts.length; i++) {
        int key = experts[i]["user_id"];
        experts[i].addAll({"rate": expertResult["expert_total_rate"]["$key"]});
      }
      ex = experts.map((e) => ExpertList.fromJson(e)).toList();
    }
  }

  List<Widget>? buildAppBarAction(BuildContext context) {
    return searchController.text.trim() != ''
        ? [
            IconButton(
                onPressed: () {
                  searchController.clear();
                  format(clear: true);
                  focus = false;
                  emit(FinishExpertSearch());
                },
                icon: const Icon(Icons.clear))
          ]
        : [
            IconButton(
                onPressed: () {
                  focus = true;
                },
                icon: const Icon(Icons.search))
          ];
  }
}
