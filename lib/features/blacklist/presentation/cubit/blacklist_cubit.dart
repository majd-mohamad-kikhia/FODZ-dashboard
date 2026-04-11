import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:foodzdashbord/features/blacklist/data/api/users_clinte.dart';
import 'package:foodzdashbord/features/blacklist/data/models/get_all_users_model.dart';
import 'package:foodzdashbord/features/blacklist/data/models/banned_user_model.dart';

part 'blacklist_state.dart';

class BlacklistCubit extends Cubit<BlacklistState> {
  BlacklistCubit() : super(const BlacklistState()) {
    _initialize();
  }

  final TextEditingController searchController = TextEditingController();

  void _initialize() async {
    try {
      if (isClosed) return;
      emit(state.copyWith(status: BlacklistStatus.loading));
    } catch (_) {}

    final allUsersClient = GetAllUsersClient();
    final blockedUsersClient = GetBlockedUsersClient();

    try {
      final allUsersResult = await allUsersClient.fetchAllUsers();
      final blockedUsersResult = await blockedUsersClient.fetchBlockedUsers();

      List<UserModel> allUsers = [];
      List<BannedUserModel> bannedUsersApi = [];
      List<BlacklistedUserModel> blockedUsers = [];

      allUsersResult.fold(
        (error) {
          // Handle error, maybe emit error
        },
        (users) => allUsers = users,
      );

      blockedUsersResult.fold(
        (error) {
          // Handle error
        },
        (users) {
          bannedUsersApi = users;
          blockedUsers = bannedUsersApi.map((user) => BlacklistedUserModel(
            id: user.id,
            name: user.name,
            banReason: user.banReason,
          )).toList();
        },
      );

      try {
        if (isClosed) return;
        emit(state.copyWith(
          status: BlacklistStatus.success,
          users: blockedUsers,
          allUsers: allUsers,
        ));
      } catch (_) {}
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        // Ignore cancel exceptions during fast navigation
        return;
      }
      try {
        if (isClosed) return;
        emit(state.copyWith(
          status: BlacklistStatus.error,
          errorMessage: 'Failed to load blacklist: $e',
        ));
      } catch (_) {}
    }
  }

  void changeTab(BlacklistTab tab) {
    emit(state.copyWith(tab: tab));
  }

  void updateSearch(String term) {
    emit(state.copyWith(searchTerm: term));
  }

  void clearSearch() {
    searchController.clear();
    emit(state.copyWith(searchTerm: ''));
  }

  Future<String?> blockUser(int userId, String reason) async {
    final client = BanUserClient();
    try {
      final result = await client.banUser(userId, reason);

      return result.fold(
        (error) => error.message,
        (data) {
          // success, update lists
          final userToBlock = state.allUsers.firstWhere((u) => u.id == userId);
          final blockedUser = BlacklistedUserModel(
            id: userToBlock.id,
            name: userToBlock.name,
            banReason: reason,
          );
          final updatedUsers = [...state.users, blockedUser];
          final updatedAllUsers = state.allUsers.where((u) => u.id != userId).toList();
          try {
            if (isClosed) return null;
            emit(state.copyWith(
              users: updatedUsers,
              allUsers: updatedAllUsers,
            ));
          } catch (_) {}
          return null;
        },
      );
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        // Ignore cancel exceptions during fast navigation
        return null;
      }
      return 'Error: $e';
    }
  }

  Future<String?> unbanUser(int userId) async {
    final client = UnbanUserClient();
    try {
      final result = await client.unbanUser(userId);

      return result.fold(
        (error) => error.message,
        (data) {
          // success, update lists
          final userToUnban = state.users.firstWhere((u) => u.id == userId);
          final restoredUser = UserModel(
            id: userToUnban.id,
            name: userToUnban.name,
            phoneNumber: '', // TODO: Get from API or store
            isActive: true, // Assume active when unbanned
            city: 'غير محدد', // Default city since we don't have it in blocked users
          );
          final updatedUsers = state.users.where((u) => u.id != userId).toList();
          final updatedAllUsers = [...state.allUsers, restoredUser];
          try {
            if (isClosed) return null;
            emit(state.copyWith(
              users: updatedUsers,
              allUsers: updatedAllUsers,
            ));
          } catch (_) {}
          return null;
        },
      );
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        // Ignore cancel exceptions during fast navigation
        return null;
      }
      return 'Error: $e';
    }
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}
