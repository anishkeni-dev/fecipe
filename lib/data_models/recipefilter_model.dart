class RecipeFilter {
  final String filters;
  RecipeFilter({required this.filters});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['filters'] = filters;
    return map;
  }

  factory RecipeFilter.fromJson(dynamic json) {
    final data = json.data()! as Map<String, dynamic>;
    return RecipeFilter(filters: data['filters']);
  }
}
