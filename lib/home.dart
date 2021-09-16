import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  String _resultado = "";
  TextEditingController _controllerCep = TextEditingController();

  var mascaraCep = MaskTextInputFormatter(mask: '########', filter: {
    "#": RegExp(
      r'[0-9]',
    )
  });

  _validar() {
    if (_formKey.currentState!.validate() == true) {
      _recuperarCep();
    } else {
      print("Erro");
    }
  }

  _recuperarCep() async {
    String cepDigitado = _controllerCep.text;
    String url = 'http://viacep.com.br/ws/$cepDigitado/json/';

    http.Response response;

    response = await http.get(Uri.parse(url));

    print("Resposta: " + response.body);
    Map<String, dynamic> retorno = json.decode(response.body) ?? "";

    var localidade = retorno["localidade"] ?? "";
    var cep = retorno["cep"] ?? "CEP INCORRETO";
    var uf = retorno["uf"] ?? "";
    var bairro = retorno["bairro"] ?? "";
    var ddd = retorno["ddd"] ?? "";
    var logradouro = retorno["logradouro"] ?? "";
    print("Resposta" + response.body);
    var local =
        "Cep: $cep\nLocalidade: $localidade\nLogradouro:$logradouro\nUF: $uf\nBairro:$bairro\nDDD:$ddd";
    setState(() {
      _resultado = local;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultando CEP via API"),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Não pode ser vazio";
                        }
                        if (value.length < 8) {
                          return "CEP incompleto";
                        }
                      },
                      inputFormatters: [mascaraCep],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Digite o CEP:",
                        hintText: '00000-000',
                      ),
                      style: TextStyle(fontSize: 20),
                      controller: _controllerCep,
                    ),
                    ElevatedButton(
                      onPressed: _validar,
                      child: Text(
                        "Conferir CEP",
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Text(
                      _resultado,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
