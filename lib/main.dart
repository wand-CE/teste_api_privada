import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class NYTimesBooksPage extends StatefulWidget {
  @override
  _NYTimesBooksPageState createState() => _NYTimesBooksPageState();
}

class _NYTimesBooksPageState extends State<NYTimesBooksPage> {
  Dio _dio = Dio(); // Instância do Dio para fazer requisições HTTP
  String _apiKey = 'api-key'; // Substitua pela sua chave de API
  List<dynamic> _books = []; // Lista para armazenar livros recebidos
  String _errorMessage = ''; // Mensagem de erro

  // Função para buscar a lista de livros mais vendidos
  Future<void> _fetchBooks() async {
    final String url =
        'https://api.nytimes.com/svc/books/v3/lists/current/hardcover-fiction.json?api-key=$_apiKey';

    try {
      final response = await _dio.get(url);
      setState(() {
        print(response.data['results']['books']);
        _books = response.data['results']['books'] ?? []; // Armazena os livros
        _errorMessage = ''; // Limpa mensagem de erro
      });
    } catch (e) {
      setState(() {
        _books = []; // Limpa a lista em caso de erro
        _errorMessage =
            'Erro: Não foi possível carregar a lista de livros. Verifique a API Key.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NYTimes API - Livros Mais Vendidos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _fetchBooks, // Chama a função para buscar livros
              child: Text('Carregar Livros'),
            ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  final book = _books[index];
                  return ListTile(
                    title: Text(book['title'] ?? 'Título não disponível'),
                    subtitle: Text(book['author'] ?? 'Autor não especificado'),
                    trailing: Text(
                      '#${book['rank']}', // Posição na lista
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      // Exibe detalhes do livro
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(book['title']),
                          content: Text(
                            'Descrição: ${book['description']}\n\nMais Informações: ${book['amazon_product_url']}',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Fechar'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NYTimesBooksPage(),
  ));
}
