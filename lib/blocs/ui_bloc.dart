import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

class UIEvent {}

class UILoadEvent extends UIEvent {}

abstract class UIState {}

class UILoading extends UIState {}

class UILoaded extends UIState {
  final Map<String, dynamic> uiJson;
  UILoaded(this.uiJson);
}

class UIError extends UIState {
  final String message;
  UIError(this.message);
}


class UIBloc extends Bloc<UIEvent, UIState> {
  final Dio _dio = Dio();

  UIBloc() : super(UILoading()) {
    on<UILoadEvent>((event, emit) async {
      try {
        final response = await _dio.get('https://example.com/ui-config.json');

        if (response.data != null && response.data is Map<String, dynamic>) {
          emit(UILoaded(response.data));
        } else {
          emit(UILoaded({"screen": {"widgets": []}})); // Fallback to empty UI
        }
      } catch (e) {
        emit(UILoaded({"screen": {"widgets": []}})); // Handle API error gracefully
      }
    });

  }
}
