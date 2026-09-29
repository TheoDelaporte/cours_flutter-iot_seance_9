import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/mesure.dart';

class HistoriqueChart extends StatelessWidget {
  final List<Mesure> mesures;

  const HistoriqueChart({
    super.key,
    required this.mesures,
  });

  @override
  Widget build(BuildContext context) {
    if (mesures.isEmpty) {
      return const SizedBox(
        height: 250,
        child: Center(
          child: Text('Aucune mesure disponible'),
        ),
      );
    }

    final spots = [
      for (int i = 0; i < mesures.length; i++)
        FlSpot(i.toDouble(), mesures[i].valeur),
    ];

    final minY = mesures.map((m) => m.valeur).reduce((a, b) => a < b ? a : b);
    final maxY = mesures.map((m) => m.valeur).reduce((a, b) => a > b ? a : b);
    final paddingY = (maxY - minY == 0) ? 2.0 : (maxY - minY) * 0.15;

    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.only(right: 24, left: 12, top: 16, bottom: 8),
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: (mesures.length - 1).toDouble() > 0 ? (mesures.length - 1).toDouble() : 1,
            minY: minY - paddingY,
            maxY: maxY + paddingY,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: (maxY - minY <= 0) ? 1 : ((maxY - minY) / 4),
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.white10,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 26,
                  interval: (mesures.length / 5).clamp(1.0, double.infinity),
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < mesures.length) {
                      final time = mesures[index].timestamp;
                      final label = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                      return Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toStringAsFixed(1)}°',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: Colors.white12,
                width: 1,
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.35,
                color: Colors.cyanAccent,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.cyanAccent.withValues(alpha: 0.15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
