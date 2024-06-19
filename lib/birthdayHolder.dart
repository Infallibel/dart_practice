import 'dart:convert';
import 'dart:io';
import 'dart:core';

/// needs a file birthdays.json in the lib folder

void main() {
  birthdays("lib/birthdays.json");
}

void birthdays(String txt) {
  var file = File(txt);
  if (!file.existsSync()) {
    print('Birthdays file not found!');
    return;
  }

  Map<String, dynamic> data = json.decode(file.readAsStringSync());

  print("\nHello there! We know the birthdays of the following people: \n");
  data.forEach((key, value) {
    print(key);
  });

  stdout.write("\nWho's birthday do you want to know? ");
  String choice = stdin.readLineSync()!;

  if (data.containsKey(choice)) {
    print("\n${choice}'s birthday is ${data[choice]}\n");
  } else {
    print("\nSorry, we don't have the birthday information for ${choice}\n");
  }

  stdout.write(
      "\nWould you like to add, update, or remove a person's birthday? (add/update/remove): ");
  String answer = stdin.readLineSync()!.toLowerCase();

  if (answer == "add") {
    addBirthday(data, file);
  } else if (answer == "update") {
    updateBirthday(data, file);
  } else if (answer == "remove") {
    removeBirthday(data, file);
  } else {
    print("\nInvalid option. Bye bye!\n");
  }
}

void addBirthday(Map<String, dynamic> data, File file) {
  stdout.write("Give us a name: ");
  String name = stdin.readLineSync()!;
  stdout.write("Give us their birthday (dd.mm.yyyy): ");
  String birthday = stdin.readLineSync()!;

  data[name] = birthday;
  file.writeAsStringSync(json.encode(data));

  print("\nThank you! We have more people now!\n");
  data.forEach((key, value) {
    print("$key: $value");
  });
}

void updateBirthday(Map<String, dynamic> data, File file) {
  stdout.write("Whose birthday would you like to update? ");
  String name = stdin.readLineSync()!;

  if (data.containsKey(name)) {
    stdout.write("Give us the new birthday (dd.mm.yyyy): ");
    String birthday = stdin.readLineSync()!;
    data[name] = birthday;
    file.writeAsStringSync(json.encode(data));

    print("\nThank you! The birthday has been updated!\n");
    data.forEach((key, value) {
      print("$key: $value");
    });
  } else {
    print("\nSorry, we don't have the birthday information for $name\n");
  }
}

void removeBirthday(Map<String, dynamic> data, File file) {
  stdout.write("Whose birthday would you like to remove? ");
  String name = stdin.readLineSync()!;

  if (data.containsKey(name)) {
    data.remove(name);
    file.writeAsStringSync(json.encode(data));

    print("\nThank you! The birthday has been removed!\n");
    data.forEach((key, value) {
      print("$key: $value");
    });
  } else {
    print("\nSorry, we don't have the birthday information for $name\n");
  }
}
