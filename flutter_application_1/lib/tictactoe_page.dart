import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main_color.dart';
import 'package:google_fonts/google_fonts.dart';

class TictactoePage extends StatefulWidget {
  const TictactoePage({super.key});

  @override
  State<TictactoePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TictactoePage> {
  bool oTurn = true;
  List<String> displayXO = ['', '', '', '', '', '', '', '', ''];
  List<int> matchedIndexes = [];
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  String resultDeclaration = '';
  bool winnerFound = false;

  static const maxSeconds = 30;
  int seconds = maxSeconds;
  Timer? timer;
  bool isRunning = false;

  static var customFontWhite = GoogleFonts.coiny(
    textStyle: const TextStyle(
      color: Colors.white,
      letterSpacing: 3,
      fontSize: 28,
    ),
  );

  void startTimer() {
    if (isRunning) return;
    isRunning = true;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer();
          resetBoard();
        }
      });
    });
  }

  void stopTimer() {
    isRunning = false;
    timer?.cancel();
  }

  void resetTimer() => seconds = maxSeconds;

  void _tapped(int index) {
    if (displayXO[index] != '' || winnerFound) return;

    setState(() {
      displayXO[index] = oTurn ? 'O' : 'X';
      filledBoxes++;
      oTurn = !oTurn;
      _checkWinner();
    });
  }

  void _checkWinner() {
    List<List<int>> winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var condition in winConditions) {
      String a = displayXO[condition[0]];
      String b = displayXO[condition[1]];
      String c = displayXO[condition[2]];

      if (a == b && b == c && a != '') {
        setState(() {
          winnerFound = true;
          resultDeclaration = 'Jogador $a venceu!';
          matchedIndexes.addAll(condition);

          if (a == 'O') {
            oScore++;
          } else {
            xScore++;
          }

          stopTimer(); 
          
        });
        return;
      }
    }

    if (!winnerFound && filledBoxes == 9) {
      setState(() {
        resultDeclaration = 'Empate!';
        stopTimer(); 
      });
    }
  }

  void resetBoard() {
    setState(() {
      displayXO = ['', '', '', '', '', '', '', '', ''];
      matchedIndexes = [];
      filledBoxes = 0;
      winnerFound = false;
      resultDeclaration = '';
      oTurn = true;
      resetTimer();
    });
    startTimer();
  }

  Widget _buildTimer() {
    return Text(
      '$seconds s',
      style: customFontWhite,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                 
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Player O', style: customFontWhite),
                            Text(oScore.toString(), style: customFontWhite),
                          ],
                        ),
                        const SizedBox(width: 40),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Player X', style: customFontWhite),
                            Text(xScore.toString(), style: customFontWhite),
                          ],
                        ),
                      ],
                    ),
                  ),

                 
                  Expanded(
                    flex: 5,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _tapped(index),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  width: 5,
                                  color: MainColor.primaryColor,
                                ),
                                color: matchedIndexes.contains(index)
                                    ? MainColor.accentColor
                                    : MainColor.secondaryColor,
                              ),
                              child: Center(
                                child: Transform.translate(
                                  offset: const Offset(0, -4),
                                  child: Text(
                                    displayXO[index],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.coiny(
                                      textStyle: TextStyle(
                                        fontSize: 64,
                                        height: 1.0,
                                        color: matchedIndexes.contains(index)
                                            ? MainColor.secondaryColor
                                            : MainColor.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(resultDeclaration, style: customFontWhite),
                        const SizedBox(height: 10),
                        _buildTimer(),
                        const SizedBox(height: 20),

                       
                        if (winnerFound || (filledBoxes == 9 && resultDeclaration.isNotEmpty))
                          ElevatedButton(
                            onPressed: resetBoard,
                            child: const Text("Jogar novamente"),
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: startTimer,
                                child: const Text("Start"),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: stopTimer,
                                child: const Text("Pause"),
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
