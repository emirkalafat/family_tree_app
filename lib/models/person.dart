import 'package:family_tree_app/models/spouse.dart';

enum Gender { male, female }

class Person {
  final int id;
  final String name;
  final String surname;
  final Gender? gender;
  final List<String>? marriageSurnames;
  final DateTime? birthDate;
  final String? image;
  final Spouse spouse;
  final List<int>? childrenIDs;
  final List<int>? parentIDs;
  final bool isDead;
  const Person({
    required this.id,
    required this.name,
    required this.surname,
    this.gender,
    required this.spouse,
    this.marriageSurnames,
    this.image,
    this.birthDate,
    this.childrenIDs,
    this.parentIDs,
    this.isDead = false,
  });

  static const Person empty = Person(
    id: 0,
    name: '',
    surname: '',
    birthDate: null,
    spouse: Spouse(type: SpouseType.single),
  );

  String get currentSurname {
    if (marriageSurnames == null) {
      return surname;
    } else {
      return marriageSurnames!.last;
    }
  }
}
