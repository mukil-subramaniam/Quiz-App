import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:quiz_api/components/custom_button.dart';
import 'package:quiz_api/components/quiz_app_bar.dart';
import 'package:quiz_api/components/response_tile.dart';
import 'package:quiz_api/model/question_model.dart';
import 'package:quiz_api/provider/game_provider.dart';
import 'package:quiz_api/router/app_route.dart';
import 'package:quiz_api/theme/app_theme.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Question currentQuestion;

  @override
  void initState() {
    currentQuestion =
        Provider.of<GameProvider>(context, listen: false).currentQuestion!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primeryTextColor,
      body: SafeArea(
        child: Column(
          children: [
            const Gap(10),
            const QuizAppBar(),
            QuizSection(
              question: currentQuestion,
            ),
          ],
        ),
      ),
    );
  }
}

class QuizSection extends StatefulWidget {
  final Question question;

  const QuizSection({Key? key, required this.question}) : super(key: key);

  @override
  State<QuizSection> createState() => _QuizSectionState();
}

class _QuizSectionState extends State<QuizSection> {
  int maxSeconds = 60;
  late int seconds = 60;
  late Timer timer;

  @override
  void initState() {
    seconds = maxSeconds;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (seconds > 0) {
          setState(() {
            seconds--;
          });
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoute.scorePage,
            (route) => false,
            arguments: Provider.of<GameProvider>(context, listen: false).score,
          );
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<GlobalKey<ResponseTileState>> responseTileKeys =
        Provider.of<GameProvider>(context, listen: false).responseTileKeys;

    return Consumer<GameProvider>(builder: (context, gameProvider, child) {
      List<Map<String, dynamic>> answers = [
        gameProvider.currentQuestion!.answerA,
        gameProvider.currentQuestion!.answerB,
        gameProvider.currentQuestion!.answerC,
        gameProvider.currentQuestion!.answerD,
      ];
      return Column(
        children: [
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: AppTheme.screenHeight(context) * 0.0922 / 2),
                height: MediaQuery.of(context).size.height * 0.24,
                width: MediaQuery.of(context).size.width - 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff000000).withOpacity(0.15),
                      spreadRadius: -10,
                      blurRadius: 50,
                      offset: const Offset(0, 7),
                    )
                  ],
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: (MediaQuery.of(context).size.width - 24) * 0.06,
                      right: (MediaQuery.of(context).size.width - 24) * 0.06,
                      top: AppTheme.screenHeight(context) * 0.0922 / 2,
                      bottom: (MediaQuery.of(context).size.width - 24) * 0.06,
                    ),
                    child: Text(
                      gameProvider.currentQuestion!.question,
                      style: AppTheme.textStyle(
                        color: Colors.black,
                        fontWeight_: AppTheme.semiBold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: (MediaQuery.of(context).size.width - 24) / 2 - 20,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                        backgroundColor: const Color(0xffABD1C6),
                        value: seconds / maxSeconds,
                        strokeWidth: 6,
                        strokeCap: StrokeCap.round,
                      ),
                      Center(
                        child: Text(
                          "$seconds",
                          style: AppTheme.textStyle(
                            color: AppTheme.primaryColor,
                            fontWeight_: FontWeight.w900,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Gap(MediaQuery.of(context).size.height * 0.05),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.446566,
            width: double.infinity,
            child: ListView.builder(
              itemCount: answers.length,
              itemBuilder: (context, index) {
                return ResponseTile(
                  key: responseTileKeys[index],
                  answer: answers[index],
                );
              },
            ),
          ),
          CustomButton(
            onTap: () {
              gameProvider.nextQuestion(context: context);
            },
            label: gameProvider.index < 9 ? "Next" : "Finish",
            color: AppTheme.primaryColor,
          )
        ],
      );
    });
  }
}
