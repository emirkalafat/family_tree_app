enum PartnerType { single, wife, husband }

class Partner {
  final PartnerType type;
  final int? personID;
  const Partner({required this.type, this.personID})
      : //assert(type == SpouseType.single && personID == null),
        assert(type != PartnerType.husband || personID != null),
        assert(type != PartnerType.wife || personID != null);
}
