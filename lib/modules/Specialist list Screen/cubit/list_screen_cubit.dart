import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:consulting_platform/Network/remote/dio_helper.dart';
import 'package:consulting_platform/models/show_experts.dart';
import 'list_screen_state.dart';

class ListScreenCubit extends Cubit<ListScreenStates> {
  ListScreenCubit() : super(ListScreenInitState());

  List<ExpertList> expertsList = [];
  String? selectedCategory;
  int indexOfCategory = 1;
  late List<Map<String, dynamic>> categories;
  List<dynamic> allCategories = [];
  List<String>? searchedCharacters;
  bool isSearch = false;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchExpertController = TextEditingController();

  bool focus = false;

  Future<void> getExperts() async {
    emit(LoadingExpertsState());
    expertsList = await DioHelper.getExperts(indexOfCategory.toString());
    emit(FinishLoadingExpertsState());
  }

  void setCategories({required BuildContext context}) async {
    indexOfCategory = 1;
    focus = false;
    categories = [
      {
        'label': AppLocalizations.of(context)?.legal,
        'icon': Icons.balance,
        'status': true,
      },
      {
        'label': AppLocalizations.of(context)?.medicine,
        'icon': Icons.medical_services,
        'status': false,
      },
      {
        'label': AppLocalizations.of(context)?.business,
        'icon': Icons.business_center_sharp,
        'status': false,
      },
      {
        'label': AppLocalizations.of(context)?.family,
        'icon': Icons.family_restroom_outlined,
        'status': false,
      },
      {
        'label': AppLocalizations.of(context)?.construction,
        'icon': Icons.construction,
        'status': false,
      },
    ];
    selectedCategory = AppLocalizations.of(context)?.legal;
    emit(LoadingExpertsState());
    expertsList = await DioHelper.getExperts(indexOfCategory.toString());
    emit(FinishLoadingExpertsState());
  }

  void changeCard({
    required int index,
  }) async {
    if (!categories[index]['status']) {
      for (var element in categories) {
        element['status'] = false;
      }
      categories[index]['status'] = true;
      selectedCategory = categories[index]['label'];
      indexOfCategory = index + 1;
      await getExperts();
      emit(ChangeCardState());
    }
  }

  void clearCategory() {
    for (var element in categories) {
      element['status'] = false;
    }
    isSearch = false;
    searchedCharacters =
        allCategories.map((e) => e["consulting_name"].toString()).toList();
    searchController.clear();
    emit(ClearSelectedCategoryState());
  }

  void changeCategory({required String name}) async {
    selectedCategory = name;
    for (var elm in allCategories) {
      elm["consulting_name"] == selectedCategory
          ? indexOfCategory = allCategories.indexOf(elm) + 1
          : null;
    }
    clearCategory();
    await getExperts();
    emit(ChagneSelectedCategoryState());
  }

  Widget buildSearch() {
    return TextField(
      controller: searchController,
      autofocus: focus,
      decoration: const InputDecoration(
        hintText: 'find a categories',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 18,
        ),
      ),
      onChanged: (value) {
        searchedCharacters = allCategories
            .map((e) => e['consulting_name'].toString().toLowerCase())
            .where((ele) => ele.contains(value))
            .toList();
        emit(ChangeSearchState());
      },
    );
  }

  List<Widget>? buildAppBarAction(BuildContext context) {
    return isSearch
        ? [
            IconButton(
                onPressed: () {
                  isSearch = false;
                  searchController.clear();
                  searchedCharacters = allCategories
                      .map((e) => e["consulting_name"].toString())
                      .toList();
                  focus = true;
                  emit(ChangeSearchState());
                },
                icon: const Icon(Icons.clear))
          ]
        : [
            IconButton(
                onPressed: () {
                  isSearch = true;
                  emit(ChangeSearchState());
                },
                icon: const Icon(Icons.search))
          ];
  }

  Future<void> getCategories() async {
    emit(LoadingCategorysState());
    allCategories = await DioHelper.getAllConsulting();
    emit(FinishLoadingCategorysState());
  }
}
