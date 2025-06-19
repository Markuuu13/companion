import 'package:companion/constants.dart';
import 'package:flutter/material.dart';

class DateGrid extends StatelessWidget {
  const DateGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(8),
      physics: AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 19,
        childAspectRatio: 1.1 / 1,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            width: 200,
            height: 300,
            decoration: BoxDecoration(color: mainColor),
          ),
        );
      },
    );
  }
}
