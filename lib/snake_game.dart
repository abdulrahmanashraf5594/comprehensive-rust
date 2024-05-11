import 'dart:async'; // استيراد المكتبة الخاصة بإدارة المؤقتات
import 'dart:math'; // استيراد المكتبة الخاصة بالرياضيات والأرقام العشوائية
import 'package:flutter/material.dart'; // استيراد مكتبة فلاتر المواد

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // قم بإخفاء علامة التصحيح في الزاوية العلوية اليمنى
      home: GameScreen(), // تعيين الشاشة الرئيسية لتكون GameScreen
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<int> snakePosition = [
    42,
    62,
    82,
    102
  ]; // قائمة تحتوي على مواقع الثعبان الأولية
  int numberOfSquares = 560; // إجمالي عدد المربعات في الشبكة
  static var randomNumber = Random();
  int food = randomNumber.nextInt(600); // موقع الطعام الأولي
  var speed = 300; // سرعة اللعبة الأولية
  bool playing = false; // علامة لتتبع ما إذا كانت اللعبة قيد التشغيل حاليًا
  bool endGame = false; // علامة لتتبع ما إذا انتهت اللعبة
  var direction = 'down'; // الاتجاه الأولي للثعبان
  int score = 0; // النقاط الأولية

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white12, // لون خلفية الشاشة
      body: Column(
        children: [
          Card(
            color: Colors.white24, // لون بطاقة أعلى الشاشة
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: playing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // زر إعادة اللعب
                        IconButton(
                          icon: Icon(Icons
                              .refresh), // تغيير الأيقونة لتكون رمز إعادة التحميل
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GameScreen()),
                            ); //لاعاده تشغيل اللعبة مرة اخرى
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            // عرض النقاط
                            'Score: ${snakePosition.length + score - snakePosition.length}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // زر بدء اللعب
                        OutlinedButton(
                          onPressed: () {
                            startGame();
                          },
                          child: Row(
                            children: const [
                              Text(
                                'Start',
                                style: TextStyle(color: Colors.yellow),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.play_arrow, color: Colors.yellow),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != 'up' && details.delta.dy > 0) {
                  direction = 'down';
                } else if (direction != 'down' && details.delta.dy < 0) {
                  direction = 'up';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != 'left' && details.delta.dx > 0) {
                  direction = 'right';
                } else if (direction != 'right' && details.delta.dx < 0) {
                  direction = 'left';
                }
              },
              child: Stack(
                children: [
                  GridView.builder(
                    itemCount: numberOfSquares,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (screenWidth / 20).floor(),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (snakePosition.contains(index)) {
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }
                      if (index == food) {
                        return Container(
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: const Center(
                              child: Icon(
                                Icons.fastfood,
                                size: 15,
                                color: Colors.yellow,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // وظيفة لبدء اللعبة
  startGame() {
    setState(() {
      playing = true;
    });
    endGame = false;
    snakePosition = [42, 62, 82, 102]; // إعادة تعيين موقع الثعبان
    score = 0; // إعادة تعيين النقاط
    var duration = Duration(milliseconds: speed);
    Timer.periodic(duration, (Timer timer) {
      updateSnake();
      if (gameOver() || endGame) {
        timer.cancel();
        showGameOverDialog();
        playing = false;
      }
    });
  }

  // وظيفة لإعادة بدء اللعبة
  restartGame() {
    setState(() {
      playing = true;
    });
    endGame = false;
    snakePosition = [42, 62, 82, 102]; // إعادة تعيين موقع الثعبان
    score = 0; // إعادة تعيين النقاط
    var duration = Duration(milliseconds: speed);
    Timer.periodic(duration, (Timer timer) {
      updateSnake();
      if (gameOver() || endGame) {
        timer.cancel();
        showGameOverDialog();
        playing = false;
      }
    });
  }

  // وظيفة لفحص انتهاء اللعبة
  gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 1; // بدء العد من 1
      for (int j = 0; j < snakePosition.length; j++) {
        if (i != j && snakePosition[i] == snakePosition[j]) {
          // التأكد من أن i ليس يساوي j
          count += 1;
        }
        if (count == 2) {
          setState(() {
            playing = false;
          });
          return true;
        }
      }
    }
    return false;
  }

  // وظيفة لعرض مربع الحوار عند انتهاء اللعبة
  showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'), // عنوان مربع الحوار
          content: Text(
              'Your score is ${snakePosition.length + score - snakePosition.length}'), // عرض النقاط
          actions: [
            TextButton(
              onPressed: () {
                restartGame(); // استدعاء وظيفة إعادة بدء اللعبة
                Navigator.of(context).pop(); // إزالة المعلمة الصحيحة
              },
              child: const Text('Play Again'), // زر اللعب مرة أخرى
            ),
          ],
        );
      },
    );
  }

  // وظيفة لتوليد طعام جديد
  generateNewFood() {
    food = randomNumber.nextInt(600);
    score += 10; // زيادة النقاط بمقدار 10 عند توليد طعام جديد
  }

  // وظيفة لتحديث موقع الثعبان
  updateSnake() {
    setState(() {
      switch (direction) {
        case 'down':
          snakePosition.add((snakePosition.last + 20) % numberOfSquares);
          break;
        case 'up':
          snakePosition.add(
              (snakePosition.last - 20 + numberOfSquares) % numberOfSquares);
          break;
        case 'left':
          snakePosition.add((snakePosition.last - 1) % numberOfSquares);
          break;
        case 'right':
          snakePosition.add((snakePosition.last + 1) % numberOfSquares);
          break;
        default:
      }
      if (snakePosition.last == food) {
        generateNewFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }
}
