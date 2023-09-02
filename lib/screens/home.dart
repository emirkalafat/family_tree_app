import 'package:family_tree_app/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

import 'package:family_tree_app/data/people.dart';
import 'package:family_tree_app/models/spouse.dart';
import 'package:family_tree_app/widgets/person_card.dart';
import 'package:family_tree_app/widgets/spouse_group_card.dart';

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

  Person mainPerson = People.getPersonByID(1)!;

  List<Map<String, int>>? edges;

  bool isEmpty = false;

  @override
  void initState() {
    edges = People.createEdges(mainPerson.id);
    (edges == null || edges!.isEmpty) ? isEmpty = true : isEmpty = false;
    print('#####\nFinal Edges: $edges');
    print('Edges length: ${edges?.length ?? 'null'}');
    for (var element in edges!) {
      var fromNodeId = element['from'];
      var toNodeId = element['to'];
      graph.addEdge(Node.Id(fromNodeId), Node.Id(toNodeId));
    }
    //graph can reduce repeated edges. which is nice :)
    print('Graph edges length: ${graph.edges.length}');
    super.initState();
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
                  var personNode =
                      People.all.firstWhere((element) => element.id == a);
                  if (personNode.spouse.type != SpouseType.single) {
                    if (personNode.spouse.type == SpouseType.wife) {
                      return SpouseGroupCard(
                          husband: People.getPersonByID(personNode.id),
                          wife:
                              People.getPersonByID(personNode.spouse.personID!),
                          first: 'husband');
                    } else {
                      return SpouseGroupCard(
                          wife: People.getPersonByID(personNode.id),
                          husband:
                              People.getPersonByID(personNode.spouse.personID!),
                          first: 'wife');
                    }
                  } else {
                    return PersonCard(
                      person: People.getPersonByID(personNode.id),
                      type: PersonCardType.single,
                    );
                  }
                },
              )),
    );
  }
}
