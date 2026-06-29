import '../../domain/entities/statistic.dart';

class StatisticModel extends Statistic {
  const StatisticModel({
    required super.title,
    required super.value,
  });

  factory StatisticModel.fromJson(
    String title,
    int value,
  ) {
    return StatisticModel(
      title: title,
      value: value,
    );
  }
}