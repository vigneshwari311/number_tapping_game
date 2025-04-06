import 'dart:math';

import 'package:flutter/material.dart';
import 'package:number_tap_game/widgets/tile.dart';

class GridTileData{
  final int values;
  final Color color; 
  bool isTapped = false;

  GridTileData({
    required this.values,
    required this.color
  });
}

class HomePage extends StatefulWidget {
  final int gridSize; 
  const HomePage({
    super.key,
    required this.gridSize,
    });


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<GridTileData> finalList = [];
  int score =0;
  int nextNumber = 1;
  bool isGameStarted = false;
  Color ?selectedColor;
  int numberPressed = 0;
  
  
  @override
  void initState() {
    super.initState();
    gridShuffleList(widget.gridSize);
  }



List<GridTileData> gridShuffleList(int gridSize){
  

  List<GridTileData> set1 = List.generate((gridSize~/2), (index) => GridTileData(
    values: index+1, color: Color(0xFFD883FF)),);


  List<GridTileData> set2 = List.generate((gridSize~/2), (index) => GridTileData(
    values: index+1, color: Color(0xFF6C0BA9)));

  finalList =   [...set1,...set2];
  finalList.shuffle(Random());
  //print(finalList);

  return finalList;


}


void onTap(GridTileData item){

if (!isGameStarted || item.isTapped){
   return;
   }

   setState(() {
      numberPressed = item.values; 
    });

  
  if (selectedColor == null){
    if(item.values == 1){
      selectedColor = item.color;
    }
    else{
      gameOverDialog("Please start with 1");
      return;
    }
  }
      if (item.color != selectedColor) {
      gameOverDialog("Wrong color selected!");
      return;
    }

    
    if (item.values != nextNumber) {
      gameOverDialog("Wrong number! Tap in order.");
      return;
    }


  setState(() {
    item.isTapped = true;
    score+=1;
    nextNumber ++;
    numberPressed = item.values;
    //print(score);
    
  });

  if(score >= 25) gameWinDialog();
  
}


void gameOverDialog(String msg){
  showDialog(
    context: context, 
    builder: (_) => AlertDialog(
      title: Text("GameOver"),
      content: Text('$msg \nYour Score : $score'),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.pop(context);
            restartGame();
          }, 
          child: Text("Try Again"))
      ],

    ));
}

void gameWinDialog(){
  showDialog(
    context: context, 
    builder: (_) => AlertDialog(
      title : Text('You Win'),
      content: Text('Score : $score'),
      actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  restartGame();
                },
                child: Text("Play Again"),
              ),
            ],
    ));
}
  void startGame() {
    setState(() {
      isGameStarted = true;
      selectedColor = null;
      nextNumber = 1;
      numberPressed=0;
      score = 0;
      gridShuffleList(widget.gridSize);
    });
  }


void restartGame(){
  setState(() {
      isGameStarted = false;
      selectedColor = null;
      nextNumber = 1;
      numberPressed = 0;
      score = 0;
      gridShuffleList(widget.gridSize);
    });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text("Ascending Order Number Tapping Game"),
        backgroundColor: Color(0xFF512DA8),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
       
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text("Score : $score+",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                ),),
                SizedBox(width: 20,),
                Text("Number Pressed : $numberPressed",
                style: TextStyle(color: Colors.white70, fontSize: 20),
                )
              ],
            ),
          ),
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height *0.7,
              width: MediaQuery.of(context).size.width * 0.7,
              child: GridView.builder(
                itemCount: 50,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  ),
                  itemBuilder:(context,index){
                    final item = finalList[index] ;
                    return GestureDetector(
                      onTap: () => onTap(item),
                      child: Tile(
                         tileNumber: item.values.toString(), 
                         color: item.color,
                         isTapped : item.isTapped));
                  }),
            ),
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF9C27B0),
            ),
            onPressed: startGame, 
          child: Text(
            isGameStarted? "Restart" : "Start Game",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.white60,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
          ))
        ],  
      ),

      
      
    );
  }
}