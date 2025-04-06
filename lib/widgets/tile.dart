import 'package:flutter/material.dart';

class Tile extends StatelessWidget{
  final String tileNumber;
  final Color color;
  final bool isTapped ;
  const Tile( {
    super.key, required this.tileNumber, required this.color, required this.isTapped
  });

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 0.5,
        width: 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isTapped ? Colors.transparent : Colors.white,
            width: 2,
          ),
          color: color,
        ),

        child: Center(
          child: Text(tileNumber , style: TextStyle(
            fontSize: 18,
            color: Colors.black)),
        ),
      ),
    );
  }
}

