class SingleParkModel {
  List<dynamic>? htmlAttributions;
  Result? result;
  String? status;

  SingleParkModel({
    this.htmlAttributions,
    this.result,
    this.status,
  });

  SingleParkModel.fromJson(Map<String, dynamic> json) {
    htmlAttributions = json['html_attributions'] as List?;
    result = (json['result'] as Map<String, dynamic>?) != null
        ? Result.fromJson(json['result'] as Map<String, dynamic>)
        : null;
    status = json['status'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['html_attributions'] = htmlAttributions;
    json['result'] = result?.toJson();
    json['status'] = status;
    return json;
  }
}

class Result {
  Geometry? geometry;
  String? name;
  List<Photos>? photos;
  String? placeId;
  num? rating;
  List<Reviews>? reviews;
  String? url;
  int? userRatingsTotal;

  Result({
    this.geometry,
    this.name,
    this.photos,
    this.placeId,
    this.rating,
    this.reviews,
    this.url,
    this.userRatingsTotal,
  });

  Result.fromJson(Map<String, dynamic> json) {
    geometry = (json['geometry'] as Map<String, dynamic>?) != null
        ? Geometry.fromJson(json['geometry'] as Map<String, dynamic>)
        : null;
    name = json['name'] as String?;
    photos = (json['photos'] as List?)?.map((dynamic e) => Photos.fromJson(e as Map<String, dynamic>)).toList();
    placeId = json['place_id'] as String?;
    rating = json['rating'] as num?;
    reviews = (json['reviews'] as List?)?.map((dynamic e) => Reviews.fromJson(e as Map<String, dynamic>)).toList();
    url = json['url'] as String?;
    userRatingsTotal = json['user_ratings_total'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['geometry'] = geometry?.toJson();
    json['name'] = name;
    json['photos'] = photos?.map((e) => e.toJson()).toList();
    json['place_id'] = placeId;
    json['rating'] = rating;
    json['reviews'] = reviews?.map((e) => e.toJson()).toList();
    json['url'] = url;
    json['user_ratings_total'] = userRatingsTotal;
    return json;
  }
}

class Geometry {
  Location? location;
  Viewport? viewport;

  Geometry({
    this.location,
    this.viewport,
  });

  Geometry.fromJson(Map<String, dynamic> json) {
    location = (json['location'] as Map<String, dynamic>?) != null
        ? Location.fromJson(json['location'] as Map<String, dynamic>)
        : null;
    viewport = (json['viewport'] as Map<String, dynamic>?) != null
        ? Viewport.fromJson(json['viewport'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['location'] = location?.toJson();
    json['viewport'] = viewport?.toJson();
    return json;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({
    this.lat,
    this.lng,
  });

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'] as double?;
    lng = json['lng'] as double?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['lat'] = lat;
    json['lng'] = lng;
    return json;
  }
}

class Viewport {
  Northeast? northeast;
  Southwest? southwest;

  Viewport({
    this.northeast,
    this.southwest,
  });

  Viewport.fromJson(Map<String, dynamic> json) {
    northeast = (json['northeast'] as Map<String, dynamic>?) != null
        ? Northeast.fromJson(json['northeast'] as Map<String, dynamic>)
        : null;
    southwest = (json['southwest'] as Map<String, dynamic>?) != null
        ? Southwest.fromJson(json['southwest'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['northeast'] = northeast?.toJson();
    json['southwest'] = southwest?.toJson();
    return json;
  }
}

class Northeast {
  double? lat;
  double? lng;

  Northeast({
    this.lat,
    this.lng,
  });

  Northeast.fromJson(Map<String, dynamic> json) {
    lat = json['lat'] as double?;
    lng = json['lng'] as double?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['lat'] = lat;
    json['lng'] = lng;
    return json;
  }
}

class Southwest {
  double? lat;
  double? lng;

  Southwest({
    this.lat,
    this.lng,
  });

  Southwest.fromJson(Map<String, dynamic> json) {
    lat = json['lat'] as double?;
    lng = json['lng'] as double?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['lat'] = lat;
    json['lng'] = lng;
    return json;
  }
}

class Photos {
  int? height;
  List<String>? htmlAttributions;
  String? photoReference;
  int? width;

  Photos({
    this.height,
    this.htmlAttributions,
    this.photoReference,
    this.width,
  });

  Photos.fromJson(Map<String, dynamic> json) {
    height = json['height'] as int?;
    htmlAttributions = (json['html_attributions'] as List?)?.map((dynamic e) => e as String).toList();
    photoReference = json['photo_reference'] as String?;
    width = json['width'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['height'] = height;
    json['html_attributions'] = htmlAttributions;
    json['photo_reference'] = photoReference;
    json['width'] = width;
    return json;
  }
}

class Reviews {
  String? authorName;
  String? authorUrl;
  String? language;
  String? originalLanguage;
  String? profilePhotoUrl;
  int? rating;
  String? relativeTimeDescription;
  String? text;
  int? time;
  bool? translated;

  Reviews({
    this.authorName,
    this.authorUrl,
    this.language,
    this.originalLanguage,
    this.profilePhotoUrl,
    this.rating,
    this.relativeTimeDescription,
    this.text,
    this.time,
    this.translated,
  });

  Reviews.fromJson(Map<String, dynamic> json) {
    authorName = json['author_name'] as String?;
    authorUrl = json['author_url'] as String?;
    language = json['language'] as String?;
    originalLanguage = json['original_language'] as String?;
    profilePhotoUrl = json['profile_photo_url'] as String?;
    rating = json['rating'] as int?;
    relativeTimeDescription = json['relative_time_description'] as String?;
    text = json['text'] as String?;
    time = json['time'] as int?;
    translated = json['translated'] as bool?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['author_name'] = authorName;
    json['author_url'] = authorUrl;
    json['language'] = language;
    json['original_language'] = originalLanguage;
    json['profile_photo_url'] = profilePhotoUrl;
    json['rating'] = rating;
    json['relative_time_description'] = relativeTimeDescription;
    json['text'] = text;
    json['time'] = time;
    json['translated'] = translated;
    return json;
  }
}
