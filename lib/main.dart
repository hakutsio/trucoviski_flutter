import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'tela_estatisticas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trucoviski',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 52, 69, 168),
        ),
      ),
      home: const MyHomePage(title: 'Trucoviski'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controleJogador1 = TextEditingController();
  final TextEditingController _controleJogador2 = TextEditingController();

  int _converterValorCartas(String valor) {
    if (valor == 'ACE') return 14;
    if (valor == 'KING') return 13;
    if (valor == 'QUEEN') return 12;
    if (valor == 'JACK') return 11;
    return int.tryParse(valor) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('./assets/image_trucoviski.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 250.0, left: 50.0, right: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _controleJogador1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome do Jogador 1',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controleJogador2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome do Jogador 2',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    String nome1 = _controleJogador1.text.isEmpty
                        ? "Jogador 1"
                        : _controleJogador1.text;
                    String nome2 = _controleJogador2.text.isEmpty
                        ? 'Jogador 2'
                        : _controleJogador2.text;

                    _rodarRoletaCartas(nome1, nome2);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    textStyle: const TextStyle(fontSize: 36),
                  ),
                  child: const Text('Iniciar'),
                ),

                const SizedBox(height: 15),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TelaEstatisticas(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 45),
                    textStyle: const TextStyle(fontSize: 20),
                    backgroundColor: Colors.blueGrey[700],
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.bar_chart),
                  label: const Text('Estatísticas'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _rodarRoletaCartas(String jogador1, String jogador2) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        bool carregando = false;

        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                  SizedBox(width: 10),
                  Text(
                    'ROLETOVISKI! ⚔️',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: carregando
                  ? const SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.redAccent,
                        ),
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bem-vindo ao Roletoviski! O tambor vai girar e apenas a sorte vai salvar um de vocês.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'O gatilho será puxado com 2 cartas brutas do baralho:',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '🔫 Bala 1 ($jogador1)\n🔫 Bala 2 ($jogador2)',
                          style: const TextStyle(
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Quem tirar a maior carta sobrevive e ganha o direito de começar. Preparados?',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
              actions: carregando
                  ? []
                  : [
                      TextButton(
                        onPressed: () async {
                          setStateModal(() {
                            carregando = true;
                          });

                          try {
                            final url = Uri.parse(
                              'https://deckofcardsapi.com/api/deck/new/draw/?count=2',
                            );
                            final resposta = await http.get(url);

                            if (resposta.statusCode == 200) {
                              final dados = jsonDecode(resposta.body);

                              String imgCarta1 = dados['cards'][0]['image'];
                              String valorCarta1 = dados['cards'][0]['value'];

                              String imgCarta2 = dados['cards'][1]['image'];
                              String valorCarta2 = dados['cards'][1]['value'];

                              int peso1 = _converterValorCartas(valorCarta1);
                              int peso2 = _converterValorCartas(valorCarta2);

                              String vencedorRoleta = peso1 > peso2
                                  ? jogador1
                                  : jogador2;

                              Navigator.of(context).pop();

                              _mostrarResultadoRoleta(
                                jogador1,
                                jogador2,
                                imgCarta1,
                                imgCarta2,
                                vencedorRoleta,
                              );
                            } else {
                              throw Exception('Erro na API');
                            }
                          } catch (e) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Erro ao conectar com a API de cartas!',
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Puxar Cartas',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
            );
          },
        );
      },
    );
  }

  void _mostrarResultadoRoleta(
    String j1,
    String j2,
    String urlC1,
    String urlC2,
    String vencedor,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              '🏆 $vencedor Começa!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        j1,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Image.network(urlC1, height: 120),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        j2,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Image.network(urlC2, height: 120),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaDoJogo(
                        nomeJogador1: j1,
                        nomeJogador2: j2,
                        quemComeca: vencedor,
                      ),
                    ),
                  );
                },
                child: const Text('Ir para o Jogo'),
              ),
            ),
          ],
        );
      },
    );
  }
}

class TelaDoJogo extends StatefulWidget {
  final String nomeJogador1;
  final String nomeJogador2;
  final String quemComeca;

  const TelaDoJogo({
    super.key,
    required this.nomeJogador1,
    required this.nomeJogador2,
    required this.quemComeca,
  });

  @override
  State<TelaDoJogo> createState() => _TelaDoJogoState();
}

class _TelaDoJogoState extends State<TelaDoJogo> {
  int _pointsJogador1 = 0;
  int _pointsJogador2 = 0;

