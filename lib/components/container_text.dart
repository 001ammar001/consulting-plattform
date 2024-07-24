import 'package:flutter/material.dart';

class ContainerText extends StatelessWidget {
  const ContainerText({Key? key, required this.text, this.disable = false})
      : super(key: key);

  final String text;
  final bool disable;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: disable ? Colors.grey[300] : null,
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Text(
          overflow: TextOverflow.ellipsis,
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
