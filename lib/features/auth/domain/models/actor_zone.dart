enum ActorZone {
  platform('PLATFORM'),
  customerOrganization('CUSTOMER_ORGANIZATION'),
  serviceWorkforce('SERVICE_WORKFORCE');

  const ActorZone(this.code);

  final String code;

  static ActorZone? parse(Object? raw) {
    if (raw is! String) return null;
    for (final zone in ActorZone.values) {
      if (zone.code == raw) return zone;
    }
    return null;
  }
}
