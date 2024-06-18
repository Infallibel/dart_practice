import 'dart:io';
import 'dart:math';

void main() {
  stdout.write(
      'Let\'s play the game of Hangman. I have a word in mind and you have to guess it. Type one letter that you think this word contains:\n');
  String word = randomWord();
  game(word);
}

void game(String word) {
  List<String> wordToGuess = word.split('');

  List<String> playerGuesses = List.generate(wordToGuess.length, (_) => '_');
  List<String> wrongGuesses = [];
  int wrongCount = 6;
  bool result = win(wordToGuess, playerGuesses);

  print(playerGuesses.join(' '));
  while (true) {
    stdout.write('Guess the letter: ');
    String guess = stdin.readLineSync()!.trim().toUpperCase();

    if (guess == word) {
      print('You guessed the word!');
      break;
    }

    if (wordToGuess.contains(guess) && !playerGuesses.contains(guess)) {
      for (var i = 0; i < wordToGuess.length; i++) {
        if (wordToGuess[i] == guess) {
          playerGuesses[i] = wordToGuess[i];
        }
      }
      print('You guessed correctly!');
    } else if (playerGuesses.contains(guess)) {
      print('This letter has already been guessed. Try again');
    } else if (!wordToGuess.contains(guess)) {
      wrongCount--;
      wrongGuesses.add(guess);
      if (wrongCount == 0) {
        drawHangman(wrongCount, wrongGuesses);
        print('You lost! The word was $word');

        break;
      } else {
        print(
            'You guessed incorrectly! you have $wrongCount attempt${wrongCount == 1 ? '' : 's'} left');
      }
    }

    if (win(wordToGuess, playerGuesses)) {
      print(playerGuesses.join(' '));
      print('Congratulations, you guessed the word!');

      break;
    }
    print(result);
    drawHangman(wrongCount, wrongGuesses);
    print(playerGuesses.join(' '));
  }
}

bool win(List<String> wordToGuess, List<String> playerGuesses) {
  for (var i = 0; i < wordToGuess.length; i++) {
    if (playerGuesses[i] != wordToGuess[i]) {
      return false;
    }
  }
  return true;
}

String randomWord() {
  Random random = Random();
  File sowpods = File('lib/sowpods.txt');
  List<String> list = sowpods.readAsLinesSync();

  String randomWordFromList = list[random.nextInt(list.length)];

  return randomWordFromList;
}

void drawHangman(int wrongCount, List<String> wrongGuesses) {
  print(
      '______\n|    |\n|    ${wrongCount <= 5 ? '0' : ' '}${wrongGuesses.isNotEmpty ? '   WRONG GUESSES: ${wrongGuesses.join(',')}' : ''}\n|   ${wrongCount <= 3 ? '/' : ' '}${wrongCount <= 4 ? '|' : ' '}${wrongCount <= 2 ? '\\' : ' '}\n|   ${wrongCount <= 1 ? '/' : ' '} ${wrongCount == 0 ? '\\' : ' '}\n|\n|_____');
}
