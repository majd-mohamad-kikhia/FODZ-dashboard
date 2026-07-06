import 'package:foodzdashbord/core/utils/app_strings.dart';

class EndPoints {
  static final EndPoints _instanceKey = EndPoints._internalKey();

  factory EndPoints() => _instanceKey;

  EndPoints._internalKey();

  static const String baseUrl =
      'http://192.168.214.62:2801/api/'; //'https://fodz.ma-core.net/api/';
  static const String login = 'auth/admin/login';
  static const String getRestaurant = 'admin/restaurants';
  static const String getProducts = 'admin/orders';
  static const String getPendingDman = 'admin/pending-delivery-men';
  static const String getConfig = 'config';
  static const String setConfig = 'config';
  static const String accepteDMan = 'admin/approve-delivery-man/';
  static const String getResSectionForRestaurant =
      'admin/res-section/restaurants';
  static const String getResSectionForHome = 'admin/fam-section/restaurants';
  static const String getResSectionForNaema = 'admin/pless-section/restaurants';
  static const String getCatSectoinForRestaurant =
      'admin/res-section/categories';
  static const String getCatSectoinForHome = 'admin/fam-section/categories';
  static const String getCatSectoinForNaema = 'admin/pless-section/categories';
  static const String getProSectoinForRestaurant = 'admin/res-section/products';
  static const String getProSectoinForHome = 'admin/fam-section/products';
  static const String getProSectoinForNaema = 'admin/pless-section/products';
  static const String getAllSections = 'section';
  static const String createSection = 'section';
  static const String deleteSectino = 'section/';
  static const String getAllUsers = 'admin/all-users';
  static const String getBlockedUsers = 'admin/banned-users';
  static const String bannedUser = 'admin/ban-user/';
  static const String unbanUser = 'admin/unban-user/';
  static const String getRestaurantDetails = 'category/';
  static const String getCategoryDetails = 'product/';
  static const String updateConfige = 'config/';
  static const String getHomeAds='home-ads/all';
  static const String createHomeAd='home-ads/create';
  static const String gitActiveRes='admin/act-restaurants';
  static const String acceptRestaurant ='admin/accept-restaurant/';
  static const String listPendingRestaurants='admin/pending-restaurants';
  static const String acceptPendingResAndHome='admin/accept-restaurant/';
  static const String listDman='admin/delivery-men';
  static const String bannDriver='admin/delivery-man/';
  static const String unbanDriver='admin/delivery-man/';
  static const String banResOrHome='admin/ban-restaurant/';
  static const String unbanResOrHome='admin/unban-restaurant/';
  static const String declinePendingResAndHome='admin/delete-restaurant/';
  static const String cancelOrder='orders/admin/cancel-approved-cash';
  static const String giveWarning='admin/warnings';
  static const String getCities = 'cities';
  static const String createCity = 'cities';
  static const String deleteCity = 'cities/';
  
  static Map<String, String> baseHeaders = {
    AppStrings.accept: "${AppStrings.applicationJson}, */*",
    AppStrings.contentType: "application/json",
    AppStrings.charset: 'utf-8',
    AppStrings.acceptLanguage: "en",
  };
}
