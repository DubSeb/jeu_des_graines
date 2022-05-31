import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'modules/niveaux.dart';

enum Direction { up, down, left, right, stop }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Niveaux lesNiveaux = Niveaux();
  int scoreTotal = 0;
  int transition = 0;
  int scoreNiveau = 0;
  int numeroNiveau = 0;
  List snakePosition = [];
  List foodPosition = [];
  List foodValues = [];
  bool mauvaiseGraine = false;

  int foodLocation = 500;
  var compteurFood = 0;
  bool presenteNiveau = true;
  Direction direction = Direction.stop;
  List<int> totalSpot = List.generate(1200, (index) => index); //totalspot

  startGame(Niveau niveau) {
    direction = Direction.stop;
    snakePosition = List.from(niveau.snakePositions);
    foodPosition = List.from(niveau.foodPositions);
    foodValues = List.from(niveau.foodValues);
    mauvaiseGraine = false;

    Timer.periodic(const Duration(milliseconds: 150), (timer) async {
      updateSnake();
      if (dansLeMur(snakePosition.last) || gameOver() || mauvaiseGraine) {
        timer.cancel();
        if (mauvaiseGraine) {
          gameOverAlert("Mauvaise graine!");
        } else {
          gameOverAlert("Perdu!");
        }
        // Reset
      }
      // Gestion niveau suivant
      if (scoreNiveau == niveau.scoreMax) {
        direction = Direction.stop;
        if (transition < 10) {
          transition++;
        } else {
          timer.cancel();
          niveauSuivant();
        }
      }
    });
  }

  niveauSuivant() {
    numeroNiveau = numeroNiveau + 1;

    if (numeroNiveau == lesNiveaux.nivMax) {
      // jeu terminé
      presenteNiveau = true;
      gameOverAlert("Bravo tu as gagné!");
    } else {
      transition = 0;
      presenteNiveau = true;
      scoreNiveau = 0;
      updateSnake();
    }
  }

  updateSnake() {
    var numGraine = 0;
    var minGraine = 0;
    setState(() {
      if (compteurFood > 0) {
        compteurFood = compteurFood + 1;
      }
      if (compteurFood > 10) {
        compteurFood = 0;
      }
      switch (direction) {
        case Direction.down:
          snakePosition.add(snakePosition.last + 40);
          break;
        case Direction.up:
          snakePosition.add(snakePosition.last - 40);
          break;
        case Direction.right:
          snakePosition.add(snakePosition.last + 1);
          break;
        case Direction.left:
          snakePosition.add(snakePosition.last - 1);
          break;
        default:
      }
      if (foodPosition.contains(snakePosition.last)) {
        // Valeur min
        minGraine = foodValues[0];

        for (var i = 0; i < foodValues.length; i++) {
          if (foodValues[i] < minGraine) {
            minGraine = foodValues[i];
          }
        }

        foodLocation = snakePosition.last;
        scoreNiveau = scoreNiveau + 1;
        scoreTotal = scoreTotal + 1;

        numGraine =
            foodPosition.indexWhere((element) => element == foodLocation);

        if (foodValues[numGraine] > minGraine) {
          mauvaiseGraine = true;
        } else {
          compteurFood = 1;
          foodValues.removeAt(numGraine);
          foodPosition.removeWhere((element) => element == foodLocation);
        }
      } else {
        if (direction != Direction.stop) {
          snakePosition.removeAt(0);
        }
      }
    });
  }

  bool gameOver() {
    final copyList = List.from(snakePosition);
    if (snakePosition.length > copyList.toSet().length) {
      return true;
    } else {
      return false;
    }
  }

  gameOverAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          content: Text('Ton score est de : $scoreTotal.'),
          actions: [
            TextButton(
                onPressed: () {
                  presenteNiveau = true;
                  // startGame();
                  numeroNiveau = 0;
                  scoreNiveau = 0;
                  scoreTotal = 0;
                  updateSnake();
                  Navigator.of(context).pop(true);
                },
                child: const Text('Rejouer.')),
            TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Quitter.'))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var myFocusNode = FocusNode();
    if (presenteNiveau) {
      if (numeroNiveau >= lesNiveaux.nivMax) {
        return Scaffold(
            backgroundColor: Colors.black,
            body: Container(
              color: Colors.black,
              child: const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "C'est gagné!!! 😄",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 80,
                    color: Colors.blue,
                  ),
                ),
              ),
            ));
      } else {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            color: Colors.black,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                lesNiveaux.liste[numeroNiveau].nomNiveau,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 80,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              myFocusNode.requestFocus();
              presenteNiveau = false;
              startGame(lesNiveaux.liste[numeroNiveau]);
            },
            child: const Text('Go!'),
          ),
        );
      }
    } else {
      return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: RawKeyboardListener(
              autofocus: true,
              focusNode: myFocusNode,
              onKey: (event) {
                if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                  direction = Direction.down;
                }
                if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                  direction = Direction.up;
                }
                if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                  direction = Direction.left;
                }
                if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                  direction = Direction.right;
                }
              },
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 1200,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 40),
                itemBuilder: (context, index) {
                  if (foodPosition.contains(index)) {
                    return Container(
                        color: Colors.greenAccent,
                        child: Text(
                          "${foodValues[foodPosition.indexWhere((element) => element == index)]}",
                          textAlign: TextAlign.center,
                        ));
                  }
                  if ((index % 40 == 0) ||
                      (index % 40 == 39) ||
                      (index < 40) ||
                      (1160 < index)) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                        shape: BoxShape.rectangle,
                      ),
                    );
                  }
                  if (snakePosition.contains(index)) {
                    if (compteurFood % 2 == 1) {
                      return Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.greenAccent,
                        ),
                      );
                    } else {
                      return Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      );
                    }
                  }
                  return Container(
                    color: Colors.black,
                  );
                },
              ),
            ),
          ));
    }
  }
}
