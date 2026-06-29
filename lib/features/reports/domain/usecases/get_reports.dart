import '../entities/report.dart';
import '../repositories/report_repository.dart';

class GetReports {
  final ReportRepository repository;

  GetReports(this.repository);

  Future<ReportData> call() {
    return repository.getReportData();
  }
}
