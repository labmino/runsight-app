import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  final int currentPage;
  final int itemCount;

  const DotsIndicator({
    Key? key,
    required this.currentPage,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: currentPage == index ? 12.0 : 8.0,
          height: currentPage == index ? 12.0 : 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index ? Colors.blue : Colors.grey,
          ),
        );
      }),
    );
  }
}
