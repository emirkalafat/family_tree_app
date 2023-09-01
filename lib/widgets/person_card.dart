import 'package:flutter/material.dart';

import '../models/person.dart';

enum PersonCardType { lHusband, lWife, rHusband, rWife, single }

class PersonCard extends StatefulWidget {
  final Person? person;
  final PersonCardType type;

  const PersonCard({
    super.key,
    this.person = Person.empty,
    required this.type,
  });

  @override
  State<PersonCard> createState() => _PersonCardState();
}

class _PersonCardState extends State<PersonCard> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isOpen &&
            (widget.type == PersonCardType.lHusband ||
                widget.type == PersonCardType.lWife))
          const SettingsCard(),
        GestureDetector(
          onTap: () {
            setState(() {
              isOpen = !isOpen;
            });
          },
          child: Card(
              color: widget.type == PersonCardType.lHusband ||
                      widget.type == PersonCardType.rHusband
                  ? widget.person!.isDead
                      ? Colors.blueGrey[600]
                      : Colors.blue[200]
                  : widget.type == PersonCardType.lWife ||
                          widget.type == PersonCardType.rWife
                      ? widget.person!.isDead
                          ? Colors.pink[900]
                          : Colors.pink[200]
                      : Colors.white,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black, width: 1),
                borderRadius: widget.type == PersonCardType.lHusband ||
                        widget.type == PersonCardType.lWife
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      )
                    : widget.type == PersonCardType.rWife ||
                            widget.type == PersonCardType.rHusband
                        ? const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          )
                        : BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 200,
                    width: 150,
                    child: widget.person != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(
                                    widget.person!.image ??
                                        'assets/images/unknown.png'),
                              ),
                              //Align(
                              //  alignment: Alignment.topCenter,
                              //  type == PersonCardType.lHusband ||
                              //          type == PersonCardType.lWife
                              //      ? Alignment.topLeft
                              //      : type == PersonCardType.rWife ||
                              //              type == PersonCardType.rHusband
                              //          ? Alignment.topRight
                              //          : Alignment.topCenter,
                              //  child:
                              //),
                              Text(widget.person!.name),
                              Text(widget.person!.currentSurname),
                              Text(
                                  widget.person!.birthDate?.toIso8601String() ??
                                      'N/A'),
                            ],
                          )
                        : const Text('N/A')),
              )),
        ),
        if (isOpen &&
            (widget.type == PersonCardType.rHusband ||
                widget.type == PersonCardType.rWife ||
                widget.type == PersonCardType.single))
          const SettingsCard(isRightCard: false)
      ],
    );
  }
}

class SettingsCard extends StatelessWidget {
  final bool isRightCard;
  const SettingsCard({
    Key? key,
    this.isRightCard = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: isRightCard ? const Radius.circular(8) : Radius.zero,
          bottomLeft: isRightCard ? const Radius.circular(8) : Radius.zero,
          topRight: isRightCard ? Radius.zero : const Radius.circular(8),
          bottomRight: isRightCard ? Radius.zero : const Radius.circular(8),
        ),
        color: Colors.red,
      ),
      child: const Column(
        children: [
          Icon(Icons.edit),
          SizedBox(height: 10),
          Icon(Icons.delete),
        ],
      ),
    );
  }
}
