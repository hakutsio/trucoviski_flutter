import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome do Jogador 1',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: _controleJogador2,
                  decoration: InputDecoration(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaDoJogo(
                          nomeJogador1: nome1,
                          nomeJogador2: nome2,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    textStyle: const TextStyle(fontSize: 36),
                  ),
                  child: const Text('Iniciar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TelaDoJogo extends StatefulWidget {
  final String nomeJogador1;
  final String nomeJogador2;

  const TelaDoJogo({
    super.key,
    required this.nomeJogador1,
    required this.nomeJogador2,
  });

  @override
  State<TelaDoJogo> createState() => _TelaDoJogoState();
}

class _TelaDoJogoState extends State<TelaDoJogo> {
  int _pontosJogador1 = 0;
  int _pontosJogador2 = 0;

  void _adicionar1PontoJogador1() {
    setState(() {
      _pontosJogador1 += 1;
    });

    if (_pontosJogador1 >= 12) {
      _mostrarModalVencedor(widget.nomeJogador1);
    }
  }

  void _adicionar3PontoJogador1() {
    setState(() {
      _pontosJogador1 += 3;
    });

    if (_pontosJogador1 >= 12) {
      _mostrarModalVencedor(widget.nomeJogador1);
    }
  }

  void _adicionar1PontoJogador2() {
    setState(() {
      _pontosJogador2 += 1;
    });

    if (_pontosJogador2 >= 12) {
      _mostrarModalVencedor(widget.nomeJogador2);
    }
  }

  void _adicionar3PontoJogador2() {
    setState(() {
      _pontosJogador2 += 3;
    });

    if (_pontosJogador2 >= 12) {
      _mostrarModalVencedor(widget.nomeJogador2);
    }
  }

  void _diminuirPontoJogador1() {
    setState(() {
      if (_pontosJogador1 > 0) {
        _pontosJogador1 -= 1;
      }
    });
  }

  void _diminuirPontoJogador2() {
    setState(() {
      if (_pontosJogador2 > 0) {
        _pontosJogador2 -= 1;
      }
    });
  }

  void _mostrarModalVencedor(String nomeVencedor) {
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
                  _pontosJogador1 = 0;
                  _pontosJogador2 = 0;
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
    bool isMaoDeFerro = _pontosJogador1 == 11 && _pontosJogador2 == 11;

    Color corTextoNome = isMaoDeFerro ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isMaoDeFerro ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(isMaoDeFerro ? 'MÃO DE FERRO 🤫' : 'partida em andamento'),
        backgroundColor: isMaoDeFerro ? Colors.black : Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('./assets/segunda_tela.png'),
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
                  // JOGADOR 1 lado esquerdo
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
                        '$_pontosJogador1',
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
                        onPressed: (_pontosJogador1 > 0 && !isMaoDeFerro)
                            ? _diminuirPontoJogador1
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                          minimumSize: Size(100, 40),
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
                  // JOGADOR 2 LADO DIREITO
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
                        '$_pontosJogador2',
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
                              child: Text('+1'),
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
                            child: Text('+3'),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: (_pontosJogador2 > 0 && !isMaoDeFerro)
                            ? _diminuirPontoJogador2
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                          minimumSize: Size(100, 40),
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
