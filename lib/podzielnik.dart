import 'dart:io';

class Person {
  String name;
  double paid;

  Person(this.name, this.paid);
}
void main() {
  List<Person> group = [];
  double totalPaid = 0;
  int numberOfPeople = 0;

  print('Podaj liczbę osób w grupie:');
  numberOfPeople = int.parse(stdin.readLineSync()!);

  print(
      'Podaj imię i kwotę wpłaconą (np. Anna 150), wpisz "suma", aby zakończyć:');
  while (true) {
    String input = stdin.readLineSync()!;
    if (input.toLowerCase() == 'suma') {
      break;
    }

    List<String> parts = input.split(' ');
    if (parts.length == 2) {
      String name = parts[0];
      double paid = double.parse(parts[1]);

      bool found = false;
      for (var person in group) {
        if (person.name == name) {
          person.paid += paid;
          found = true;
          break;
        }
      }

      if (!found) {
        group.add(Person(name, paid));
      }

      totalPaid += paid;
    } else {
      print('Niepoprawny format, spróbuj ponownie.');
    }
  }

  while (group.length < numberOfPeople) {
    group.add(Person('Osoba${group.length + 1}', 0));
  }

  double averagePaid = totalPaid / numberOfPeople;

  List<Map<String, dynamic>> transactions = [];

  List<Person> debtors = [];
  List<Person> creditors = [];

  for (var person in group) {
    double balance = person.paid - averagePaid;
    if (balance < 0) {
      debtors.add(Person(person.name, -balance));
    } else if (balance > 0) {
      creditors.add(Person(person.name, balance));
    }
  }

  while (debtors.isNotEmpty && creditors.isNotEmpty) {
    Person debtor = debtors.first;
    Person creditor = creditors.first;

    double amount = debtor.paid <= creditor.paid ? debtor.paid : creditor.paid;

    transactions.add({
      'from': debtor.name,
      'to': creditor.name,
      'amount': amount,
    });

    debtor.paid -= amount;
    creditor.paid -= amount;

    if (debtor.paid == 0) debtors.removeAt(0);
    if (creditor.paid == 0) creditors.removeAt(0);
  }

  print('Każda osoba powinna zapłacić: \$${averagePaid.toStringAsFixed(2)}');
  print('Transakcje wyrównujące:');
  for (var transaction in transactions) {
    print(
        '${transaction['from']} powinien zapłacić ${transaction['to']} \$${transaction['amount'].toStringAsFixed(2)}');
  }
}
