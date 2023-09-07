class FetchById {
  final String id;
  FetchById({required this.id});
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    return map;
  }

  factory FetchById.fromJson(dynamic json) {
    final data = json.data()! as Map<String, dynamic>;
    return FetchById(id: data['id']);
  }
}




/*







 */