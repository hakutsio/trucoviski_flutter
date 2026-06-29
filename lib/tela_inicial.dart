import 'package:flutter/material.dart';
import 'main.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  void _mostrarAlerta(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 10),
            const Text('Aviso'),
          ],
        ),
        content: const Text(
          'Aplicativo em desenvolvimento. Fique atento às próximas atualizações!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colorScheme.primary.withOpacity(0.15), Colors.grey[100]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // MARCADOROVISKI ATIVADO 🛠️
                  Text(
                    'MARCADOROVISKI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36, // Um pouco maior por ser uma palavra única
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary.withOpacity(0.9),
                      letterSpacing: 4.0, // Letras bem espaçadas e imponentes
                    ),
                  ),
                  const SizedBox(height: 12),
                  Icon(
                    Icons.sports_esports_outlined,
                    size: 80,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Escolha um Marcador',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selecione a modalidade para iniciar',
                    style: TextStyle(color: Colors.grey[500], fontSize: 16),
                  ),
                  const SizedBox(height: 48),

                  _BotaoGrande(
                    titulo: 'Trukoviski',
                    subtitulo: 'Jogo de Truco',
                    icone: Icons.style,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const MyHomePage(title: 'Trucoviski'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _BotaoGrande(
                    titulo: 'Caxetoviski',
                    subtitulo: 'Jogo de Cacheta',
                    icone: Icons.style_outlined,
                    onPressed: () => _mostrarAlerta(context),
                  ),
                  const SizedBox(height: 16),
                  _BotaoGrande(
                    titulo: 'Generalzoviski',
                    subtitulo: 'Jogo de Dados',
                    icone: Icons.casino_rounded,
                    onPressed: () => _mostrarAlerta(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BotaoGrande extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icone;
  final VoidCallback onPressed;

  const _BotaoGrande({
    required this.titulo,
    required this.subtitulo,
    required this.icone,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icone,
              size: 28,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitulo,
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}
