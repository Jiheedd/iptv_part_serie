import 'dart:convert';
import 'package:flutter/services.dart';

import '../../data/env/env.dart';
import 'package:http/http.dart' as http;

import '../responses/category_response.dart';
import '../responses/serie_response.dart';

class CategoryServices {
  // static String decryptedData = "";

  Future<ResponseCategory> getCategoriesCategories() async {
    // final response = await http.get(Uri.parse(url));
    String jsonString = await rootBundle.loadString('assets/json/categories.json');

    // print("decryptedData = ${decryptedData.toString()}");

    return ResponseCategory.fromJson(jsonDecode(jsonString));
  }


}

final categoryService = CategoryServices();
