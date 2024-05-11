import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreProvider extends ChangeNotifier {
  List<int> _scores = [];

  List<int> get scores => _scores;

  ScoreProvider() {
    _loadScores();
  }

  Future<void> _loadScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _scores = prefs.getStringList('scores')?.map((score) => int.parse(score)).toList() ?? [];
    notifyListeners();
  }

  Future<void> addScore(int score) async {
    _scores.add(score);
    _scores.sort((a, b) => b.compareTo(a)); 
    _scores = _scores.take(5).toList(); 
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('scores', _scores.map((score) => score.toString()).toList());
    notifyListeners();
  }
}

class ScoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scores'),
      ),
      body: Consumer<ScoreProvider>(
        builder: (context, scoreProvider, child) {
          List<int> scores = scoreProvider.scores;
          return ListView.builder(
            itemCount: scores.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  'Score ${scores[index]}',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
