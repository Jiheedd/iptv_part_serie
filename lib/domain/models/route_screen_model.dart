
import '../responses/category_response.dart';


class RouteScreenModel {
  List<CategoryModel>? navbarItems;
  String? categoryChoosen;
  List<dynamic>? listOfBodyItems;
  // Future<dynamic> repositoryFunction;
  String? backgroundImage;
  int indexNavbarClicked; // New variable
  int indexSliderClicked; // New variable

  RouteScreenModel({
    this.navbarItems,
    this.listOfBodyItems,
    this.categoryChoosen = "",
    // required this.repositoryFunction,
    this.backgroundImage,
    this.indexNavbarClicked = 0,
    this.indexSliderClicked = 0,
  });

  Map<String, dynamic> toJson() => {
    'sliders': navbarItems,
    'backgroundImage': backgroundImage,
  };

  /*factory MoviesScreenModel.fromJson(Map<String, dynamic> json) {
    // var sliderList = json['sliders'] as List;

    return MoviesScreenModel(
      navbarItems: json["name"],
      backgroundImage: json['backgroundImage'],
    );
  }*/
}
