import 'package:flutter_bloc/flutter_bloc.dart';

class SectionSelectionCubit extends Cubit<SectionSelectionState> {
  SectionSelectionCubit() : super(SectionSelectionState.initial());

  void toggleSelection(int id) {
    final newSelectedIds = Set<int>.from(state.selectedIds);
    if (newSelectedIds.contains(id)) {
      newSelectedIds.remove(id);
    } else {
      newSelectedIds.add(id);
    }
    
    if (!isClosed) {
      emit(state.copyWith(selectedIds: newSelectedIds));
    }
  }

  void clearSelection() {
    if (!isClosed) {
      emit(SectionSelectionState.initial());
    }
  }

  void selectAll(List<int> ids) {
    if (!isClosed) {
      emit(state.copyWith(selectedIds: Set<int>.from(ids)));
    }
  }
}

class SectionSelectionState {
  final Set<int> selectedIds;

  SectionSelectionState({required this.selectedIds});

  factory SectionSelectionState.initial() {
    return SectionSelectionState(selectedIds: {});
  }

  SectionSelectionState copyWith({Set<int>? selectedIds}) {
    return SectionSelectionState(
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }
}
