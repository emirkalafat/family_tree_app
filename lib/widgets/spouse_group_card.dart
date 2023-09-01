import 'package:family_tree_app/models/person.dart';
import 'package:family_tree_app/widgets/person_card.dart';
import 'package:flutter/material.dart';

class SpouseGroupCard extends StatelessWidget {
  final Person? husband;
  final Person? wife;
  final String? first;
  const SpouseGroupCard({super.key, this.husband, this.wife, this.first})
      : assert(husband != null || wife != null);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: first == 'husband' || first == null
          ? [
              PersonCard(person: husband, type: PersonCardType.lHusband),
              PersonCard(person: wife, type: PersonCardType.rWife),
            ]
          : [
              PersonCard(person: wife, type: PersonCardType.lWife),
              PersonCard(person: husband, type: PersonCardType.rHusband),
            ],
    );
  }
}
