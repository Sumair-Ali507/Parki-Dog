class ParksModel {
  List<dynamic>? htmlAttributions;
  String? nextPageToken;
  List<Results>? results;
  String? status;

  ParksModel({
    this.htmlAttributions,
    this.nextPageToken,
    this.results,
    this.status,
  });

  ParksModel.fromJson(Map<String, dynamic> json) {
    htmlAttributions = json['html_attributions'] as List?;
    nextPageToken = json['next_page_token'] as String?;
    results = (json['results'] as List?)?.map((dynamic e) => Results.fromJson(e as Map<String, dynamic>)).toList();
    status = json['status'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['html_attributions'] = htmlAttributions;
    json['next_page_token'] = nextPageToken;
    json['results'] = results?.map((e) => e.toJson()).toList();
    json['status'] = status;
    return json;
  }
}

class Results {
  String? businessStatus;
  String? formattedAddress;
  Geometry? geometry;
  String? icon;
  String? iconBackgroundColor;
  String? iconMaskBaseUri;
  String? name;
  List<Photos>? photos;
  String? placeId;
  PlusCode? plusCode;
  num? rating;
  String? reference;
  List<String>? types;
  int? userRatingsTotal;

  Results({
    this.businessStatus,
    this.formattedAddress,
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.name,
    this.photos,
    this.placeId,
    this.plusCode,
    this.rating,
    this.reference,
    this.types,
    this.userRatingsTotal,
  });

  Results.fromJson(Map<String, dynamic> json) {
    businessStatus = json['business_status'] as String?;
    formattedAddress = json['formatted_address'] as String?;
    geometry = (json['geometry'] as Map<String, dynamic>?) != null
        ? Geometry.fromJson(json['geometry'] as Map<String, dynamic>)
        : null;
    icon = json['icon'] as String?;
    iconBackgroundColor = json['icon_background_color'] as String?;
    iconMaskBaseUri = json['icon_mask_base_uri'] as String?;
    name = json['name'] as String?;
    photos = (json['photos'] as List?)?.map((dynamic e) => Photos.fromJson(e as Map<String, dynamic>)).toList();
    placeId = json['place_id'] as String?;
    plusCode = (json['plus_code'] as Map<String, dynamic>?) != null
        ? PlusCode.fromJson(json['plus_code'] as Map<String, dynamic>)
        : null;
    rating = json['rating'] as num?;
    reference = json['reference'] as String?;
    types = (json['types'] as List?)?.map((dynamic e) => e as String).toList();
    userRatingsTotal = json['user_ratings_total'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['business_status'] = businessStatus;
    json['formatted_address'] = formattedAddress;
    json['geometry'] = geometry?.toJson();
    json['icon'] = icon;
    json['icon_background_color'] = iconBackgroundColor;
    json['icon_mask_base_uri'] = iconMaskBaseUri;
    json['name'] = name;

    json['photos'] = photos?.map((e) => e.toJson()).toList();
    json['place_id'] = placeId;
    json['plus_code'] = plusCode?.toJson();
    json['rating'] = rating;
    json['reference'] = reference;
    json['types'] = types;
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

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({
    this.compoundCode,
    this.globalCode,
  });

  PlusCode.fromJson(Map<String, dynamic> json) {
    compoundCode = json['compound_code'] as String?;
    globalCode = json['global_code'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['compound_code'] = compoundCode;
    json['global_code'] = globalCode;
    return json;
  }
}
