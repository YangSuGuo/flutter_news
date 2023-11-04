import 'package:flutter/material.dart';

class itemIconButton extends StatelessWidget {
  const itemIconButton({
    super.key,
    this.icon,
    this.onPressed,
    this.data,
    this.size
  });

  // 语义标签
  final IconData? icon;
  final VoidCallback? onPressed;
  final String? data;
  final double? size;

  @override Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(icon,size: size),
          onPressed: onPressed,
          splashColor: Colors.transparent,
        ),
        if (data != null)
        Text(data!,style: const TextStyle()),
      ],
    );
  }
}