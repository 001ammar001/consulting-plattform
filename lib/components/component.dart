import 'package:flutter/material.dart';
import 'package:consulting_platform/components/app_route.dart';
import 'package:consulting_platform/models/show_experts.dart';

String ip = '43.12:80';
String forE = 'http://10.0.2.2:8000/storage/';
String forM = 'http://192.168.$ip/programming-languages/public/storage/';
String baseForMobile =
    'http://192.168.43.12:80/back/consultings-back/public/storage/';

Widget spisilizedItem(BuildContext context, {required ExpertList expert}) =>
    ListTile(
      onTap: () {
        Navigator.pushNamed(context, spiralizerPage,
            arguments: expert.expertId);
      },
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      tileColor: Colors.grey[200],
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [const Icon(Icons.star), Text('${expert.rate}')],
      ),
      title: Text(
        '${expert.firstName} ${expert.lastName}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
          '$forE/${expert.image}',
        ),
        onForegroundImageError: (exception, stackTrace) => const Icon(Icons.error),
      ),
    );

Widget spisilizeBuilder({required List<ExpertList> list}) {
  return ListView.separated(
    shrinkWrap: true,
    separatorBuilder: (context, index) => const SizedBox(height: 10),
    itemBuilder: (context, index) {
      return spisilizedItem(context, expert: list[index]);
    },
    itemCount: list.length,
    physics: const NeverScrollableScrollPhysics(),
  );
}

class CategoriesCard extends StatelessWidget {
  const CategoriesCard({
    super.key,
    required this.selected,
    this.categorey,
    required this.icon,
  });

  final bool selected;
  final String? categorey;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: selected ? Colors.indigo : Colors.grey[300],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 70,
            color: selected ? Colors.white : Colors.black,
          ),
          Text(
            '$categorey',
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: selected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