  void _adicionar1PontoJogador1() {
    setState(() {
      _pointsJogador1 += 1;
    });

    if (_pointsJogador1 >= 12) {
      _mostrarModalVencedor(widget.nomeJogador1);
    }
  }

  void _adicionar3PontoJogador1() {
    setState(() {
      _pointsJogador1 += 3;
    });

    if (_pointsJogador1 >= 12) {
      _mostrarModalVencedor(widget.nomeJogador1);
    }
  }

  void _adicionar1PontoJogador2() {
    setState(() {
      _pointsJogador2 += 1;
    });

    if (_pointsJogador2 >= 12) {
      _mostrarModalVencedor(widget.nomeJogador2);
    }
  }

  void _adicionar3PontoJogador2() {
    setState(() {
      _pointsJogador2 += 3;
    });

    if (_pointsJogador2 >= 12) {
      _mostrarModalVencedor(widget.nomeJogador2);
    }
  }

  void _diminuirPontoJogador1() {
    setState(() {
      if (_pointsJogador1 > 0) {
        _pointsJogador1 -= 1;
      }
    });
  }

  void _diminuirPontoJogador2() {
    setState(() {
      if (_pointsJogador2 > 0) {
        _pointsJogador2 -= 1;
      }
    });
  }

  Future<void> _computarFimDePartida(String vencedor) async {
    final prefs = await SharedPreferences.getInstance();

    int finalizadas = prefs.getInt('partidasFinalizadas') ?? 0;
    await prefs.setInt('partidasFinalizadas', finalizadas + 1);

    List<String> listaJogadores = prefs.getStringList('listaJogadores') ?? [];

    if (!listaJogadores.contains(widget.nomeJogador1)) {
      listaJogadores.add(widget.nomeJogador1);
    }
    if (!listaJogadores.contains(widget.nomeJogador2)) {
      listaJogadores.add(widget.nomeJogador2);
    }
    await prefs.setStringList('listaJogadores', listaJogadores);

    String perdedor = vencedor == widget.nomeJogador1
        ? widget.nomeJogador2
        : widget.nomeJogador1;
    if (prefs.getInt('vitorias_$perdedor') == null) {
      await prefs.setInt('vitorias_$perdedor', 0);
    }

    int vitoriasAtuais = prefs.getInt('vitorias_$vencedor') ?? 0;
    await prefs.setInt('vitorias_$vencedor', vitoriasAtuais + 1);
  }

  void _mostrarModalVencedor(String nomeVencedor) {
    _computarFimDePartida(nomeVencedor);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.emoji_events, size: 60, color: Colors.amber),
          title: const Text('Temos um Vendedor!'),
          content: Text('$nomeVencedor atingiu 12 pontos e ganhou a partida.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                setState(() {
                  _pointsJogador1 = 0;
                  _pointsJogador2 = 0;
                });
              },
              child: const Text(
                'Jogar Novamente',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMaoDeFerro = _pointsJogador1 == 11 && _pointsJogador2 == 11;
    Color corTextoNome = isMaoDeFerro ? Colors.white : Colors.black;

    // Define de forma limpa o texto superior baseado no resultado da API
    String textoSuperior = isMaoDeFerro
        ? 'MÃO DE FERRO 🤫'
        : '🃏 Começa: ${widget.quemComeca}';

    return Scaffold(
      backgroundColor: isMaoDeFerro ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(textoSuperior),
        backgroundColor: isMaoDeFerro ? Colors.black : Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('./assets/segunda_tela.png'),
            fit: BoxFit.cover,
            opacity: isMaoDeFerro ? 0.1 : 0.4,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.nomeJogador1,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: corTextoNome,
                        ),
                      ),
                      Text(
                        '$_pointsJogador1',
                        style: TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                          color: corTextoNome,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: _adicionar1PontoJogador1,
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text('+1'),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: isMaoDeFerro
                                ? null
                                : _adicionar3PontoJogador1,
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('+3'),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: (_pointsJogador1 > 0 && !isMaoDeFerro)
                            ? _diminuirPontoJogador1
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(100, 40),
                          textStyle: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('-1'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.nomeJogador2,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: corTextoNome,
                        ),
                      ),
                      Text(
                        '$_pointsJogador2',
                        style: TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                          color: corTextoNome,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: _adicionar1PontoJogador2,
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text('+1'),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: isMaoDeFerro
                                ? null
                                : _adicionar3PontoJogador2,
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('+3'),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: (_pointsJogador2 > 0 && !isMaoDeFerro)
                            ? _diminuirPontoJogador2
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(100, 40),
                          textStyle: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('-1'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
