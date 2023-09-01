enum SpouseType { single, wife, husband }

class Spouse {
  final SpouseType type;
  final int? personID;
  const Spouse({required this.type, this.personID})
      : //assert(type == SpouseType.single && personID == null),
        assert(type != SpouseType.husband || personID != null),
        assert(type != SpouseType.wife || personID != null);
}
