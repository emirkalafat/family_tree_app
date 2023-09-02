import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

import 'package:family_tree_app/data/people.dart';
import 'package:family_tree_app/models/person.dart';
import 'package:family_tree_app/widgets/person_card.dart';

enum SpouseType { husband, wife }

class SpouseGroupCard extends StatefulWidget {
  final Person? husband;
  final Person? wife;
  final SpouseType? primaryTree;
  final Graph graph;
  final Function callback;
  const SpouseGroupCard({
    Key? key,
    required this.callback,
    this.husband,
    this.wife,
    this.primaryTree,
    required this.graph,
  })  : assert(husband != null || wife != null),
        super(key: key);

  @override
  State<SpouseGroupCard> createState() => _SpouseGroupCardState();
}

class _SpouseGroupCardState extends State<SpouseGroupCard> {
  late bool isHusbandTree =
      widget.primaryTree == SpouseType.husband || widget.primaryTree == null;

  void setParentTree(isHusbandTree) {
    if (widget.husband != null || widget.wife != null) {
      if (isHusbandTree) {
        People.addEdges(
          People.createParentAndSiblingsEdges(widget.husband!.id),
          widget.graph,
        );
      } else {
        People.addEdges(
          People.createParentAndSiblingsEdges(widget.wife!.id),
          widget.graph,
        );
      }
    }
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    setParentTree(isHusbandTree);
    widget.callback();
  }

  @override
  void initState() {
    super.initState();
    setParentTree(isHusbandTree);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: (isHusbandTree)
                ? [
                    PersonCard(
                        person: widget.husband,
                        type: PersonCardType.lHusband,
                        isActiveTree: true),
                    PersonCard(
                        person: widget.wife,
                        type: PersonCardType.rWife,
                        isActiveTree: false)
                  ]
                : [
                    PersonCard(
                        person: widget.wife,
                        type: PersonCardType.lWife,
                        isActiveTree: true),
                    PersonCard(
                        person: widget.husband,
                        type: PersonCardType.rHusband,
                        isActiveTree: false),
                  ],
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: IconButton.filledTonal(
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  setState(() {
                    isHusbandTree = !isHusbandTree;
                  });
                },
                icon: const Icon(Icons.family_restroom)),
          ),
        )
      ],
    );
  }
}
