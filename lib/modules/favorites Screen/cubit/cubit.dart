import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/Network/remote/dio_helper.dart';
import 'package:consulting_platform/models/favorite_expert.dart';

import 'states.dart';

class FavoritePageCubit extends Cubit<FavoritePageStates> {
  FavoritePageCubit() : super(LoadFavoriteExpertsState());

  List<FavoriteExpert>? data;

  void getFavoriteExpert() async {
    emit(LoadFavoriteExpertsState());
    data = await DioHelper.getFavoriteExpert();
    emit(FinishLoadFavoriteExpertsState(data));
  }
}
