part of 'create_ad_cubit.dart';

enum CreateAdStatus { initial, loading, success, error }

class CreateAdState {
  final CreateAdStatus status;
  final List<ActiveRestaurantModel> restaurants;
  final ActiveRestaurantModel? selectedRestaurant;
  final String? imagePath;
  final Uint8List? imageBytes;
  final String? imageFileName;
  final String? errorMessage;

  const CreateAdState({
    this.status = CreateAdStatus.initial,
    this.restaurants = const [],
    this.selectedRestaurant,
    this.imagePath,
    this.imageBytes,
    this.imageFileName,
    this.errorMessage,
  });

  CreateAdState copyWith({
    CreateAdStatus? status,
    List<ActiveRestaurantModel>? restaurants,
    ActiveRestaurantModel? selectedRestaurant,
    bool clearSelectedRestaurant = false,
    String? imagePath,
    Uint8List? imageBytes,
    String? imageFileName,
    bool clearImage = false,
    String? errorMessage,
  }) {
    return CreateAdState(
      status: status ?? this.status,
      restaurants: restaurants ?? this.restaurants,
      selectedRestaurant: clearSelectedRestaurant ? null : (selectedRestaurant ?? this.selectedRestaurant),
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      imageBytes: clearImage ? null : (imageBytes ?? this.imageBytes),
      imageFileName: clearImage ? null : (imageFileName ?? this.imageFileName),
      errorMessage: errorMessage,
    );
  }

  bool get canCreate => selectedRestaurant != null && (imagePath != null || imageBytes != null);
}
