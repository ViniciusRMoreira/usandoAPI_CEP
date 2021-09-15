import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _resultado = "Resultado";
  TextEditingController _controllerCep = TextEditingController();
  _recuperarCep() async {
    String cepDigitado = _controllerCep.text;
    String url = 'http://viacep.com.br/ws/${cepDigitado}/json/';

    http.Response response;

    response = await http.get(Uri.parse(url));

    print("Resposta: " + response.body);
    Map<String, dynamic> retorno = json.decode(response.body);
    String localidade = retorno["localidade"];
    String cep = retorno["cep"];
    String uf = retorno["uf"];

    setState(() {
      _resultado = "Cep: ${cep}\nLocalidade: ${localidade}\nUF: ${uf}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo serviço web"),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Digite o cep: ex:12530000",
              ),
              style: TextStyle(fontSize: 20),
              controller: _controllerCep,
            ),
            RaisedButton(
              onPressed: _recuperarCep,
              child: Text(
                "Clique aqui",
              ),
            ),
            Text(
              _resultado,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
