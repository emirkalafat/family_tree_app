class PartnerGroup {
  /// [PartnerGroup.id] and [Person.id] are in same void. There for we can't use same id for both.
  final int id;

  final int husbandID;

  final int wifeID;

  final List<int>? childrenIDs;
  const PartnerGroup({
    required this.id,
    required this.husbandID,
    required this.wifeID,
    this.childrenIDs,
  });
}
