import '../../domain/entities/report.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasource/report_remote_datasource.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;

  ReportRepositoryImpl(this.remoteDataSource);

  @override
  Future<ReportData> getReportData() async {
    final summary = await remoteDataSource.getSummary();
    final pendapatan = await remoteDataSource.getPendapatan();
    final rental = await remoteDataSource.getRental();
    final mobilPopuler = await remoteDataSource.getMobilPopuler();
    final pendapatanHarian = await remoteDataSource.getPendapatanHarian();

    return ReportData(
      summary: summary,
      pendapatan: pendapatan,
      rental: rental,
      mobilPopuler: mobilPopuler,
      pendapatanHarian: pendapatanHarian,
    );
  }
}
