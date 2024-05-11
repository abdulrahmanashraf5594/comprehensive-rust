// import 'dart:async';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class GameScreen extends StatefulWidget {
//   @override
//   _GameScreenState createState() => _GameScreenState();
// }

// class _GameScreenState extends State<GameScreen> {
//   List<Offset> _snake = [];
//   late Offset _food;
//   Direction _direction = Direction.right;
//   Random _random = Random();
//   int _score = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadScore();
//     _resetGame();
//     // بدء تحريك الثعبان بانتظام
//     Timer.periodic(Duration(milliseconds: 200), (timer) {
//       _moveSnake();
//     });
//   }

//   void _loadScore() async {
//     // استرجاع نقاط اللعبة من التخزين المحلي
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _score = prefs.getInt('score') ?? 0;
//     });
//   }

//   void _resetGame() async {
//     // إعادة تعيين اللعبة
//     _snake = [Offset(10, 10)]; // بداية الثعبان في موقع مرئي
//     _score = 0;
//     _generateFood();

//     // حفظ النقاط الجديدة في التخزين المحلي
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('score', _score);
//   }

//   void _generateFood() {
//     // إنشاء موقع للطعام خارج جسم الثعبان
//     _food =
//         Offset(_random.nextInt(20).toDouble(), _random.nextInt(20).toDouble());
//     // التحقق من صحة موقع الطعام
//     while (!foodPositionIsValid(_food)) {
//       _food = Offset(
//           _random.nextInt(20).toDouble(), _random.nextInt(20).toDouble());
//     }
//   }

//   bool foodPositionIsValid(Offset foodPosition) {
//     // التحقق مما إذا كان موقع الطعام داخل جسم الثعبان
//     return !_snake.contains(foodPosition);
//   }

//   void _moveSnake() {
//     setState(() {
//       // حساب موقع الرأس الجديد
//       Offset newHead = _snake.last + _direction.offset;

//       // التحقق من وصول الثعبان لأسفل الشاشة
//       if (newHead.dy >= 20) {
//         newHead = Offset(newHead.dx, 0); // التحرك للأعلى
//       }      // التحقق مما إذا كان الثعبان يلمس حواف الشاشة
//       else if (newHead.dx < 0) {
//         newHead = Offset(19, newHead.dy); // التحرك للجانب الأيمن
//       } else if (newHead.dx >= 20) {
//         newHead = Offset(0, newHead.dy); // التحرك للجانب الأيسر
//       } 
//       else if (newHead.dy < 0) {
//         newHead = Offset(newHead.dx, 19); // التحرك للأسفل
//       }

//       // التحقق مما إذا كان الثعبان يلمس جسده بالرأس فقط
//       if (_snake.sublist(0, _snake.length - 1).contains(newHead)) {
//         _resetGame();
//         return;
//       }

//       _snake.add(newHead);
//       if (newHead == _food) {
//         _score += 10;
//         _generateFood();
//         while (_snake.contains(_food)) {
//           _generateFood();
//         }
//         SharedPreferences.getInstance().then((prefs) {
//           prefs.setInt('score', _score);
//         });
//       } else {
//         // إذا لم يأكل الثعبان الطعام ، قم بإزالة الذيل للحفاظ على نفس الطول
//         _snake.removeAt(0);
//       }
//     });
//   }

//  @override
// Widget build(BuildContext context) {
//   // حجم الشاشة
//   final Size screenSize = MediaQuery.of(context).size;

//   return Scaffold(
//     appBar: AppBar(
//       title: Text('Snake Game'),
//     ),
//     body: Container(
//       padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Text(
//             'Score: $_score  ',
//             style: TextStyle(fontSize: 20),
//           ),
//           Container(
//             height: screenSize.height * 0.8,
//             child: GestureDetector(
//               onVerticalDragUpdate: (details) {
//                 if (_direction != Direction.down && details.delta.dy < 0) {
//                   _direction = Direction.up;
//                 } else if (_direction != Direction.up && details.delta.dy > 0) {
//                   _direction = Direction.down;
//                 }
//               },
//               onHorizontalDragUpdate: (details) {
//                 if (_direction != Direction.left && details.delta.dx > 0) {
//                   _direction = Direction.right;
//                 } else if (_direction != Direction.right && details.delta.dx < 0) {
//                   _direction = Direction.left;
//                 }
//               },
//               child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   final cellSize = screenSize.width / 20; // تحديد حجم الخلية
//                   return CustomPaint(
//                     painter: GamePainter(_snake, _food, cellSize),
//                     size: Size(
//                       constraints.maxWidth,
//                       constraints.maxHeight,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// }

// class Direction {
//   final Offset offset;

//   const Direction(this.offset);

//   static const up = Direction(Offset(0, -1));
//   static const down = Direction(Offset(0, 1));
//   static const left = Direction(Offset(-1, 0));
//   static const right = Direction(Offset(1, 0));
// }

// class GamePainter extends CustomPainter {
//   final List<Offset> _snake;
//   final Offset _food;
//   final double _cellSize;

//   GamePainter(this._snake, this._food, this._cellSize);

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint snakePaint = Paint()..color = Colors.black;
//     Paint foodPaint = Paint()..color = Colors.red;

//     // رسم الثعبان
//     for (Offset point in _snake) {
//       canvas.drawCircle(
//         Offset(point.dx * _cellSize + _cellSize / 2,
//             point.dy * _cellSize + _cellSize / 2),
//         _cellSize / 2,
//         snakePaint,
//       );
//     }

//     // رسم الطعام
//     canvas.drawCircle(
//       Offset(_food.dx * _cellSize + _cellSize / 2,
//           _food.dy * _cellSize + _cellSize / 2),
//       _cellSize / 2,
//       foodPaint,
//     );
//   }

//   @override
//   bool shouldRepaint(GamePainter oldDelegate) => true;
// }
