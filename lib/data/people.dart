import 'package:family_tree_app/constants/known_people.dart';
import 'package:family_tree_app/models/person.dart';

class People {
  static List<Person> all = people;

  static Person? getPersonByID(int id) {
    for (Person element in all) {
      if (element.id == id) {
        return element;
      }
    }
    return null;
  }

  static List<Map<String, int>> createChildrenEdges(
      int id, List<Map<String, int>> list) {
    var mainPerson = getPersonByID(id);
    if (mainPerson?.childrenIDs != null) {
      for (int childID in mainPerson!.childrenIDs!) {
        list.add({'from': mainPerson.id, 'to': childID});
        print('list $list');
        createChildrenEdges(childID, list);
      }
    }
    return list;
  }

  static List<Map<String, int>> createParentEdges(
    int id,
    List<Map<String, int>> list,
  ) {
    var mainPerson = getPersonByID(id);
    if (mainPerson == null) return [];
    if (mainPerson.parentIDs != null) {
      list.add({'from': mainPerson.parentIDs!.first, 'to': mainPerson.id});
      print('list $list');
      createParentEdges(mainPerson.parentIDs!.first, list);
    }
    list.addAll(createChildrenEdges(id, []));
    return list;
  }

  static List<Map<String, int>> createEdges(int id) {
    List<Map<String, int>> edges = [];
    //edges.addAll(createChildrenEdges(id, []));
    edges.addAll(createParentEdges(id, []));
    edges = edges.toSet().toList();
    return edges;
  }
}
