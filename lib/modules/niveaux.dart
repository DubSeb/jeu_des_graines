class Niveau {
  String nomNiveau = "";
  List<int> snakePositions = [];
  List<int> foodPositions = [];
  List<int> foodValues = [];
  int scoreMax = 0;

  Niveau(
    String nom,
    List<int> snake,
    int score,
    List<int> food,
    List<int> fValues,
  ) {
    nomNiveau = nom;
    snakePositions = List.from(snake);
    foodPositions = List.from(food);
    foodValues = List.from(fValues);
    scoreMax = score;
  }
}

class Niveaux {
  List<Niveau> liste = [];
  int nivMax = 3;

  Niveaux() {
    // Niveau 1
    liste.add(Niveau(
        "Level 1",
        [
          40,
          41,
          42,
          43,
          44,
          45,
          46,
          47,
          48,
          49,
          50,
          51,
          52,
          53,
          54,
          55,
          56,
          57,
          58,
          59
        ],
        1,
        [734],
        [1]));

    // Niveau 2
    liste.add(Niveau(
        "Level 2",
        [
          40,
          41,
          42,
          43,
          44,
          45,
          46,
          47,
          48,
          49,
          50,
          51,
          52,
          53,
          54,
          55,
          56,
          57,
          58,
          59,
          60,
          61,
          62,
          63,
          64,
          65,
          66,
          67,
          68,
          69,
          70
        ],
        3,
        [734, 234, 1021],
        [1, 2, 3]));

    // Niveau 3
    liste.add(Niveau(
        "Level 3",
        [
          40,
          41,
          42,
          43,
          44,
          45,
          46,
          47,
          48,
          49,
          50,
          51,
          52,
          53,
          54,
          55,
          56,
          57,
          58,
          59,
          60,
          61,
          62,
          63,
          64,
          65,
          66,
          67,
          68,
          69,
          70,
          71,
          72,
          73,
          74,
          75,
          76,
          77,
          78
        ],
        5,
        [300, 457, 345, 943, 765],
        [1, 2, 3, 4, 5]));
  }
}
