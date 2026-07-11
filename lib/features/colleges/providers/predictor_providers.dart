import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/college_repository.dart';
import '../data/predictor_report_repository.dart';
import '../models/prediction_model.dart';
import '../models/student_stream.dart';
import '../services/prediction_engine.dart';

/// Holds the College Predictor form draft as the student fills it in.
class PredictorFormNotifier extends StateNotifier<PredictionInput> {
  PredictorFormNotifier()
      : super(const PredictionInput(
            stream: StudentStream.pcm, examId: 'jee_main'));

  bool _initialized = false;

  /// Seeds sensible defaults the first time the form screen opens for a
  /// given stream — safe to call repeatedly, only acts once.
  void initializeOnce(StudentStream stream, {String? homeState}) {
    if (_initialized) return;
    _initialized = true;
    state = PredictionInput(
      stream: stream,
      examId: stream.relevantExamIds.first,
      homeState: homeState,
      preferredState: homeState,
    );
  }

  void update(PredictionInput Function(PredictionInput) transform) {
    state = transform(state);
  }
}

final predictorFormProvider =
    StateNotifierProvider.autoDispose<PredictorFormNotifier, PredictionInput>(
  (ref) => PredictorFormNotifier(),
);

/// Runs [PredictionEngine.predict] on demand (when the student taps
/// "Predict") and holds onto the last result.
class PredictionResultNotifier extends StateNotifier<PredictionResult?> {
  PredictionResultNotifier(this._ref) : super(null);

  final Ref _ref;

  void predict(PredictionInput input) {
    final colleges =
        _ref.read(collegeRepositoryProvider).getByStream(input.stream);
    state = PredictionEngine.predict(input, colleges);
  }

  void clear() => state = null;
}

// Deliberately NOT autoDispose: `predict()` is called via `ref.read` from the
// form screen (which never watches this provider), then the result screen is
// pushed. With autoDispose, the zero-listener gap between those two steps
// would tear the state down before the result screen ever saw it.
final predictionResultProvider =
    StateNotifierProvider<PredictionResultNotifier, PredictionResult?>(
  (ref) => PredictionResultNotifier(ref),
);

/// Past saved prediction reports for the signed-in student.
final savedPredictionReportsProvider =
    StreamProvider.autoDispose<List<SavedPredictionReport>>((ref) {
  return ref.watch(predictorReportRepositoryProvider).watchReports();
});
