import 'dart:io';

void main() {
  List<List<String>> board =
      List.generate(3, (_) => List.generate(3, (_) => ' '));

  int currentUser = 1;
  Set<String> movesTaken = {};

  while (true) {
    printBoard(board);
    String XvO = currentUser == 1 ? 'X' : 'O';
    stdout.write(
        "Player $currentUser ($XvO), please choose a coordinate to place $XvO (e.g., 11, 23):");
    String choice = stdin.readLineSync()!;

    if (isValidMove(choice, movesTaken)) {
      drawBoard(board, currentUser, choice);

      movesTaken.add(choice);

      if (theGame(board, movesTaken, currentUser)) {
        printBoard(board);

        break;
      }

      currentUser = currentUser == 1 ? 2 : 1;
    } else {
      print(
          'That coordination was already taken or the input is wrong, please try again');
    }
  }
}

bool isValidMove(String choice, Set<String> movesTaken) {
  Set<String> availableMoves = {
    '11',
    '12',
    '13',
    '21',
    '22',
    '23',
    '31',
    '32',
    '33'
  };
  return availableMoves.contains(choice) && !movesTaken.contains(choice);
}

void drawBoard(List<List<String>> board, int currentUser, String choice) {
  String move = currentUser == 1 ? 'X' : 'O';

  int row = int.parse(choice[0]) - 1;
  int column = int.parse(choice[1]) - 1;
  board[row][column] = move;
}

void printBoard(List<List<String>> board) {
  for (var row in board) {
    print(row.join(' | '));
  }
  print('');
}

bool rowCheck(List<List<String>> board) {
  for (List<String> row in board) {
    if (row.toSet().length == 1 && !row.contains(' ')) {
      return true;
    }
  }
  return false;
}

bool theGame(
    List<List<String>> board, Set<String> movesTaken, int currentUser) {
  if (rowCheck(board)) {
    print('Player $currentUser won! 3 in a row!');
    return true;
  } else if (rowCheck(transpose(board))) {
    print('Player $currentUser won! 3 in a column!');
    return true;
  } else if (rowCheck(diagonalCheck(board))) {
    print('Player $currentUser won! 3 in a diagonal!');
    return true;
  } else if (movesTaken.length == 9) {
    print('It\'s a draw!');
    return true;
  }
  return false;
}

List<List<String>> transpose(List<List<String>> board) {
  return [
    for (var i = 0; i < board.length; i++) [for (List<String> r in board) r[i]]
  ];
}

List<List<String>> diagonalCheck(List<List<String>> board) {
  return [
    [for (var i = 0; i < board.length; i++) board[i][i]],
    [for (var i = 0; i < board.length; i++) board[i].reversed.toList()[i]]
  ];
}
