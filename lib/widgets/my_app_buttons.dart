import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String title;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final Function function;
  final double? height;

  const MyButton({
    super.key,
    required this.title,
    this.color,
    this.height,
     this.margin,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
        alignment: Alignment.center,
        margin: margin??EdgeInsets.zero,
        height: height ?? 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(10),
          color: Colors.indigo,
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyLoadingButton extends StatelessWidget {
  const MyLoadingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(10),
        color: Colors.indigo,
      ),
      child: const CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}
