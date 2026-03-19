import "dart:convert";

class SurahInfoModel {
  final int id;
  final int revelationOrder;
  final String revelationPlace;
  final int versesCount;
  final String pagesRange;
  final bool noBismillah;

  SurahInfoModel({
    required this.id,
    required this.revelationOrder,
    required this.revelationPlace,
    required this.versesCount,
    required this.pagesRange,
    this.noBismillah = false,
  });

  SurahInfoModel copyWith({
    int? id,
    int? revelationOrder,
    String? revelationPlace,
    int? versesCount,
    String? pagesRange,
    bool? noBismillah,
  }) => SurahInfoModel(
    id: id ?? this.id,
    revelationOrder: revelationOrder ?? this.revelationOrder,
    revelationPlace: revelationPlace ?? this.revelationPlace,
    versesCount: versesCount ?? this.versesCount,
    pagesRange: pagesRange ?? this.pagesRange,
    noBismillah: noBismillah ?? this.noBismillah,
  );

  factory SurahInfoModel.fromJson(String str) =>
      SurahInfoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SurahInfoModel.fromMap(Map<String, dynamic> json) => SurahInfoModel(
    id: json["id"],
    revelationOrder: json["ro"], // ro -> revelation_order
    revelationPlace: json["rp"], // rp -> revelation_place
    versesCount: json["vc"], // vc -> verses_count
    pagesRange: json["pr"], // pr -> pages_range
    noBismillah: json["noBismillah"] ?? false,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "ro": revelationOrder, // ro -> revelation_order
    "rp": revelationPlace, // rp -> revelation_place
    "vc": versesCount, // vc -> verses_count
    "pr": pagesRange, // pr -> pages_range
    "noBismillah": noBismillah,
  };
}
