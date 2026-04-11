# Restaurant Sections API - Usage Guide

## Overview
This feature provides paginated APIs for fetching restaurants from three different sections:
1. **Restaurant Section** (مطاعم)
2. **Home/Family Section** (أسرة منتجة)
3. **Naema/Blessing Section** (نعمة)

## API Endpoints

### 1. Restaurant Section
```dart
EndPoints.getResSectionForRestaurant
// Full URL: admin/res-section/restaurants?page=$pageNumber&limit=20
```

### 2. Home/Family Section
```dart
EndPoints.getResSectionForHome
// Full URL: admin/fam-section/restaurants?page=$pageNumber&limit=20
```

### 3. Naema/Blessing Section
```dart
EndPoints.getResSectionForNaema
// Full URL: admin/pless-section/restaurants?page=$pageNumber&limit=20
```

## Response Structure

```json
{
  "message": "Restaurant section restaurants retrieved successfully",
  "restaurants": [
    {
      "id": 1,
      "name": "Pizza Palace",
      "phoneNumber": "0999999999",
      "emailAddress": "test@pizzapalace.com",
      "type": "restaurant",
      "city": "New York",
      "country": "USA",
      "latitude": "40.712776",
      "longitude": "-74.005974",
      "isActive": true,
      "isVerified": true
    }
  ],
  "pagination": {
    "currentPage": 1,
    "totalPages": 5,
    "totalItems": 100,
    "itemsPerPage": 20
  }
}
```

## Usage Examples

### Example 1: Basic Usage with Cubit

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/features/restaurant_sections/data/api/restaurant_sections_client.dart';
import 'package:foodzdashbord/features/restaurant_sections/presentation/cubit/restaurant_sections_cubit.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantSectionsCubit(
        RestaurantSectionsClient(NetworkServices()),
      )..fetchRestaurants(sectionType: SectionType.restaurant),
      child: Scaffold(
        body: BlocBuilder<RestaurantSectionsCubit, RestaurantSectionsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return CircularProgressIndicator();
            }
            
            return ListView.builder(
              itemCount: state.restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = state.restaurants[index];
                return ListTile(
                  title: Text(restaurant.name),
                  subtitle: Text(restaurant.city),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
```

### Example 2: Load More (Pagination)

```dart
NotificationListener<ScrollNotification>(
  onNotification: (scrollInfo) {
    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
        !state.isLoadingMore &&
        state.hasMorePages) {
      context.read<RestaurantSectionsCubit>().loadMore(SectionType.restaurant);
    }
    return false;
  },
  child: ListView.builder(
    itemCount: state.restaurants.length + (state.isLoadingMore ? 1 : 0),
    itemBuilder: (context, index) {
      if (index == state.restaurants.length) {
        return CircularProgressIndicator(); // Loading more indicator
      }
      return RestaurantCard(restaurant: state.restaurants[index]);
    },
  ),
)
```

### Example 3: Pull to Refresh

```dart
RefreshIndicator(
  onRefresh: () => context.read<RestaurantSectionsCubit>().refresh(SectionType.home),
  child: ListView.builder(
    itemCount: state.restaurants.length,
    itemBuilder: (context, index) {
      return RestaurantCard(restaurant: state.restaurants[index]);
    },
  ),
)
```

### Example 4: Switching Between Section Types

```dart
// For Restaurant section
cubit.fetchRestaurants(sectionType: SectionType.restaurant);

// For Home/Family section
cubit.fetchRestaurants(sectionType: SectionType.home);

// For Naema/Blessing section
cubit.fetchRestaurants(sectionType: SectionType.naema);
```

### Example 5: Direct API Client Usage

```dart
final client = RestaurantSectionsClient(NetworkServices());

// Fetch page 1
final result = await client.getRestaurantSection(
  sectionType: SectionType.restaurant,
  page: 1,
);

result.fold(
  (error) => print('Error: ${error.message}'),
  (response) {
    print('Total items: ${response.pagination.totalItems}');
    print('Current page: ${response.pagination.currentPage}');
    print('Total pages: ${response.pagination.totalPages}');
    
    for (var restaurant in response.restaurants) {
      print('${restaurant.name} - ${restaurant.city}');
    }
  },
);
```

## Navigation Example

```dart
// Navigate to Restaurant section
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => RestaurantSectionsScreen(
      sectionType: SectionType.restaurant,
      title: 'مطاعم',
    ),
  ),
);

// Navigate to Home section
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => RestaurantSectionsScreen(
      sectionType: SectionType.home,
      title: 'أسرة منتجة',
    ),
  ),
);

// Navigate to Naema section
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => RestaurantSectionsScreen(
      sectionType: SectionType.naema,
      title: 'نعمة',
    ),
  ),
);
```

## State Properties

### RestaurantSectionsState
- `restaurants`: List of restaurants
- `pagination`: Pagination info (currentPage, totalPages, totalItems, itemsPerPage)
- `isLoading`: Initial loading state
- `isLoadingMore`: Loading more pages state
- `errorMessage`: Error message if any
- `currentPage`: Current page number
- `hasMorePages`: Boolean indicating if more pages are available

## Methods

### RestaurantSectionsCubit
- `fetchRestaurants({required SectionType, int page, bool isLoadMore})`: Fetch restaurants
- `loadMore(SectionType)`: Load next page
- `refresh(SectionType)`: Refresh from page 1
- `clear()`: Clear state

## Notes
- All APIs use limit=20 (fixed)
- Pagination starts from page 1
- Use `hasMorePages` to check if more data is available
- All emit() calls are wrapped with isClosed checks
- Error handling is built-in with Arabic error messages
