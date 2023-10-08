
class ResponseCategory {
  List<CategoryModel> listCategories;

  ResponseCategory({required this.listCategories});

  factory ResponseCategory.fromJson(List<dynamic> json) {

    return ResponseCategory(
      listCategories: List<CategoryModel>.from(json.map((x) => CategoryModel.fromJson(x))),
    );
  }
}


class CategoryModel {
  dynamic id;
  String name;
  String icon;

  CategoryModel(
      {required this.id, required this.name, required this.icon});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    print("getCategoryModel.fromJson Ahaaaa    = $json");

    return CategoryModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}


