import 'package:flutter/material.dart';

class MatchRating extends StatelessWidget {
  final int rating;
  const MatchRating({
    Key key,
    @required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size.width;
    final boxWidth = (mediaQuery / 3);
    return Container(
      height: boxWidth,
      width: boxWidth,
      decoration: BoxDecoration(
        color: Colors.black87,
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          rating.toString(),
          style: TextStyle(
              color: (rating > 0) ? Colors.green : Colors.red,
              fontSize: boxWidth / 4.5),
        ),
      ),
    );
  }
}
