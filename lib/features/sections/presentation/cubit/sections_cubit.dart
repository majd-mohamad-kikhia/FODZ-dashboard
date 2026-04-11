import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/features/sections/data/api/sections_client.dart';
import 'package:foodzdashbord/features/sections/data/models/section_response.dart';

class SectionsCubit extends Cubit<SectionsState> {
  final SectionsClient _client;

  SectionsCubit(this._client) : super(SectionsState.initial());

  Future<void> fetchSections() async {
    if (state.isLoading) return;

    try {
      if (!isClosed) {
        emit(state.copyWith(isLoading: true, errorMessage: null));
      }

      final result = await _client.getAllSections();

      result.fold(
        (error) {
          try {
            if (!isClosed) {
              emit(state.copyWith(
                isLoading: false,
                errorMessage: error.message ?? 'حدث خطأ في تحميل الأقسام',
              ));
            }
          } catch (_) {}
        },
        (response) {
          try {
            if (!isClosed) {
              emit(state.copyWith(
                sections: response.sections,
                isLoading: false,
                errorMessage: null,
              ));
            }
          } catch (_) {}
        },
      );
    } catch (e) {
      try {
        if (!isClosed) {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: 'حدث خطأ في تحميل الأقسام',
          ));
        }
      } catch (_) {}
    }
  }

  Future<bool> createSection({
    required String screen,
    required String type,
    required String name,
    required List<int> ids,
  }) async {
    try {
      if (!isClosed) {
        emit(state.copyWith(isCreating: true, createErrorMessage: null));
      }

      final result = await _client.createSection(
        screen: screen,
        type: type,
        name: name,
        ids: ids,
      );

      return result.fold(
        (error) {
          try {
            if (!isClosed) {
              emit(state.copyWith(
                isCreating: false,
                createErrorMessage: error.message ?? 'حدث خطأ في إنشاء القسم',
              ));
            }
          } catch (_) {}
          return false;
        },
        (section) {
          try {
            if (!isClosed) {
              final updatedSections = [...state.sections, section];
              emit(state.copyWith(
                sections: updatedSections,
                isCreating: false,
                createErrorMessage: null,
              ));
            }
          } catch (_) {}
          return true;
        },
      );
    } catch (e) {
      try {
        if (!isClosed) {
          emit(state.copyWith(
            isCreating: false,
            createErrorMessage: 'حدث خطأ في إنشاء القسم',
          ));
        }
      } catch (_) {}
      return false;
    }
  }

  Future<bool> updateSection({
    required int sectionId,
    required String screen,
    required String type,
    required String name,
    required List<int> ids,
  }) async {
    try {
      if (!isClosed) {
        emit(state.copyWith(isUpdating: true, updateErrorMessage: null));
      }

      final result = await _client.updateSection(
        sectionId: sectionId,
        screen: screen,
        type: type,
        name: name,
        ids: ids,
      );

      return result.fold(
        (error) {
          try {
            if (!isClosed) {
              emit(state.copyWith(
                isUpdating: false,
                updateErrorMessage: error.message ?? 'حدث خطأ في تحديث القسم',
              ));
            }
          } catch (_) {}
          return false;
        },
        (updatedSection) {
          try {
            if (!isClosed) {
              final updatedSections = state.sections.map((section) {
                return section.id == sectionId ? updatedSection : section;
              }).toList();
              emit(state.copyWith(
                sections: updatedSections,
                isUpdating: false,
                updateErrorMessage: null,
              ));
            }
          } catch (_) {}
          return true;
        },
      );
    } catch (e) {
      try {
        if (!isClosed) {
          emit(state.copyWith(
            isUpdating: false,
            updateErrorMessage: 'حدث خطأ في تحديث القسم',
          ));
        }
      } catch (_) {}
      return false;
    }
  }

  Future<bool> deleteSection({required int sectionId}) async {
    try {
      if (!isClosed) {
        emit(state.copyWith(
          isDeleting: true,
          deleteErrorMessage: null,
        ));
      }
    } catch (_) {}

    try {
      final result = await _client.deleteSection(sectionId: sectionId);

      return result.fold(
        (error) {
          try {
            if (!isClosed) {
              emit(state.copyWith(
                isDeleting: false,
                deleteErrorMessage: error.message ?? 'حدث خطأ في حذف القسم',
              ));
            }
          } catch (_) {}
          return false;
        },
        (data) {
          try {
            if (!isClosed) {
              final updatedSections = state.sections
                  .where((section) => section.id != sectionId)
                  .toList();
              emit(state.copyWith(
                sections: updatedSections,
                isDeleting: false,
                deleteErrorMessage: null,
              ));
            }
          } catch (_) {}
          return true;
        },
      );
    } catch (e) {
      try {
        if (!isClosed) {
          emit(state.copyWith(
            isDeleting: false,
            deleteErrorMessage: 'حدث خطأ في حذف القسم',
          ));
        }
      } catch (_) {}
      return false;
    }
  }

  Future<void> refresh() async {
    await fetchSections();
  }

  void clear() {
    try {
      if (!isClosed) {
        emit(SectionsState.initial());
      }
    } catch (_) {}
  }
}

class SectionsState {
  final List<Section> sections;
  final bool isLoading;
  final String? errorMessage;
  final bool isCreating;
  final String? createErrorMessage;
  final bool isUpdating;
  final String? updateErrorMessage;
  final bool isDeleting;
  final String? deleteErrorMessage;

  SectionsState({
    required this.sections,
    required this.isLoading,
    this.errorMessage,
    required this.isCreating,
    this.createErrorMessage,
    required this.isUpdating,
    this.updateErrorMessage,
    required this.isDeleting,
    this.deleteErrorMessage,
  });

  factory SectionsState.initial() {
    return SectionsState(
      sections: [],
      isLoading: false,
      errorMessage: null,
      isCreating: false,
      createErrorMessage: null,
      isUpdating: false,
      updateErrorMessage: null,
      isDeleting: false,
      deleteErrorMessage: null,
    );
  }

  SectionsState copyWith({
    List<Section>? sections,
    bool? isLoading,
    String? errorMessage,
    bool? isCreating,
    String? createErrorMessage,
    bool? isUpdating,
    String? updateErrorMessage,
    bool? isDeleting,
    String? deleteErrorMessage,
  }) {
    return SectionsState(
      sections: sections ?? this.sections,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isCreating: isCreating ?? this.isCreating,
      createErrorMessage: createErrorMessage,
      isUpdating: isUpdating ?? this.isUpdating,
      updateErrorMessage: updateErrorMessage,
      isDeleting: isDeleting ?? this.isDeleting,
      deleteErrorMessage: deleteErrorMessage,
    );
  }
}
