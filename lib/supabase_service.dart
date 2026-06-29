import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: dotenv.get('SUPABASE_URL'),
      anonKey: dotenv.get('SUPABASE_ANON_KEY'),
    );
  }

  static final SupabaseClient client = Supabase.instance.client;

  static Future<void> salvarEstatistica(String nome, int vitorias) async {
    await client.from('estatisticas').upsert({
      'nome': nome,
      'vitorias': vitorias,
    }, onConflict: 'nome');
  }

  static Future<List<Map<String, dynamic>>> buscarEstatisticas() async {
    final response = await client.from('estatisticas').select();
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> limparEstatisticas() async {
    await client.from('estatisticas').delete().neq('nome', '');
  }

  static Future<void> salvarPartidasFinalizadas(int total) async {
    await client.from('configuracoes').upsert({
      'chave': 'partidas_finalizadas',
      'valor': total.toString(),
    }, onConflict: 'chave');
  }

  static Future<int> buscarPartidasFinalizadas() async {
    final response = await client
        .from('configuracoes')
        .select()
        .eq('chave', 'partidas_finalizadas')
        .maybeSingle();

    if (response != null) {
      return int.tryParse(response['valor'] ?? '0') ?? 0;
    }
    return 0;
  }
}
