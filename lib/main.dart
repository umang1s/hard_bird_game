import 'dart:math';

import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>  {

  AnimationController char,background;

 @override
  void initState() {
    super.initState();
    object=List();
    _update();
  }

  var random=new Random();

  _genrateNewPiller(){

    if(object.length==0) object.add(Position(H: 100,Y: 100,X:size.width.toInt()));
    if(object.length<4){
     // print(size.width);
     if(!random.nextBool()) return;

     int num1=random.nextInt(20)*5;
    //  if(random.nextBool()) num1+=object[object.length-1].Y;
    //  else num1-=object[object.length-1].Y;
    //  if(num1<0) num1+=100;
     int num2=random.nextInt(10)*5+90;
      if(object[object.length-1].X<size.width-100) //check last piller is generated 
        object.add(Position(H: num2,Y: num1,X:size.width.toInt()));
    }
  }

  _update()async{
    if(!_isPaused){
      _pillerGenrator++;
      if(_pillerGenrator%20==0) _genrateNewPiller();
      if(_pillerGenrator>1000000) _pillerGenrator=0;
        //character controlling
      if(_goUp>0){
        _birdY+=5;
        if(_birdY>=415) _startGame=false;
        _goUp--;
      }else {_birdY-=2; if(_birdY<-15 ) _startGame=false;}
      //object controlling

    }
    if(!_checkValidity()) _startGame=false;
    if(!_startGame) await _showDialog();
    setState(() {});
    await Future.delayed(Duration(milliseconds: 10));
    _update();
  }

  int _score=0;
  bool _startGame=true;
  bool _isPaused=true;
  int _speed=5;
  int _gravity=7;
  int _goUp=0;
  double _birdY=50,_birdX=80;
  int _pillerGenrator=0;
  Size size;
  int _top=0,_bottom=0;

  List<Position> object;

  bool _increament=false;
  bool _checkValidity(){
    if(object.length==0 || _isPaused) return true;
    bool ret=true;
    int xx=object[0].X;
    if(xx<140 && xx>60){
      _top=450-object[0].Y;
      _bottom=_top-object[0].H;
      //print("$_top $_bottom $_birdY");
      if(_birdY<_bottom-50) ret=false;
      else if(_birdY>_top-30) ret=false;
    }
    for(int i=0; i<object.length; i++){
      object[i].X-=_speed;
    }
    if(object[0].X<0 && !_increament){_score++;  _increament=true;}

    if(object[0].X<-70){
      _increament=false;
      if(_score%20==0) _speed++;
     object.removeAt(0);
    }
    return ret;
  }

  _showDialog()async{
    _isPaused=true;

    await showDialog(context: context,barrierDismissible: false,builder: (BuildContext context)=>AlertDialog(
      title:Center(child: Text('G A M E   O V E R',style: TextStyle(color: Colors.white,fontWeight: 
        FontWeight.bold,fontSize: 25),),), 
      backgroundColor: Colors.blue,
      content: Container( 
        height: 80,
        child: Column(children: [
          Text('Score : $_score',style: TextStyle(color: Colors.white,fontSize: 20)),
         // SizedBox(height:10),
          InkWell(
            child: Text('R E L O A D',style: TextStyle(color: Colors.white,fontSize:23,fontWeight: FontWeight.bold,backgroundColor: Colors.green)),
            onTap:(){
            _isPaused=false;
            _startGame=true;
            _score=0;
            _birdY=150;
            _speed=5;
            _goUp=0;
            object=List();
            Navigator.pop(context);
            },
          ),
        ],mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      )
    ));
  }



  Widget _makePiller(int index){

    if(index<object.length){ 
      double width=size.width-object[index].X;
      if(width>70) width=70;
      double topHeight=object[index].Y.toDouble();
      double bottomHeight=450-object[index].getBottom();

      return Container( 
      height: 450,width: width,
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container( 
              height: topHeight,width: width,
              
              decoration: BoxDecoration(  
                color: Colors.green,
                border: Border.all(width:10,color:Colors.green[600])
              ),
            ),
            Container( 
              height: bottomHeight, width: width,
              decoration: BoxDecoration(  
                color: Colors.green,
                border: Border.all(width:10,color:Colors.green[600])
              ),
            ),
          ],
        )
      );

    }
    return SizedBox();
  }

  double _getWidth(int num){
    if(object.length>num) return object[num].X.toDouble();
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: GestureDetector( 
        child: Column(children: [
          Container( 
          height: 40,
          color: Colors.green[600],
        ),
        Container( 
          height: 450,
          color: Colors.blue,
          child: Stack(  
            children: [
              Positioned(
                   left:_getWidth(0),
                   bottom: 0,
                   child: _makePiller(0)
              ),
              Positioned(
                   left:_getWidth(1),
                   bottom: 0,
                   child: _makePiller(1)
              ),
              Positioned(
                   left:_getWidth(2),
                   bottom: 0,
                   child: _makePiller(2)
              ),
              Positioned(
                   left:_getWidth(3),
                   bottom: 0,
                   child: _makePiller(3)
              ),
              Positioned(
                   left:_birdX,
                   bottom: _birdY,
                   child:Container( 
                     height: 50,width: 50,
                     child: Image.asset('images/sec.gif',fit: BoxFit.fill,),
                   )
              ),
            ],
          ),
        ),
        Container( 
          height: 20,
          color: Colors.green[600],
        ),
        Expanded(
          child: Container( 
            color: Colors.brown,
            child: Center( 
              child: Row( 
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                children: [
                  Text('SCORE : ',style: TextStyle(color: Colors.white,fontSize: 25),),
                  Text('$_score',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                  Icon(_isPaused? Icons.pause:Icons.play_arrow,color: Colors.white,),
                ],
              ),
            ),
          )
        )
      ],),
     onTap: (){
       int _current=DateTime.now().millisecondsSinceEpoch;
       if(_current-_lastTapped>200){
         _lastTapped=_current;
       if(_isPaused) {_isPaused=false; size=MediaQuery.of(context).size;}
       else _goUp+=20;
       }
     },
     onLongPress: (){
       _isPaused=!_isPaused;
     },
      ),
    );
  }

  int _lastTapped=0;

}

class Position{
  int X,Y,H;
  Position({this.X=0,this.Y=0,this.H});
  double getBottom(){
    return (Y+H).toDouble();
  }
}

//flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi
//flutter build apk --target-platform android-arm64 --split-per-abi