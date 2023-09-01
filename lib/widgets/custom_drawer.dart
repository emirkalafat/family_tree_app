import 'package:family_tree_app/models/person.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.mainPerson,
  });

  final Person mainPerson;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
            child: Column(
          children: [
            const Text('Aile Ağacı'),
            Text('${mainPerson.name} ${mainPerson.currentSurname} Ailesi'),
          ],
        )),
        ListTile(
          title: const Text('Aile Ağacı'),
          onTap: () {},
        ),
        ListTile(
          title: const Text('Aile Üyeleri'),
          onTap: () {},
        ),
        ListTile(
          title: const Text('Aile Bilgileri'),
          onTap: () {},
        ),
      ],
    ));
  }
}
