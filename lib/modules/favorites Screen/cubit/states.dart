import 'package:consulting_platform/models/favorite_expert.dart';

abstract class FavoritePageStates {}

class LoadFavoriteExpertsState extends FavoritePageStates {}

class FinishLoadFavoriteExpertsState extends FavoritePageStates {
  List<FavoriteExpert>? favoritesList;

  FinishLoadFavoriteExpertsState(this.favoritesList);
}
