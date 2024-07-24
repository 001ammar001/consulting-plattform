import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/components/app_route.dart';
import 'package:consulting_platform/locator.dart';
import 'package:consulting_platform/modules/favorites%20Screen/cubit/states.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import 'cubit/cubit.dart';

String forE = 'http://10.0.2.2:8000/storage/';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FavoritePageCubit cubit = getIt<FavoritePageCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.favorites,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: BlocBuilder(
        bloc: cubit..getFavoriteExpert(),
        builder: (context, state) {
          if (state is LoadFavoriteExpertsState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is FinishLoadFavoriteExpertsState) {
            if (state.favoritesList == null || state.favoritesList!.isEmpty) {
              return Center(
                  child: Text(AppLocalizations.of(context)!.no_fav_exp));
            } else {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                itemCount: state.favoritesList?.length,
                itemBuilder: (context, index) => Card(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListTile(
                      trailing: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      title: Text(state.favoritesList![index].firstName +
                          state.favoritesList![index].lastName),
                      leading: CircleAvatar(
                        radius: 27,
                        foregroundImage: NetworkImage(
                          '$forE/${state.favoritesList![index].image}',
                        ),
                        onForegroundImageError: (exception, stackTrace) =>
                            const Icon(Icons.error),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, spiralizerPage,
                            arguments: state.favoritesList![index].expertId);
                      },
                    ),
                  ),
                ),
              );
            }
          } else {
            return const Center(
              child: Text('404'),
            );
          }
        },
      ),
    );
  }
}
