import 'package:get_it/get_it.dart';
import 'package:consulting_platform/modules/specialized_screens/cubit/specialized_details_cubit.dart';
import 'AppCubit/app_cubit.dart';
import 'modules/Chat List Screen/cubit/cubit.dart';
import 'modules/Main Screen/cubit/main_screen_cubit.dart';
import 'modules/SignUp Page/cubit/cubit.dart';
import 'modules/Experts List/cubit/list_screen_cubit.dart';
import 'modules/Add Expert Page/cubit/add_expert_cubit.dart';
import 'modules/chat Page/cubit/cubit.dart';
import 'modules/favorites Screen/cubit/cubit.dart';
import 'modules/profile page/cubit/profile_cubit.dart';
import 'modules/search expert page/cubit/search_expert_cubit.dart';
import 'modules/signIn Page/cubit/cubit.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<SignUpPageCubit>(() => SignUpPageCubit());
  getIt.registerLazySingleton<SignInPageCubit>(() => SignInPageCubit());
  getIt.registerLazySingleton<AddExpertPageCubit>(() => AddExpertPageCubit());
  getIt.registerLazySingleton<ListScreenCubit>(() => ListScreenCubit());
  getIt.registerLazySingleton<MainScreenCubit>(() => MainScreenCubit());
  getIt.registerLazySingleton<AppCubit>(() => AppCubit());
  getIt.registerLazySingleton<DetailsScreenCubit>(() => DetailsScreenCubit());
  getIt.registerLazySingleton<FavoritePageCubit>(() => FavoritePageCubit());
  getIt.registerLazySingleton<ChatListCubit>(() => ChatListCubit());
  getIt.registerLazySingleton<ChatPageCubit>(() => ChatPageCubit());
  getIt.registerLazySingleton<ProfilePageCubit>(() => ProfilePageCubit());
  getIt.registerLazySingleton<SearchExpertCubit>(() => SearchExpertCubit());
  // getIt.registerLazySingletonAsync<SharedPreferences>(() => CacheHelper.init());
}
