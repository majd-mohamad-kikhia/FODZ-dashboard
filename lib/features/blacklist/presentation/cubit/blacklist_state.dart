part of 'blacklist_cubit.dart';

enum BlacklistStatus { initial, loading, success, error }

enum BlacklistTab { blocked, users }

class BlacklistState {
  const BlacklistState({
    this.status = BlacklistStatus.initial,
    this.users = const [],
    this.allUsers = const [],
    this.searchTerm = '',
    this.errorMessage = '',
    this.tab = BlacklistTab.blocked,
  });

  final BlacklistStatus status;
  final List<BlacklistedUserModel> users;
  final List<UserModel> allUsers;
  final String searchTerm;
  final String errorMessage;
  final BlacklistTab tab;

  List<BlacklistedUserModel> get filteredUsers {
    if (searchTerm.isEmpty) return users;
    final String lowerSearch = searchTerm.toLowerCase();
    return users
        .where((u) =>
            u.name.toLowerCase().contains(lowerSearch) ||
            u.id.toString().toLowerCase().contains(lowerSearch) ||
            u.banReason.toLowerCase().contains(lowerSearch))
        .toList();
  }

  List<UserModel> get filteredAllUsers {
    if (searchTerm.isEmpty) return allUsers;
    final String lowerSearch = searchTerm.toLowerCase();
    return allUsers
        .where((u) =>
            u.name.toLowerCase().contains(lowerSearch) ||
            u.id.toString().toLowerCase().contains(lowerSearch) ||
            (u.city?.toLowerCase().contains(lowerSearch) ?? false))
        .toList();
  }

  BlacklistState copyWith({
    BlacklistStatus? status,
    List<BlacklistedUserModel>? users,
    List<UserModel>? allUsers,
    String? searchTerm,
    String? errorMessage,
    BlacklistTab? tab,
  }) {
    return BlacklistState(
      status: status ?? this.status,
      users: users ?? this.users,
      allUsers: allUsers ?? this.allUsers,
      searchTerm: searchTerm ?? this.searchTerm,
      errorMessage: errorMessage ?? this.errorMessage,
      tab: tab ?? this.tab,
    );
  }
}

class BlacklistedUserModel {
  const BlacklistedUserModel({
    required this.id,
    required this.name,
    required this.banReason,
  });

  final int id;
  final String name;
  final String banReason;
}
