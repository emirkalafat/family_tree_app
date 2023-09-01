import 'package:family_tree_app/data/people.dart';
import 'package:family_tree_app/models/spouse.dart';
import 'package:family_tree_app/widgets/person_card.dart';
import 'package:family_tree_app/widgets/spouse_group_card.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

import 'models/person.dart';

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
    ..subtreeSeparation = (300);

  Person mainPerson = People.getPersonByID(1)!;

  List<Map<String, int>>? edges;
  // = [
  //  {'from': 1, 'to': 3},
  //  {'from': 1, 'to': 4},
  //  {'from': 1, 'to': 5},
  //  //
  //  {'from': 10, 'to': 1},
  //  {'from': 10, 'to': 6},
  //  {'from': 10, 'to': 7},
  //  {'from': 10, 'to': 8},
  //  {'from': 10, 'to': 9},
  //];

  @override
  void initState() {
    edges = People.createEdges(mainPerson.id);
    print('edges' + edges.toString());
    for (var element in edges!) {
      var fromNodeId = element['from'];
      var toNodeId = element['to'];
      graph.addEdge(Node.Id(fromNodeId), Node.Id(toNodeId));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${mainPerson.name} ${mainPerson.surname} Ailesi'),
        centerTitle: true,
      ),
      body: InteractiveViewer(
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
                      wife: People.getPersonByID(personNode.spouse.personID!),
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
