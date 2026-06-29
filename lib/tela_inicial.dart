import 'package:flutter/material.dart';
import 'main.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  void _mostrarAlerta(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aviso'),
        content: const Text('Aplicativo em desenvolvimento.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Escolha um aplicativo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            _BotaoGrande(
              titulo: 'Trukoviski',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: 'Trucoviski'),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _BotaoGrande(
              titulo: 'Caxetoviski',
              onPressed: () => _mostrarAlerta(context),
            ),
            const SizedBox(height: 20),
            _BotaoGrande(
              titulo: 'Generalzoviski',
              onPressed: () => _mostrarAlerta(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _BotaoGrande extends StatelessWidget {
  final String titulo;
  final VoidCallback onPressed;

  const _BotaoGrande({required this.titulo, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(250, 60),
        textStyle: const TextStyle(fontSize: 20),
      ),
      child: Text(titulo),
    );
  }
}
