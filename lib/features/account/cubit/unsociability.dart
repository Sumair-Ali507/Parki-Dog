class Unsociability {
  List<String>? breeds;
  List<String>? genders;
  int? minWeight;

  Unsociability({this.breeds, this.genders, this.minWeight});

  Unsociability.fromJson(Map<String, dynamic> json) {
    breeds = json['breeds'].cast<String>();
    genders = json['genders'].cast<String>();
    minWeight = json['minWeight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['breeds'] = breeds;
    data['genders'] = genders;
    data['minWeight'] = minWeight;
    return data;
  }
}
