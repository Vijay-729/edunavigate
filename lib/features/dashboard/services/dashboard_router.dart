import '../../../core/education/education_stage.dart';

/// Maps an [EducationStage] to the correct dashboard route. Route constants are
/// re-exported on [Routes] and registered in the app router.
class DashboardRouter {
  DashboardRouter._();

  static const String class8to10Route = '/dashboard/class8to10';
  static const String class11Route = '/dashboard/class11';
  static const String class12Route = '/dashboard/class12';

  static String routeForStage(EducationStage stage) {
    switch (stage) {
      case EducationStage.class8to10:
        return class8to10Route;
      case EducationStage.class11:
        return class11Route;
      case EducationStage.class12:
        return class12Route;
    }
  }

  static String getDashboardRoute({
    required String classOrYear,
    required String educationLevel,
  }) {
    return routeForStage(EducationClassifier.classify(
      classOrYear: classOrYear,
      educationLevel: educationLevel,
    ));
  }
}
