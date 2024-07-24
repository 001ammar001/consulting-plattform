import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/AppCubit/app_cubit.dart';
import 'package:consulting_platform/Network/remote/dio_helper.dart';
import 'package:consulting_platform/components/app_route.dart';
import 'package:consulting_platform/locator.dart';
import 'package:consulting_platform/models/profile_drawer.dart';
import 'cubit/main_screen_cubit.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.isExpert, required this.infoProf});

  final bool isExpert;
  final DataProfile infoProf;

  @override
  Widget build(BuildContext context) {
    final MainScreenCubit cubit = getIt<MainScreenCubit>();
    return BlocBuilder(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              if (cubit.currentIndex == 2)
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, infoEdit);
                    },
                    icon: const Icon(Icons.edit))
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.indigo,
                  ), //BoxDecoration
                  child: UserAccountsDrawerHeader(
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(color: Colors.indigo),
                    accountName: Text(
                      "${infoProf.firstName} ${infoProf.lastName}",
                    ),
                    accountEmail:
                        Text('${infoProf.email} \n${infoProf.wallet} '),
                    currentAccountPictureSize: const Size.square(50),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.indigoAccent,
                      child: Text(
                        infoProf.firstName[0].toUpperCase(),
                        style: const TextStyle(
                            fontSize: 30.0, color: Colors.white),
                      ), //Text
                    ), //circleAvatar
                  ), //UserAccountDrawerHeader
                ),
                if (isExpert)
                  ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.booked_appointments,
                    ),
                    trailing: const Icon(Icons.table_chart),
                    onTap: () {
                      if (isExpert) {
                        Navigator.pushNamed(context, bookedAppointmentsPage);
                      }
                    },
                  ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.favorites,
                  ),
                  trailing: const Icon(Icons.favorite),
                  onTap: () {
                    Navigator.pushNamed(context, favoritesPage);
                  },
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.language,
                  ),
                  trailing: const Icon(Icons.language),
                  onTap: () => getIt<AppCubit>().changeLanguage(),
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.logout,
                  ),
                  trailing: const Icon(Icons.logout),
                  onTap: () async {
                    Navigator.pop(context);
                    await DioHelper.logout()
                        ? Navigator.pushReplacementNamed(context, singIn)
                        : ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('error')));
                  },
                ),
              ],
            ),
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: ConvexAppBar(
            initialActiveIndex: cubit.currentIndex,
            backgroundColor: Colors.indigo,
            items: [
              const TabItem(icon: Icons.message),
              const TabItem(icon: Icons.home),
              if (isExpert) ...[
                const TabItem(icon: Icons.person),
              ],
            ],
            onTap: (index) {
              cubit.changeScreen(index: index);
            },
          ),
        );
      },
    );
  }
}
