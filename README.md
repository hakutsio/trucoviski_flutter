# Trucoviski 🃏🇷🇺

O **Trucoviski** é um marcador de pontos de Truco intuitivo e temático, desenvolvido em Flutter. Ele foi criado para facilitar a contagem de tentos durante as partidas, com uma interface dinâmica que reage aos acontecimentos do jogo.

## ✨ Funcionalidades

- **Identificação dos Jogadores:** Tela inicial para entrada dos nomes, que são levados para o placar e para o anúncio de vitória.
- **Controle de Pontuação:** - Botões de `+1` e `+3` para cada jogador.
  - Botão de `-1` (decremento) que se desabilita automaticamente caso a pontuação seja 0 (evitando pontos negativos).
- **Mão de Ferro (Mão no Escuro):** - Quando a partida empata em **11 a 11**, o aplicativo entra no modo "Mão de Ferro".
- **Anúncio de Vencedor:** Uma modal estilizada aparece quando um jogador atinge 12 pontos, destacando o nome do campeão e oferecendo a opção de reiniciar a partida.
- **Design Personalizado:** Uso de imagens de fundo com opacidade controlada para garantir a legibilidade.

## 🛠️ Tecnologias e Conceitos Utilizados

- **Flutter & Dart:** Base do desenvolvimento mobile.
- **StatefulWidgets:** Para gerenciar a mudança dos pontos e cores em tempo real.
- **Navegação (Navigator):** Transição entre a tela de cadastro e a tela de jogo.
- **Passagem de Parâmetros:** Transferência de dados (nomes dos jogadores) entre telas via construtor.
- **Layouts Complexos:** Uso de `Row`, `Column`, `Expanded`, `Stack` e `Padding` para uma interface responsiva.

## 🚀 Como Executar o Projeto

1. **Pré-requisitos:**
   - Ter o SDK do [Flutter](https://docs.flutter.dev/get-started/install) instalado e configurado.
   - Um emulador ou dispositivo físico conectado.

2. **Clone o repositório:**
   ```bash
   git clone [https://github.com/hakutsio/trucoviski_flutter.git](https://github.com/hakutsio/trucoviski_flutter.git)
