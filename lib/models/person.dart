import 'package:family_tree_app/data/constants.dart';

enum Gender { male, female, unknown }

class Person {
  final int id;
  final String name;
  final String surname;
  final Gender gender;
  final List<String>? marriageSurnames;
  final DateTime? birthDate;
  final String? image;
  final List<int>? partnerIDs;
  final int? motherID;
  final int? fatherID;
  final bool isDead;
  final DateTime? deathDate;
  const Person({
    required this.id,
    required this.name,
    required this.surname,
    required this.gender,
    this.marriageSurnames,
    this.birthDate,
    this.image,
    this.partnerIDs,
    this.motherID,
    this.fatherID,
    this.isDead = false,
    this.deathDate,
  });

  static const Person empty = Person(
    id: 0,
    name: '',
    surname: '',
    gender: Gender.unknown,
    birthDate: null,
    partnerIDs: null,
    motherID: null,
    fatherID: null,
  );

  String get currentSurname {
    if (marriageSurnames == null) {
      return surname;
    } else {
      return marriageSurnames!.last;
    }
  }

  String get fullName {
    return '$name $currentSurname';
  }

  String get birthDateString {
    List<String>? birthDateList = birthDate
        ?.toIso8601String()
        .replaceRange(10, null, '')
        .replaceAll('-', ' ')
        .split(' ');
    if (birthDateList == null) {
      return 'N/A';
    } else {
      return "${birthDateList[2]} ${mounths[birthDateList[1]]!} ${birthDateList[0]}";
    }
  }

  String get deathDateString {
    List<String>? deathDateList = deathDate
        ?.toIso8601String()
        .replaceRange(10, null, '')
        .replaceAll('-', ' ')
        .split(' ');
    if (deathDateList == null) {
      return '';
    } else {
      return "- ${deathDateList[2]} ${mounths[deathDateList[1]]!} ${deathDateList[0]}";
    }
  }
}
