import 'package:collection/collection.dart';
import 'package:family_tree_app/models/partner_group.dart';
import 'package:family_tree_app/secrets/known_people.dart';
import 'package:family_tree_app/models/person.dart';
import 'package:graphview/GraphView.dart';

class People {
  static List<Person> allPeople = people;
  static List<PartnerGroup> allPartnerships = spouses;

  static Person? getPersonByID(int id) {
    for (Person element in allPeople) {
      if (element.id == id) {
        return element;
      }
    }
    return null;
  }

  static PartnerGroup? getPartnerGroupByID(int parentGroupID) {
    for (PartnerGroup element in allPartnerships) {
      if (element.id == parentGroupID) {
        return element;
      }
    }
    return null;
  }

  /// Returns the next ID that can be used for a new person or partnership.
  static get nextID {
    int nextID = 0;
    for (Person element in allPeople) {
      if (element.id > nextID) {
        nextID = element.id;
      }
    }
    for (PartnerGroup element in allPartnerships) {
      if (element.id > nextID) {
        nextID = element.id;
      }
    }
    return nextID + 1;
  }

  static List<int> getChildrenIDs(
      {required int husbandID, required int wifeID}) {
    List<int> childrenIDs = [];
    for (Person element in allPeople) {
      if (element.motherID == wifeID && element.fatherID == husbandID) {
        childrenIDs.add(element.id);
      }
    }
    return childrenIDs;
  }

  static void addEdges(List<Map<String, int>> edges, Graph graph) {
    print('#####\nFinal Edges: $edges');
    print('Edges length: ${edges.length}');

    for (var element in edges) {
      var fromNodeId = element['from'];
      var toNodeId = element['to'];
      graph.addEdge(Node.Id(fromNodeId), Node.Id(toNodeId));
    }
    //graph can reduce repeated edges. which is nice :)
    print('Graph edges length: ${graph.edges.length}');

    graph.notifyGraphObserver();
  }

  /*
  static createPartnerGroup(int personID) {
    Person? person = getPersonByID(personID);
    if (person == null) {
      return;
    }
    if (person.partnerIDs == null) {
      return;
    }
    for (int? partnerID in person.partnerIDs ?? []) {
      if (partnerID == null) {
        return;
      } else {
        if (person.gender == Gender.male) {
          spouses.add(
            PartnerGroup(
              id: nextID,
              husbandID: person.id,
              wifeID: partnerID,
              childrenIDs:
                  getChildrenIDs(husbandID: person.id, wifeID: partnerID),
            ),
          );
        }
        if (person.gender == Gender.female) {
          spouses.add(
            PartnerGroup(
              id: nextID,
              husbandID: partnerID,
              wifeID: person.id,
              childrenIDs:
                  getChildrenIDs(husbandID: partnerID, wifeID: person.id),
            ),
          );
        }
      }
    }
  }
  */

  /// Creates [PartnerGroup] to [Person] edges and [PartnerGroup] to its children [Person]'s edges.
  static List<Map<String, int>> createParentAndSiblingsEdges(
    int personID,
  ) {
    List<Map<String, int>> edges = [];
    Person? person = getPersonByID(personID);

    if (person == null) return edges;
    if (person.motherID == null || person.fatherID == null) return edges;
    PartnerGroup? partnerGroup = getPartnerGroupNode(
      requestedMotherID: person.motherID!,
      requestedFatherID: person.fatherID!,
    );
    if (partnerGroup == null) return edges;

    /// Creates [PartnerGroup] to child edges
    edges.addAll(getParentsChildEdges(partnerGroup.id));

    return edges;
  }

  static List<Map<String, int>> getParentsChildEdges(int parentGroupID) {
    List<Map<String, int>> edges = [];
    PartnerGroup? parentGroup = getPartnerGroupByID(parentGroupID);
    if (parentGroup == null) return edges;
    if (parentGroup.childrenIDs == null) return edges;

    for (int childID in parentGroup.childrenIDs!) {
      edges.add({
        'from': parentGroupID,
        'to': People.allPartnerships
                .firstWhereOrNull((element) =>
                    element.husbandID == childID || element.wifeID == childID)
                ?.id ??
            childID
      });
    }
    return edges;
  }

  static PartnerGroup? getPartnerGroupNode(
      {required int requestedFatherID, required int requestedMotherID}) {
    for (PartnerGroup element in allPartnerships) {
      if (element.husbandID == requestedFatherID &&
          element.wifeID == requestedMotherID) {
        return element;
      }
    }
    return null;
  }

  static void createChildEdges() {}
}
