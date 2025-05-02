class PredictionsModel {
  List<Predictions>? predictions;
  String? status;

  PredictionsModel({
    this.predictions,
    this.status,
  });

  PredictionsModel.fromJson(Map<String, dynamic> json) {
    predictions =
        (json['predictions'] as List?)?.map((dynamic e) => Predictions.fromJson(e as Map<String, dynamic>)).toList();
    status = json['status'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['predictions'] = predictions?.map((e) => e.toJson()).toList();
    json['status'] = status;
    return json;
  }
}

class Predictions {
  String? description;
  List<MatchedSubstrings>? matchedSubstrings;
  String? placeId;
  String? reference;
  StructuredFormatting? structuredFormatting;
  List<Terms>? terms;
  List<String>? types;

  Predictions({
    this.description,
    this.matchedSubstrings,
    this.placeId,
    this.reference,
    this.structuredFormatting,
    this.terms,
    this.types,
  });

  Predictions.fromJson(Map<String, dynamic> json) {
    description = json['description'] as String?;
    matchedSubstrings = (json['matched_substrings'] as List?)
        ?.map((dynamic e) => MatchedSubstrings.fromJson(e as Map<String, dynamic>))
        .toList();
    placeId = json['place_id'] as String?;
    reference = json['reference'] as String?;
    structuredFormatting = (json['structured_formatting'] as Map<String, dynamic>?) != null
        ? StructuredFormatting.fromJson(json['structured_formatting'] as Map<String, dynamic>)
        : null;
    terms = (json['terms'] as List?)?.map((dynamic e) => Terms.fromJson(e as Map<String, dynamic>)).toList();
    types = (json['types'] as List?)?.map((dynamic e) => e as String).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['description'] = description;
    json['matched_substrings'] = matchedSubstrings?.map((e) => e.toJson()).toList();
    json['place_id'] = placeId;
    json['reference'] = reference;
    json['structured_formatting'] = structuredFormatting?.toJson();
    json['terms'] = terms?.map((e) => e.toJson()).toList();
    json['types'] = types;
    return json;
  }
}

class MatchedSubstrings {
  int? length;
  int? offset;

  MatchedSubstrings({
    this.length,
    this.offset,
  });

  MatchedSubstrings.fromJson(Map<String, dynamic> json) {
    length = json['length'] as int?;
    offset = json['offset'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['length'] = length;
    json['offset'] = offset;
    return json;
  }
}

class StructuredFormatting {
  String? mainText;
  List<MainTextMatchedSubstrings>? mainTextMatchedSubstrings;
  String? secondaryText;

  StructuredFormatting({
    this.mainText,
    this.mainTextMatchedSubstrings,
    this.secondaryText,
  });

  StructuredFormatting.fromJson(Map<String, dynamic> json) {
    mainText = json['main_text'] as String?;
    mainTextMatchedSubstrings = (json['main_text_matched_substrings'] as List?)
        ?.map((dynamic e) => MainTextMatchedSubstrings.fromJson(e as Map<String, dynamic>))
        .toList();
    secondaryText = json['secondary_text'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['main_text'] = mainText;
    json['main_text_matched_substrings'] = mainTextMatchedSubstrings?.map((e) => e.toJson()).toList();
    json['secondary_text'] = secondaryText;
    return json;
  }
}

class MainTextMatchedSubstrings {
  int? length;
  int? offset;

  MainTextMatchedSubstrings({
    this.length,
    this.offset,
  });

  MainTextMatchedSubstrings.fromJson(Map<String, dynamic> json) {
    length = json['length'] as int?;
    offset = json['offset'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['length'] = length;
    json['offset'] = offset;
    return json;
  }
}

class Terms {
  int? offset;
  String? value;

  Terms({
    this.offset,
    this.value,
  });

  Terms.fromJson(Map<String, dynamic> json) {
    offset = json['offset'] as int?;
    value = json['value'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['offset'] = offset;
    json['value'] = value;
    return json;
  }
}
