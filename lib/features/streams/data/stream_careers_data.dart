import '../models/stream_career.dart';
import 'careers/commerce_careers.dart';
import 'careers/humanities_careers.dart';
import 'careers/pcb_careers.dart';
import 'careers/pcm_careers.dart';

class StreamCareersData {
  StreamCareersData._();

  static const List<StreamCareer> all = [
    ...pcmCareers,
    ...pcbCareers,
    ...commerceCareers,
    ...humanitiesCareers,
  ];

  static List<StreamCareer> forStream(String streamCode) =>
      all.where((c) => c.streamCode == streamCode).toList();

  static StreamCareer? byId(String id) {
    for (final c in all) {
      if (c.id == id) return c;
    }
    return null;
  }
}
