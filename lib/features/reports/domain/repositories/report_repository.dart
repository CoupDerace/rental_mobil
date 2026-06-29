import '../entities/report.dart';

abstract class ReportRepository {
  Future<ReportData> getReportData();
}
