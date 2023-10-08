import '../../../../domain/models/route_screen_model.dart';
import '../../../domain/responses/category_response.dart';
import '../../presentation/resources/assets_manager.dart';

class ScreenModelRepository {
  RouteScreenModel getRouteScreenData(
    List<CategoryModel> navbar,
    List bodyList,
    int? indexNavbarClicked,
    String? backgroundImage,
  ) {
    if (backgroundImage!.isEmpty) {
      backgroundImage = AssetsManager.bgSeries;
    }
    return RouteScreenModel(
      navbarItems: navbar,
      listOfBodyItems: bodyList,
      indexNavbarClicked: indexNavbarClicked ?? 0,
      backgroundImage: backgroundImage,
    );
  }
}
