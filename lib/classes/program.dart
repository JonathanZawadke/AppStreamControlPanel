class Program {
  final String name;
  final String icon;
  final String path;
  final String parameter;
  final String group;
  final String id;

  Program(
      {required this.name,
      required this.icon,
      required this.path,
      required this.parameter,
      required this.group,
      required this.id});

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      name: json['name'],
      icon: json['Icon'],
      path: json['path'],
      parameter: json['parameter'],
      group: json['group'],
      id: json['ID'],
    );
  }
}
