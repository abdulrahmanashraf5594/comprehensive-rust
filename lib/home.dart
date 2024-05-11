// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:test1232/main.dart';
// import 'package:test1232/scor.dart';
// import 'package:test1232/snake_game.dart';

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
//     final bool isDark = brightnessValue == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ScoreScreen()),
//               );
//             },
//             icon: Icon(Icons.score),
//           ),
//           IconButton(
//   onPressed: () {
//     // تحديد الثيم الحالي
//     ThemeMode currentThemeMode = Provider.of<ThemeProvider>(context, listen: false).themeMode;
    
//     // تبديل بين الثيمين
//     ThemeMode newThemeMode = currentThemeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    
//     // تعيين الثيم الجديد
// Provider.of<ThemeProvider>(context, listen: false).setTheme(newThemeMode, context);
//   },
//   icon: Consumer<ThemeProvider>(
//     builder: (context, themeProvider, child) {
//       // استخدام الثيم المخزن لتحديد الرمز المناسب للزر
//       return Icon(
//         themeProvider.themeMode == ThemeMode.dark
//             ? Icons.light_mode
//             : Icons.dark_mode,
//       );
//     },
//   ),
// ),

//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => GameScreen()),
//                 );
//               },
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all<Color>(
//                   isDark ? Colors.blueGrey : Colors.blue,
//                 ),
//               ),
//               child: Text(
//                 'Start Game',
//                 style: TextStyle(
//                   color: isDark ? Colors.white : Colors.black,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
