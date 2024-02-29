import 'package:flutter/material.dart';
import 'package:quiz_api/router/app_route.dart';
import 'package:quiz_api/services/api_service.dart';

import '../components/response_tile.dart';
import '../model/question_model.dart';

class GameProvider extends ChangeNotifier {
  int points = 0;
  int score = 0;
  bool canSelected = true;
  int index = 0;
  final List<GlobalKey<ResponseTileState>> responseTileKeys = [
    GlobalKey<ResponseTileState>(),
    GlobalKey<ResponseTileState>(),
    GlobalKey<ResponseTileState>(),
    GlobalKey<ResponseTileState>(),
  ];
  Question? currentQuestion;
  List<Question> questions = [];
  List<Question> questionsTest = [
    Question(
      id: 1,
      question: "What is the Grade of the Kongu Engineering College?",
      answerA: {"text": "A++", "isCorrect": true},
      answerB: {"text": "A+", "isCorrect": false},
      answerC: {"text": "A", "isCorrect": false},
      answerD: {"text": "B", "isCorrect": false},
    ),
    Question(
      id: 2,
      question: "Who is the Principal of Kongu Engineering College?",
      answerA: {"text": "Bala", "isCorrect": false},
      answerB: {"text": "Balusamy", "isCorrect": true},
      answerC: {"text": "Raja", "isCorrect": false},
      answerD: {"text": "Lokesh", "isCorrect": false},
    ),
    Question(
      id: 3,
      question: "Which district is Kongu Engineering College in?",
      answerA: {"text": "Erode", "isCorrect": true},
      answerB: {"text": "Salem", "isCorrect": false},
      answerC: {"text": "Karur", "isCorrect": false},
      answerD: {"text": "Namakkal", "isCorrect": false},
    ),
    Question(
      id: 4,
      question: "Year did Kongu Engineering college start?",
      answerA: {"text": "1981", "isCorrect": false},
      answerB: {"text": "1983", "isCorrect": true},
      answerC: {"text": "1982", "isCorrect": false},
      answerD: {"text": "1984", "isCorrect": false},
    ),
    Question(
      id: 5,
      question: "How many departments are there in Kongu Engineering College?",
      answerA: {"text": "21", "isCorrect": true},
      answerB: {"text": "20", "isCorrect": false},
      answerC: {"text": "15", "isCorrect": false},
      answerD: {"text": "17", "isCorrect": false},
    ),
    Question(
      id: 6,
      question: "How many office bearers are there in kvitt?",
      answerA: {"text": "37", "isCorrect": false},
      answerB: {"text": "24", "isCorrect": true},
      answerC: {"text": "44", "isCorrect": false},
      answerD: {"text": "33", "isCorrect": false},
    ),
    Question(
      id: 7,
      question:
          "Who is the professor - in charge of the physical education department?",
      answerA: {"text": "Dr .K.kannan ,M.tech.phd.", "isCorrect": true},
      answerB: {"text": "Dr.S.Parthiban,M.E.phd", "isCorrect": false},
      answerC: {"text": "Dr.M.Kavin Kumar,M.sc.phd", "isCorrect": false},
      answerD: {"text": "Dr.R.K.Karthick", "isCorrect": false},
    ),
    Question(
      id: 8,
      question:
          "How many accommodation facilities are available in our campus?",
      answerA: {"text": "8", "isCorrect": false},
      answerB: {"text": "14", "isCorrect": false},
      answerC: {"text": "13", "isCorrect": true},
      answerD: {"text": "7", "isCorrect": false},
    ),
    Question(
      id: 9,
      question: "What plagiarism software access do we have in the library?",
      answerA: {"text": "Turnitin iTheticate.", "isCorrect": true},
      answerB: {"text": "Plagaware", "isCorrect": false},
      answerC: {"text": "Copyleaks", "isCorrect": false},
      answerD: {"text": "Smodin", "isCorrect": false},
    ),
    Question(
      id: 10,
      question:
          "For which student is the Chancellor Viswanathan Gold Medal Award given?",
      answerA: {"text": "best student of the year", "isCorrect": false},
      answerB: {"text": "gold medalist", "isCorrect": false},
      answerC: {"text": "best academic performer", "isCorrect": false},
      answerD: {"text": "best outgoing student", "isCorrect": true},
    ),
  ];

  Future<void> init({required String categorie}) async {
    questions = await ApiService.getQuestionByCaterory(categorie) ??
        await ApiService.getRandomQuestion() ??
        questionsTest;
    score = 0;
    canSelected = true;
    index = 0;
    currentQuestion = questions[index];
  }

  void nextQuestion({required BuildContext context}) {
    if (index < 9) {
      canSelected = true;
      for (var element in responseTileKeys) {
        element.currentState!.init();
      }
      if (index < questions.length) {
        index++;
        currentQuestion = questions[index];
        notifyListeners();
      }
    } else if (index == 9) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoute.scorePage, (route) => false,
          arguments: score);
    }
  }

  //Fonction qui se lance quand le user choisie une reponse
  void corrector() {
    for (var element in responseTileKeys) {
      element.currentState!.correction();
    }
    notifyListeners();
  }

  void playAgain({required BuildContext context}) {
    score = 0;
    canSelected = true;
    index = 0;
    currentQuestion = questions[index];
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoute.quizPage, (route) => false);
  }

  void addScore() {
    score++;
    notifyListeners();
  }
}
