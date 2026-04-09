class ComponentDetail {
  final String name;
  final String introduction;
  final String code;
  final List<String> parameters;
  final List<String> notes;

  const ComponentDetail({
    required this.name,
    required this.introduction,
    required this.code,
    this.parameters = const [],
    this.notes = const [],
  });
}
