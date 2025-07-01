import 'dart:convert';

class ApiResponse {
  final List<TabListRes> events;
  final Pagination pagination;

  ApiResponse({
    required this.events,
    required this.pagination,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    events: List<TabListRes>.from(json["events"]?.map((x) => TabListRes.fromJson(x)) ?? []),
    pagination: Pagination.fromJson(json["pagination"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "events": List<dynamic>.from(events.map((x) => x.toJson())),
    "pagination": pagination.toJson(),
  };
}

class Pagination {
  final int page;
  final int size;
  final int totalCount;
  final int lastPage;

  Pagination({
    required this.page,
    required this.size,
    required this.totalCount,
    required this.lastPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    page: json["page"] ?? 1,
    size: json["size"] ?? 20,
    totalCount: json["totalCount"] ?? 0,
    lastPage: json["lastPage"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "size": size,
    "totalCount": totalCount,
    "lastPage": lastPage,
  };
}

ApiResponse apiResponseFromJson(String str) => ApiResponse.fromJson(json.decode(str));
String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

List<TabListRes> tabListResFromJson(String str) =>
    List<TabListRes>.from(json.decode(str)["events"]?.map((x) => TabListRes.fromJson(x)) ?? []);

String tabListResToJson(List<TabListRes> data) =>
    json.encode({"events": List<dynamic>.from(data.map((x) => x.toJson()))});

class TabListRes {
  final String id;
  final String title;
  final String type;
  final String description;
  final String category;
  final List<String> hashtags;
  final List<dynamic> countryCodes;
  final List<dynamic> regions;
  final String status;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String imageUrl;
  final String image128Url;
  final DateTime resolutionDate;
  final String resolutionSource;
  final double totalVolume;
  final List<Market> markets;

  TabListRes({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.category,
    required this.hashtags,
    required this.countryCodes,
    required this.regions,
    required this.status,
    required this.createdAt,
    required this.resolvedAt,
    required this.imageUrl,
    required this.image128Url,
    required this.resolutionDate,
    required this.resolutionSource,
    required this.totalVolume,
    required this.markets,
  });

  factory TabListRes.fromJson(Map<String, dynamic> json) => TabListRes(
    id: json["id"] ?? "",
    title: json["title"] ?? "",
    type: json["type"] ?? "",
    description: json["description"] ?? "",
    category: json["category"] ?? "",
    hashtags: List<String>.from(json["hashtags"]?.map((x) => x.toString()) ?? []),
    countryCodes: List<dynamic>.from(json["countryCodes"] ?? []),
    regions: List<dynamic>.from(json["regions"] ?? []),
    status: json["status"] ?? "",
    createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : DateTime.now(),
    resolvedAt: json["resolvedAt"] != null ? DateTime.parse(json["resolvedAt"]) : null,
    imageUrl: json["imageUrl"] ?? "",
    image128Url: json["image128Url"] ?? "",
    resolutionDate: json["resolutionDate"] != null
        ? DateTime.parse(json["resolutionDate"])
        : DateTime.fromMillisecondsSinceEpoch(0),
    resolutionSource: json["resolutionSource"] ?? "",
    totalVolume: (json["totalVolume"] ?? 0).toDouble(),
    markets: List<Market>.from(json["markets"]?.map((x) => Market.fromJson(x)) ?? []),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "type": type,
    "description": description,
    "category": category,
    "hashtags": hashtags,
    "countryCodes": countryCodes,
    "regions": regions,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "resolvedAt": resolvedAt?.toIso8601String(),
    "imageUrl": imageUrl,
    "image128Url": image128Url,
    "resolutionDate": resolutionDate.toIso8601String(),
    "resolutionSource": resolutionSource,
    "totalVolume": totalVolume,
    "markets": List<dynamic>.from(markets.map((x) => x.toJson())),
  };
}

class Market {
  final String id;
  final String title;
  final String rules;
  final String imageUrl;
  final String image128Url;
  final double yesBuyPrice;
  final double noBuyPrice;
  final double yesPriceForEstimate;
  final double noPriceForEstimate;
  final String status;
  final String? resolvedOutcome;
  final double volumeValueYes;
  final double volumeValueNo;
  final double yesProfitForEstimate;
  final double noProfitForEstimate;

  Market({
    required this.id,
    required this.title,
    required this.rules,
    required this.imageUrl,
    required this.image128Url,
    required this.yesBuyPrice,
    required this.noBuyPrice,
    required this.yesPriceForEstimate,
    required this.noPriceForEstimate,
    required this.status,
    required this.resolvedOutcome,
    required this.volumeValueYes,
    required this.volumeValueNo,
    required this.yesProfitForEstimate,
    required this.noProfitForEstimate,
  });

  factory Market.fromJson(Map<String, dynamic> json) => Market(
    id: json["id"] ?? "",
    title: json["title"] ?? "",
    rules: json["rules"] ?? "",
    imageUrl: json["imageUrl"] ?? "",
    image128Url: json["image128Url"] ?? "",
    yesBuyPrice: (json["yesBuyPrice"] ?? 0).toDouble(),
    noBuyPrice: (json["noBuyPrice"] ?? 0).toDouble(),
    yesPriceForEstimate: (json["yesPriceForEstimate"] ?? 0).toDouble(),
    noPriceForEstimate: (json["noPriceForEstimate"] ?? 0).toDouble(),
    status: json["status"] ?? "",
    resolvedOutcome: json["resolvedOutcome"],
    volumeValueYes: (json["volumeValueYes"] ?? 0).toDouble(),
    volumeValueNo: (json["volumeValueNo"] ?? 0).toDouble(),
    yesProfitForEstimate: (json["yesProfitForEstimate"] ?? 0).toDouble(),
    noProfitForEstimate: (json["noProfitForEstimate"] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "rules": rules,
    "imageUrl": imageUrl,
    "image128Url": image128Url,
    "yesBuyPrice": yesBuyPrice,
    "noBuyPrice": noBuyPrice,
    "yesPriceForEstimate": yesPriceForEstimate,
    "noPriceForEstimate": noPriceForEstimate,
    "status": status,
    "resolvedOutcome": resolvedOutcome,
    "volumeValueYes": volumeValueYes,
    "volumeValueNo": volumeValueNo,
    "yesProfitForEstimate": yesProfitForEstimate,
    "noProfitForEstimate": noProfitForEstimate,
  };
}