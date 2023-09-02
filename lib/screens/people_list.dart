import 'package:flutter/material.dart';

import 'package:family_tree_app/data/people.dart';
import 'package:family_tree_app/widgets/person_card.dart';

class AllFamilyList extends StatefulWidget {
  const AllFamilyList({super.key});

  @override
  State<AllFamilyList> createState() => _AllFamilyListState();
}

class _AllFamilyListState extends State<AllFamilyList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Aile Listesi'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            direction: Axis.horizontal,
            children: List.generate(
                People.allPeople.length,
                (index) => PersonCard(
                      type: PersonCardType.single,
                      person: People.allPeople[index],
                    )),
          ),
        ));
  }
}
