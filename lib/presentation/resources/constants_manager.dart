
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppConstants{
    static const int splashDelay = 60;
    static const int sliderAnimationTime = 120;
    static const String versionNumber = "4.0.0";
    static const String alphaIptvUrl = "https://alphaiptv.tn/";
    static const String phonePermissionStatus = "phone_permission_status";


    static const List<String> menusFilterKey = [
        "Year",
        "Genre",
        "Rating",
        "Alphabetical Order",
    ];
    static const List<String> menusFilterValue = [
        "All",
        "All",
        "Descending",
        "A -> Z",
    ];

    static const List<String> menusOrderValue = [
        "A -> Z",
        "Z -> A",
    ];

    static const String favoriteChannelsCache = "favorite_channels";
    static const String favoriteSeriesCache = "favorite_series";
    static const String favoriteMoviesCache = "favorite_movies";
    static const String lastViewCache = "last_views";

    static const String noResult = "No Result";


    static void showSnackBar(String title, String subTitle) {
        Get.snackbar(
            title,
            subTitle,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.black87.withOpacity(0.5),
            colorText: Colors.white,
        );
    }

}