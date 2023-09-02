import 'package:collection/collection.dart' show IterableExtension;
import 'package:family_tree_app/widgets/person_card.dart';
import 'package:family_tree_app/widgets/spouse_group_card.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

import 'package:family_tree_app/data/people.dart';
import 'package:family_tree_app/widgets/custom_drawer.dart';

import '../models/person.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Graph graph = Graph()..isTree = true;
  final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration()
    ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM
    ..siblingSeparation = (50)
    ..levelSeparation = (75)
    ..subtreeSeparation = (50);

  Person mainPerson = People.getPersonByID(4)!;

  List<Map<String, int>>? edges;

  bool isEmpty = false;

  @override
  void initState() {
    edges = People.createParentAndSiblingsEdges(mainPerson.id);
    (edges == null || edges!.isEmpty) ? isEmpty = true : isEmpty = false;

    People.addEdges(edges!, graph);

    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${mainPerson.name} ${mainPerson.currentSurname} Ailesi'),
        centerTitle: true,
      ),
      drawer: CustomDrawer(mainPerson: mainPerson),
      body: isEmpty
          ? const Center(
              child: Text('Aile Ağacı Boş'),
            )
          : InteractiveViewer(
              boundaryMargin:
                  const EdgeInsets.symmetric(horizontal: 1000, vertical: 400),
              panAxis: PanAxis.free,
              minScale: 0.5,
              maxScale: 1.5,
              constrained: false,
              child: GraphView(
                graph: graph,
                algorithm:
                    BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
                builder: (node) {
                  var a = node.key!.value as int?;
                  var partnerNode = People.allPartnerships.firstWhereOrNull(
                    (element) => element.id == a,
                  );
                  var personNode = People.allPeople.firstWhereOrNull(
                    (element) => element.id == a,
                  );
                  if (partnerNode != null) {
                    return SpouseGroupCard(
                      husband: People.getPersonByID(partnerNode.husbandID),
                      wife: People.getPersonByID(partnerNode.wifeID),
                      graph: graph,
                      callback: () {
                        setState(() {});
                      },
                    );
                  }
                  if (personNode != null) {
                    return PersonCard(
                      person: personNode,
                      type: PersonCardType.single,
                    );
                  }
                  return const SizedBox();
                },
              )),
    );
  }
}
