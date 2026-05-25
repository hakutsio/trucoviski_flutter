import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

class TelaEstatisticas extends StatefulWidget {
  const TelaEstatisticas({super.key});

  @override
  State<TelaEstatisticas> createState() => _TelaEstatisticasState();
}

class _TelaEstatisticasState extends State<TelaEstatisticas> {
  int partidasFinalizadas = 0;
  int partidasInacabadas = 0;

  Map<String, int> rankingVitoretas = {};

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> listaJogadores = prefs.getStringList('listaJogadores') ?? [];

    Map<String, int> mapaTemporario = {};
    for (String jogador in listaJogadores) {
      int vitorias = prefs.getInt('vitorias_$jogador') ?? 0;
      mapaTemporario[jogador] = vitorias;
    }

    setState(() {
      partidasFinalizadas = prefs.getInt('partidasFinalizadas') ?? 0;
      rankingVitoretas = mapaTemporario;
    });
  }

  Future<void> _limparHistorico() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico e Estatísticas'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/telaEstatistica.png'),
            fit: BoxFit.cover,
            opacity: 0.40,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueGrey[200]!),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.emoji_events_outlined,
                      size: 40,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Partidas Concluídas',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$partidasFinalizadas',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                'Ranking de Vitórias',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: 220,
                child: rankingVitoretas.isEmpty
                    ? const Center(child: Text('Nenhuma vitória registrada'))
                    : BarChart(
                        BarChartData(
                          barTouchData: BarTouchData(enabled: false),
                          barGroups: rankingVitoretas.entries.map((entry) {
                            int index =
                                rankingVitoretas.keys.toList().indexOf(
                                  entry.key,
                                ) +
                                1;
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value.toDouble(),
                                  color: Colors.blueAccent,
                                  width: 40,
                                  borderRadius: BorderRadius.zero,
                                ),
                              ],
                            );
                          }).toList(),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.grey[400]!,
                              strokeWidth: 0.8,
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[600]!,
                                width: 1.2,
                              ),
                              left: BorderSide(
                                color: Colors.grey[600]!,
                                width: 1.2,
                              ),
                            ),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              axisNameWidget: const Text(
                                'Vitórias',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              axisNameSize: 20,
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (value, meta) {
                                  if (value % 1 == 0) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              axisNameWidget: const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Jogadores / Duplas',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              axisNameSize: 25,
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  int idx = value.toInt() - 1;
                                  if (idx >= 0 &&
                                      idx < rankingVitoretas.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        rankingVitoretas.keys.toList()[idx],
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 40),

              ElevatedButton.icon(
                onPressed: _limparHistorico,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 45),
                ),
                icon: const Icon(Icons.delete),
                label: const Text('Limpar Histórico GG'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
