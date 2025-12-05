class Brand {
  String? id;
  String? name;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? imageWithPath;

  Brand({
    this.id,
    this.name,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.imageWithPath,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json["id"].toString(),
        name: json["name"],
        image: json["image"],
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        imageWithPath: json["image_with_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "image_with_path": imageWithPath,
      };
}
