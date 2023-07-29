// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'package:hive_flutter/hive_flutter.dart';

// import 'package:agenda/screens/camera.dart';
// import 'package:agenda/screens/conta_em_analise.dart';

// import 'package:agenda/components/animated_progress_bar.dart';
// import 'package:agenda/components/icon_button.dart';
// import 'package:agenda/components/inline_radio.dart';
// import 'package:agenda/components/outline_input.dart';
// import 'package:agenda/components/icon_text_button.dart';
// import 'package:agenda/components/app_bar.dart';

// import 'package:agenda/utils/api.dart';
// import 'package:agenda/utils/models.dart';
// import 'package:agenda/utils/constants.dart';
// import 'package:agenda/utils/formatters.dart';
// import 'package:agenda/utils/dias_semana.dart';
// import 'package:agenda/utils/estados.dart';

// // ignore: must_be_immutable
// class CriarContaScreen extends StatefulWidget {
//   bool cancelarCadastroEmAndamento = false;
//   CriarContaScreen({
//     required this.cancelarCadastroEmAndamento,
//     super.key,
//   });

//   @override
//   State<CriarContaScreen> createState() => _CriarContaScreenState();
// }

// class _CriarContaScreenState extends State<CriarContaScreen>
//     with TickerProviderStateMixin {
//   var userdata = Hive.box('userdata');

//   late TabController _etapasController;
//   int totalEtapas = 6;
//   int etapa = 1;
//   int etapaConcluida = 0;

//   String? userCPF;
//   String? userId;

//   late MyTextEditingController _cpf;
//   late MyTextEditingController _nome;
//   late MyTextEditingController _email;
//   late MyTextEditingController _emailConfirmacao;
//   late MyTextEditingController _senha;
//   bool mostrarSenha = false;
//   late MyTextEditingController _senhaConfirmacao;
//   bool mostrarSenhaConfirmacao = false;

//   late MyTextEditingController _dataNascimento;
//   String? sexo;
//   bool sexoError = false;
//   late MyTextEditingController _celular;
//   int? escolaridade;
//   bool escolaridadeError = false;
//   bool temDificuldade = false;
//   late MyTextEditingController _dificuldade;

//   late MyTextEditingController _cep;
//   late MyTextEditingController _endereco;
//   late MyTextEditingController _numero;
//   late MyTextEditingController _complemento;
//   late MyTextEditingController _bairro;
//   int? estado;
//   bool estadoError = false;
//   List<ModelCidade> cidades = [];
//   int? cidade;
//   bool cidadeError = false;

//   List<ModelTipoVaga> tipoVagas = [];
//   List<int> tipoVagasSelecionados = [];
//   bool tipoVagasError = false;

//   List<ModelDisponibilidade> disponibilidades = [
//     ModelDisponibilidade(
//         diaSemana: 1, horaInicial: 6, horaFinal: 18, disponivel: true),
//     ModelDisponibilidade(
//         diaSemana: 2, horaInicial: 6, horaFinal: 18, disponivel: true),
//     ModelDisponibilidade(
//         diaSemana: 3, horaInicial: 6, horaFinal: 18, disponivel: true),
//     ModelDisponibilidade(
//         diaSemana: 4, horaInicial: 6, horaFinal: 18, disponivel: true),
//     ModelDisponibilidade(
//         diaSemana: 5, horaInicial: 6, horaFinal: 18, disponivel: true),
//     ModelDisponibilidade(
//         diaSemana: 6, horaInicial: 6, horaFinal: 18, disponivel: true),
//     ModelDisponibilidade(
//         diaSemana: 7, horaInicial: 6, horaFinal: 18, disponivel: true),
//   ];
//   bool disponibilidadeError = false;

//   String documentoImagePath = '';
//   String fotoImagePath = '';

//   void initCadastro() {
//     if (widget.cancelarCadastroEmAndamento) {
//       userdata.delete('cpf');
//       userdata.delete('id');
//       userdata.delete('etapa_concluida');
//     } else {
//       setState(() {
//         userCPF = userdata.get('cpf');
//         userId = userdata.get('id');
//         etapaConcluida = userdata.get('etapa_concluida');
//         etapa = etapaConcluida + 1;
//       });
//       carregarTipoVagas();
//     }
//   }

//   void initTextControllers() {
//     _cpf = MyTextEditingController(
//       validator: MyInputValidator(
//         condition: validateCPF,
//         errorMessage: 'O CPF precisa ser válido',
//       ),
//     );
//     _nome = MyTextEditingController(
//       validator: MyInputValidator(
//         condition: (value) => value.trim().split(' ').length >= 2,
//         errorMessage: 'É necessário um nome e sobrenome',
//       ),
//     );
//     _email = MyTextEditingController(
//       validator: MyInputValidator(
//         condition: validateEmail,
//         errorMessage: 'O e-mail precisa ser válido',
//       ),
//     );
//     _emailConfirmacao = MyTextEditingController(
//       validator: MyInputValidator(
//         condition: (value) =>
//             validateEmail(_email.text) && _email.text.trim() == value.trim(),
//         errorMessage: 'Os e-mails precisam ser iguais',
//       ),
//     );
//     _senha = MyTextEditingController(
//       validator: MyInputValidator(
//         condition: (value) => value.length >= 6,
//         errorMessage: 'A senha precisa ser maior',
//       ),
//     );
//     _senhaConfirmacao = MyTextEditingController(
//       validator: MyInputValidator(
//         condition: (value) =>
//             value.length >= 6 && _senha.text.trim() == value.trim(),
//         errorMessage: 'As senhas precisam ser iguais',
//       ),
//     );

//     _dataNascimento = MyTextEditingController(
//       validator: MyInputValidator(
//         condition: validateDate,
//         errorMessage: 'É preciso uma data válida',
//       ),
//     );
//     _celular = MyTextEditingController(
//       validator: MyInputValidator(
//         condition: (value) => removeSymbols(value.trim()).length == 11,
//         errorMessage: 'É preciso um número válido',
//       ),
//     );
//     _dificuldade = MyTextEditingController(
//       validator: MyInputValidator(
//         condition: (value) => value.isNotEmpty,
//         errorMessage: 'Nos conte sua dificuldade',
//       ),
//     );

//     _cep = MyTextEditingController(
//       validator: MyInputValidator(
//         condition: (value) => removeSymbols(value.trim()).length == 8,
//         errorMessage: 'É preciso um CEP válido',
//       ),
//     );
//     _endereco = MyTextEditingController(
//       validator: MyInputValidator(
//         condition: (value) => value.isNotEmpty,
//         errorMessage: 'É preciso um endereço válido',
//       ),
//     );
//     _numero = MyTextEditingController(
//       validator: MyInputValidator(
//         condition: (value) => value.isNotEmpty,
//         errorMessage: 'É preciso um número válido',
//       ),
//     );
//     _complemento = MyTextEditingController();
//     _bairro = MyTextEditingController(
//       validator: MyInputValidator(
//         condition: (value) => value.isNotEmpty,
//         errorMessage: 'É preciso um número válido',
//       ),
//     );
//   }

//   void proximaEtapa() {
//     if (etapa + 1 <= totalEtapas) {
//       setState(() {
//         etapa = etapa + 1;
//         etapaConcluida = etapaConcluida + 1;
//       });

//       FocusManager.instance.primaryFocus?.unfocus();
//       _etapasController.animateTo(etapa - 1);
//     }
//   }

//   bool validateSexo(String? value) {
//     setState(() {
//       sexoError = value == null;
//     });
//     return value != null;
//   }

//   bool validateEscolaridade(int? value) {
//     setState(() {
//       escolaridadeError = value == null;
//     });
//     return value != null;
//   }

//   bool validateEstado(int? value) {
//     setState(() {
//       estadoError = value == null;
//     });
//     return value != null;
//   }

//   bool validateCidade(int? value) {
//     setState(() {
//       cidadeError = value == null;
//     });
//     return value != null;
//   }

//   Future<void> carregarCidades(int estado) async {
//     var response = await ApiQuery('$API_URL/lista/cidades').getAll({
//       'id_uf': estado,
//     });

//     if (response['status']) {
//       List<ModelCidade> cidadesLista = [];

//       for (Map<String, dynamic> item in response['cidades']) {
//         cidadesLista.add(ModelCidade(
//           id: int.parse(item['id'] ?? '0'),
//           idUf: int.parse(item['idUf'] ?? '0'),
//           nome: item['cidade'] ?? '',
//         ));
//       }

//       setState(() {
//         cidades = cidadesLista;
//       });
//     } else {
//       Future.delayed(Duration.zero).then(
//         (value) => showMySnackBar(
//           context,
//           response['msg'],
//           false,
//         ),
//       );
//     }
//   }

//   Future<void> carregarTipoVagas() async {
//     var response = await ApiQuery('$API_URL/prestador/tipo-vagas').getAll({
//       'cpf': userCPF,
//       'id': userId,
//     });

//     if (response['status']) {
//       Map<dynamic, dynamic> opcoes =
//           response['opcoes'] as Map<dynamic, dynamic>;

//       setState(() {
//         tipoVagas = opcoes.entries.map((entry) {
//           final key = int.parse(entry.key);
//           final value = entry.value;
//           return ModelTipoVaga(codTipoVaga: key, tipoVaga: value);
//         }).toList();
//       });
//     }
//   }

//   void adicionarTipoVagas(int codTipoVaga) {
//     if (tipoVagasSelecionados.contains(codTipoVaga)) {
//       tipoVagasSelecionados.remove(codTipoVaga);
//     } else {
//       tipoVagasSelecionados.add(codTipoVaga);
//     }

//     setState(() {});
//   }

//   bool validateTipoVagas(List<int> values) {
//     setState(() {
//       tipoVagasError = values.isEmpty;
//     });
//     return values.isNotEmpty;
//   }

//   bool validateDisponibilidade(List<Map<String, String>> values) {
//     setState(() {
//       disponibilidadeError = values.isEmpty;
//     });
//     return values.isNotEmpty;
//   }

//   void selecionardisponibilidades(
//       int index, RangeValues? value, bool disponivel) {
//     if (value != null) {
//       if (value.start < value.end) {
//         setState(() {
//           disponibilidades[index].horaInicial = value.start.toInt();
//           disponibilidades[index].horaFinal = value.end.toInt();
//         });
//       }
//     } else {
//       setState(() {
//         disponibilidades[index].disponivel = disponivel;
//       });
//     }
//   }

//   void salvarDocumentoImagePath(String imagePath) {
//     setState(() {
//       documentoImagePath = imagePath;
//     });
//   }

//   void salvarFotoImagePath(String imagePath) {
//     setState(() {
//       fotoImagePath = imagePath;
//     });
//   }

//   // CONCLUSÃO DAS ETAPAS
//   Future<void> enviarPrimeiraEtapa() async {
//     if (!_cpf.validate() ||
//         !_nome.validate() ||
//         !_email.validate() ||
//         !_emailConfirmacao.validate() ||
//         !_senha.validate() ||
//         !_senhaConfirmacao.validate()) return;

//     var response =
//         await ApiQuery('$API_URL/prestador/cadastro/etapa-1').create({
//       'cpf': removeSymbols(_cpf.text.trim()),
//       'nome': _nome.text.trim(),
//       'email': _email.text.trim(),
//       'senha': _senha.text.trim(),
//     });

//     if (response['status']) {
//       userdata.put('cpf', response['cpf']);
//       userdata.put('id', response['id']);
//       userdata.put('etapa_concluida', 1);
//       setState(() {
//         userCPF = response['cpf'];
//         userId = response['id'];
//       });
//       proximaEtapa();
//       if (tipoVagas.isEmpty) carregarTipoVagas();
//     } else {
//       Future.delayed(Duration.zero).then(
//         (value) => showMySnackBar(
//           context,
//           response['msg'],
//           false,
//         ),
//       );
//       await Future.error(Error);
//     }
//   }

//   Future<void> enviarSegundaEtapa() async {
//     if (userCPF == null ||
//         userId == null ||
//         !_dataNascimento.validate() ||
//         !validateSexo(sexo) ||
//         !_celular.validate() ||
//         !validateEscolaridade(escolaridade) ||
//         (temDificuldade ? !_dificuldade.validate() : false)) return;

//     var response =
//         await ApiQuery('$API_URL/prestador/cadastro/etapa-2').update({
//       'cpf': userCPF,
//       'id': userId,
//       'datanascimento': convertDate(_dataNascimento.text),
//       'sexo': sexo,
//       'celular': _celular.text,
//       'cod_escolaridade': escolaridade,
//       'tem_dificuldade': temDificuldade ? _dificuldade.text.trim() : null,
//     });

//     if (response['status']) {
//       userdata.put('etapa_concluida', 2);
//       proximaEtapa();
//     } else {
//       Future.delayed(Duration.zero).then(
//         (value) => showMySnackBar(
//           context,
//           response['msg'],
//           false,
//         ),
//       );
//       await Future.error(Error);
//     }
//   }

//   Future<void> enviarTerceiraEtapa() async {
//     if (userCPF == null ||
//         userId == null ||
//         !_cep.validate() ||
//         !_endereco.validate() ||
//         !_numero.validate() ||
//         !_bairro.validate() ||
//         !validateEstado(estado) ||
//         !validateCidade(cidade)) return;

//     var response =
//         await ApiQuery('$API_URL/prestador/cadastro/etapa-3').update({
//       'cpf': userCPF,
//       'id': userId,
//       "cep": _cep.text,
//       "endereco": _endereco.text,
//       "numero": _numero.text,
//       "complemento": _complemento.text,
//       "bairro": _bairro.text,
//       "id_uf": estado,
//       "id_cidade": cidade,
//     });

//     if (response['status']) {
//       userdata.put('etapa_concluida', 3);
//       proximaEtapa();
//     } else {
//       Future.delayed(Duration.zero).then(
//         (value) => showMySnackBar(
//           context,
//           response['msg'],
//           false,
//         ),
//       );
//       await Future.error(Error);
//     }
//   }

//   Future<void> enviarQuartaEtapa() async {
//     if (userCPF == null ||
//         userId == null ||
//         !validateTipoVagas(tipoVagasSelecionados)) return;

//     var response =
//         await ApiQuery('$API_URL/prestador/cadastro/etapa-4').update({
//       'cpf': userCPF,
//       'id': userId,
//       "tipo_vaga": tipoVagasSelecionados,
//     });

//     if (response['status']) {
//       userdata.put('etapa_concluida', 4);
//       proximaEtapa();
//     } else {
//       Future.delayed(Duration.zero).then(
//         (value) => showMySnackBar(
//           context,
//           response['msg'],
//           false,
//         ),
//       );
//       await Future.error(Error);
//     }
//   }

//   Future<void> enviarQuintaEtapa() async {
//     List<Map<String, String>> disponibilidade = [];

//     for (ModelDisponibilidade item in disponibilidades) {
//       if (!item.disponivel) continue;
//       disponibilidade.add({
//         'dia_semana': item.diaSemana.toString(),
//         'horario_inicial': item.horaInicial.toString().padLeft(2, '0'),
//         'horario_final': item.horaFinal.toString().padLeft(2, '0'),
//       });
//     }

//     if (userCPF == null ||
//         userId == null ||
//         !validateDisponibilidade(disponibilidade)) return;

//     var response =
//         await ApiQuery('$API_URL/prestador/cadastro/etapa-5').update({
//       'cpf': userCPF,
//       'id': userId,
//       "disponibilidade": disponibilidade,
//     });

//     if (response['status']) {
//       userdata.put('etapa_concluida', 5);
//       proximaEtapa();
//     } else {
//       Future.delayed(Duration.zero).then(
//         (value) => showMySnackBar(
//           context,
//           response['msg'],
//           false,
//         ),
//       );
//       await Future.error(Error);
//     }
//   }

//   Future<void> enviarSextaEtapa() async {
//     if (userCPF == null ||
//         userId == null ||
//         documentoImagePath.isEmpty ||
//         fotoImagePath.isEmpty) return;

//     var response =
//         await ApiQuery('$API_URL/prestador/cadastro/enviar_documentos')
//             .uploadFiles({
//       'cpf': userCPF!,
//       'id': userId!,
//     }, [
//       ModelFile(fieldName: 'documento', filePath: documentoImagePath),
//       ModelFile(fieldName: 'foto', filePath: fotoImagePath),
//     ]);

//     if (response['status']) {
//       userdata.put('etapa_concluida', 6);

//       if (!mounted) return;

//       Navigator.push(
//         context,
//         CupertinoPageRoute(
//           builder: (context) => ContaEmAnaliseScreen(message: response['msg']),
//         ),
//       );
//     } else {
//       Future.delayed(Duration.zero).then(
//         (value) => showMySnackBar(
//           context,
//           response['msg'],
//           false,
//         ),
//       );
//       await Future.error(Error);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     initCadastro();

//     _etapasController = TabController(
//       initialIndex: etapaConcluida,
//       length: totalEtapas,
//       vsync: this,
//     );

//     initTextControllers();
//   }

//   @override
//   void dispose() {
//     _etapasController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MyAppBar(
//         navBar: navbarLight,
//         title: 'Criar Conta',
//       ),
//       body: SafeArea(
//         child: TabBarView(
//           controller: _etapasController,
//           physics: const NeverScrollableScrollPhysics(),
//           children: [
//             TabEtapa(
//               totalEtapas: totalEtapas,
//               etapa: 1,
//               content: [
//                 const SizedBox(height: 40),
//                 MyOutlineInput(
//                   controller: _cpf,
//                   keyboardType: TextInputType.number,
//                   labelText: 'CPF',
//                   hintText: 'Digite seu CPF',
//                   onChanged: (value) {
//                     String formatted = formatCPF(value);
//                     _cpf.value = _cpf.value.copyWith(
//                       text: formatted,
//                       selection: TextSelection.collapsed(
//                         offset: formatted.length,
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 18),
//                 MyOutlineInput(
//                   controller: _nome,
//                   keyboardType: TextInputType.name,
//                   labelText: 'Nome',
//                   hintText: 'Digite seu nome',
//                 ),
//                 const SizedBox(height: 18),
//                 MyOutlineInput(
//                   controller: _email,
//                   keyboardType: TextInputType.emailAddress,
//                   labelText: 'E-mail',
//                   hintText: 'Digite seu e-mail',
//                 ),
//                 const SizedBox(height: 18),
//                 MyOutlineInput(
//                   controller: _emailConfirmacao,
//                   keyboardType: TextInputType.emailAddress,
//                   labelText: 'Confirmação do e-mail',
//                   hintText: 'Confirme seu e-mail',
//                 ),
//                 const SizedBox(height: 18),
//                 MyOutlineInput(
//                   controller: _senha,
//                   obscureText: !mostrarSenha,
//                   labelText: 'Senha',
//                   hintText: 'Digite sua senha',
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       mostrarSenha ? Icons.visibility : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         mostrarSenha = !mostrarSenha;
//                       });
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 18),
//                 MyOutlineInput(
//                   controller: _senhaConfirmacao,
//                   obscureText: !mostrarSenhaConfirmacao,
//                   labelText: 'Confirmação da senha',
//                   hintText: 'Confirme sua senha',
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       mostrarSenhaConfirmacao
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         mostrarSenhaConfirmacao = !mostrarSenhaConfirmacao;
//                       });
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 18),
//                 MyIconTextButton(
//                   asyncOnPressed: enviarPrimeiraEtapa,
//                   label: 'Próxima Etapa',
//                   icon: Icons.arrow_forward_rounded,
//                 ),
//               ],
//             ),
//             TabEtapa(
//               totalEtapas: totalEtapas,
//               etapa: 2,
//               content: [
//                 const SizedBox(height: 40),
//                 MyOutlineInput(
//                   controller: _dataNascimento,
//                   keyboardType: TextInputType.datetime,
//                   labelText: 'Data de Nascimento',
//                   hintText: 'Data de nascimento',
//                   onChanged: (value) {
//                     String formatted = formatDate(value);
//                     _dataNascimento.value = _dataNascimento.value.copyWith(
//                       text: formatted,
//                       selection: TextSelection.collapsed(
//                         offset: formatted.length,
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 18),
//                 MyOutlineDropdown(
//                   value: sexo,
//                   labelText: 'Gênero',
//                   errorMessage: sexoError ? 'Selecione uma opção' : null,
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       sexo = newValue!;
//                     });
//                     validateSexo(newValue!);
//                   },
//                   items: const [
//                     DropdownMenuItem<String>(
//                       value: 'M',
//                       child: Text('Masculino'),
//                     ),
//                     DropdownMenuItem<String>(
//                       value: 'F',
//                       child: Text('Feminino'),
//                     ),
//                     DropdownMenuItem<String>(
//                       value: 'O',
//                       child: Text('Outro'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 18),
//                 MyOutlineInput(
//                   controller: _celular,
//                   keyboardType: TextInputType.phone,
//                   labelText: 'Celular',
//                   hintText: 'Digite seu celular',
//                   onChanged: (value) {
//                     String formatted = formatPhoneNumber(value);
//                     _celular.value = _celular.value.copyWith(
//                       text: formatted,
//                       selection: TextSelection.collapsed(
//                         offset: formatted.length,
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 18),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('Tem alguma dificuldade?'),
//                     Row(
//                       children: [
//                         MyInlineRadio(
//                           label: 'Sim',
//                           value: true,
//                           selected: temDificuldade,
//                           onChanged: () {
//                             setState(() {
//                               temDificuldade = true;
//                             });
//                           },
//                         ),
//                         MyInlineRadio(
//                           label: 'Não',
//                           value: false,
//                           selected: temDificuldade,
//                           onChanged: () {
//                             setState(() {
//                               temDificuldade = false;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 temDificuldade
//                     ? MyOutlineInput(
//                         controller: _dificuldade,
//                         keyboardType: TextInputType.text,
//                         labelText: 'Dificuldade',
//                         hintText: 'Digite sua dificuldade',
//                       )
//                     : Container(),
//                 const SizedBox(height: 18),
//                 MyIconTextButton(
//                   asyncOnPressed: enviarSegundaEtapa,
//                   label: 'Próxima Etapa',
//                   icon: Icons.arrow_forward_rounded,
//                 ),
//               ],
//             ),
//             TabEtapa(
//               totalEtapas: totalEtapas,
//               etapa: 3,
//               content: [
//                 const SizedBox(height: 40),
//                 MyOutlineInput(
//                   controller: _cep,
//                   keyboardType: TextInputType.number,
//                   labelText: 'CEP',
//                   hintText: 'Digite seu CEP',
//                   onChanged: (value) {
//                     String formatted = formatCEP(value);
//                     _cep.value = _cep.value.copyWith(
//                       text: formatted,
//                       selection: TextSelection.collapsed(
//                         offset: formatted.length,
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 18),
//                 MyOutlineInput(
//                   controller: _endereco,
//                   keyboardType: TextInputType.streetAddress,
//                   labelText: 'Endereço',
//                   hintText: 'Digite seu endereço',
//                 ),
//                 const SizedBox(height: 18),
//                 MyOutlineInput(
//                   controller: _numero,
//                   keyboardType: TextInputType.text,
//                   labelText: 'Número',
//                   hintText: 'Digite seu número',
//                 ),
//                 const SizedBox(height: 18),
//                 MyOutlineInput(
//                   controller: _complemento,
//                   keyboardType: TextInputType.text,
//                   labelText: 'Complemento',
//                   hintText: 'Digite seu complemento',
//                 ),
//                 const SizedBox(height: 18),
//                 MyOutlineInput(
//                   controller: _bairro,
//                   keyboardType: TextInputType.text,
//                   labelText: 'Bairro',
//                   hintText: 'Digite seu bairro',
//                 ),
//                 const SizedBox(height: 18),
//                 MyOutlineDropdown<int>(
//                   value: estado,
//                   labelText: 'Estado',
//                   errorMessage: estadoError ? 'Selecione uma opção' : null,
//                   onChanged: (int? newValue) {
//                     setState(() {
//                       estado = newValue!;
//                     });
//                     if (validateEstado(newValue!)) carregarCidades(newValue);
//                   },
//                   items: estados
//                       .map(
//                         (estado) => DropdownMenuItem<int>(
//                           value: estado.id,
//                           child: Text(estado.nome),
//                         ),
//                       )
//                       .toList(),
//                 ),
//                 const SizedBox(height: 18),
//                 MyOutlineDropdown<int>(
//                   value: cidade,
//                   labelText: 'Cidade',
//                   errorMessage: cidadeError ? 'Selecione uma opção' : null,
//                   onChanged: (int? newValue) {
//                     setState(() {
//                       cidade = newValue!;
//                     });
//                     validateCidade(newValue!);
//                   },
//                   items: cidades
//                       .map(
//                         (cidade) => DropdownMenuItem<int>(
//                           value: cidade.id,
//                           child: Text(cidade.nome),
//                         ),
//                       )
//                       .toList(),
//                 ),
//                 const SizedBox(height: 18),
//                 MyIconTextButton(
//                   asyncOnPressed: enviarTerceiraEtapa,
//                   label: 'Próxima Etapa',
//                   icon: Icons.arrow_forward_rounded,
//                 ),
//               ],
//             ),
//             TabEtapa(
//               totalEtapas: totalEtapas,
//               etapa: 4,
//               content: [
//                 const SizedBox(height: 40),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 18),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           'Para qual vaga deseja trabalhar?',
//                           style: TextStyle(
//                             color: AppColors.primary,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 tipoVagas.isEmpty
//                     ? Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               'Não foi possível carregar as vagas',
//                               style: TextStyle(
//                                 color: AppColors.primary,
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     : Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: tipoVagas.map(
//                           (tipoVaga) {
//                             bool selected = tipoVagasSelecionados
//                                 .contains(tipoVaga.codTipoVaga);

//                             return GestureDetector(
//                               onTap: () =>
//                                   adicionarTipoVagas(tipoVaga.codTipoVaga),
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 18,
//                                   vertical: 8,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: selected
//                                       ? AppColors.secondary
//                                       : AppColors.tertiary.withOpacity(.35),
//                                   borderRadius: BorderRadius.circular(100),
//                                   border: Border.all(
//                                     color: AppColors.secondary.withOpacity(.5),
//                                     width: 1,
//                                   ),
//                                 ),
//                                 child: Text(
//                                   tipoVaga.tipoVaga,
//                                   style: TextStyle(
//                                     color: selected
//                                         ? Colors.white
//                                         : Colors.grey[800],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ).toList(),
//                       ),
//                 !tipoVagasError
//                     ? Container()
//                     : Padding(
//                         padding: const EdgeInsets.only(top: 8),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 'É nessesário selecionar ao menos uma vaga',
//                                 style: TextStyle(
//                                   color: AppColors.error,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                 const SizedBox(height: 18),
//                 MyIconTextButton(
//                   asyncOnPressed: enviarQuartaEtapa,
//                   label: 'Próxima Etapa',
//                   icon: Icons.arrow_forward_rounded,
//                 ),
//               ],
//             ),
//             TabEtapa(
//               totalEtapas: totalEtapas,
//               etapa: 5,
//               content: [
//                 const SizedBox(height: 40),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('Qual a sua disponibilidades?'),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: diasSemana.length,
//                       itemBuilder: (context, index) => Padding(
//                         padding: const EdgeInsets.only(top: 18),
//                         child: Opacity(
//                           opacity: disponibilidades[index].disponivel ? 1 : .35,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           '${diasSemana[index]}: ',
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Text(
//                                           'Das ${disponibilidades[index].horaInicial}h às ${disponibilidades[index].horaFinal}h',
//                                         ),
//                                       ],
//                                     ),
//                                     RangeSlider(
//                                       values: RangeValues(
//                                         disponibilidades[index]
//                                             .horaInicial
//                                             .toDouble(),
//                                         disponibilidades[index]
//                                             .horaFinal
//                                             .toDouble(),
//                                       ),
//                                       labels: RangeLabels(
//                                         '${disponibilidades[index].horaInicial}h',
//                                         '${disponibilidades[index].horaFinal}h',
//                                       ),
//                                       divisions: 24,
//                                       min: 0,
//                                       max: 24,
//                                       onChanged: (values) =>
//                                           selecionardisponibilidades(
//                                               index, values, true),
//                                       activeColor: AppColors.primary,
//                                       inactiveColor:
//                                           AppColors.tertiary.withOpacity(.35),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               MyIconButton(
//                                 iconData: disponibilidades[index].disponivel
//                                     ? Icons.close
//                                     : Icons.check,
//                                 color: AppColors.primary,
//                                 onTap: () {
//                                   selecionardisponibilidades(index, null,
//                                       !disponibilidades[index].disponivel);
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 !disponibilidadeError
//                     ? Container()
//                     : Padding(
//                         padding: const EdgeInsets.only(top: 8),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 'É nessesário selecionar ao menos um dia',
//                                 style: TextStyle(
//                                   color: AppColors.error,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                 const SizedBox(height: 18),
//                 MyIconTextButton(
//                   asyncOnPressed: enviarQuintaEtapa,
//                   label: 'Próxima Etapa',
//                   icon: Icons.arrow_forward_rounded,
//                 ),
//               ],
//             ),
//             TabEtapa(
//               totalEtapas: totalEtapas,
//               etapa: 6,
//               content: [
//                 const SizedBox(height: 40),
//                 documentoImagePath.isNotEmpty
//                     ? SizedBox(
//                         width: MediaQuery.of(context).size.width - 60,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Documento',
//                                   style: TextStyle(
//                                     color: AppColors.primary,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: MediaQuery.of(context).size.width -
//                                       60 -
//                                       80,
//                                   child: const MyAnimatedProgressBar(
//                                     duration: Duration(milliseconds: 500),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             MyIconButton(
//                               iconData: Icons.close,
//                               color: AppColors.primary,
//                               onTap: () {
//                                 setState(() {
//                                   documentoImagePath = '';
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                       )
//                     : MyIconTextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             CupertinoPageRoute(
//                               builder: (context) => const CameraScreen(
//                                 title: 'Enviar Documento',
//                               ),
//                             ),
//                           ).then((imagePath) =>
//                               salvarDocumentoImagePath(imagePath));
//                         },
//                         label: 'Enviar Documento',
//                         icon: Icons.file_present,
//                         backgroundColor: AppColors.tertiary,
//                       ),
//                 const SizedBox(height: 18),
//                 fotoImagePath.isNotEmpty
//                     ? SizedBox(
//                         width: MediaQuery.of(context).size.width - 60,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Foto',
//                                   style: TextStyle(
//                                     color: AppColors.primary,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: MediaQuery.of(context).size.width -
//                                       60 -
//                                       80,
//                                   child: const MyAnimatedProgressBar(
//                                     duration: Duration(milliseconds: 500),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             MyIconButton(
//                               iconData: Icons.close,
//                               color: AppColors.primary,
//                               onTap: () {
//                                 setState(() {
//                                   fotoImagePath = '';
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                       )
//                     : MyIconTextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             CupertinoPageRoute(
//                               builder: (context) => const CameraScreen(
//                                 title: 'Enviar Foto',
//                                 camera: Camera.front,
//                               ),
//                             ),
//                           ).then((imagePath) => salvarFotoImagePath(imagePath));
//                         },
//                         label: 'Enviar Foto',
//                         icon: Icons.person_outline,
//                         backgroundColor: AppColors.tertiary,
//                       ),
//                 const SizedBox(height: 18),
//                 documentoImagePath.isEmpty || fotoImagePath.isEmpty
//                     ? Container()
//                     : MyIconTextButton(
//                         asyncOnPressed: enviarSextaEtapa,
//                         label: 'Finalizar Cadastro',
//                         icon: Icons.arrow_forward_rounded,
//                       ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProgressoEtapas extends StatelessWidget {
//   final int totalEtapas;
//   final int etapa;
//   final void Function()? onTap;
//   const ProgressoEtapas({
//     required this.totalEtapas,
//     required this.etapa,
//     this.onTap,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     double height =
//         (MediaQuery.of(context).size.width - 80) / (totalEtapas * 1.5);

//     if (height > 30) height = 30;

//     return GestureDetector(
//       onTap: onTap,
//       child: SizedBox(
//         height: height,
//         child: ListView.separated(
//           scrollDirection: Axis.horizontal,
//           shrinkWrap: true,
//           itemCount: totalEtapas,
//           itemBuilder: (context, index) => Container(
//             width: height,
//             height: height,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 width: 2,
//                 color: etapa >= index + 1
//                     ? AppColors.primary
//                     : AppColors.primary.withOpacity(.5),
//               ),
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: etapa > index + 1
//                   ? Icon(
//                       Icons.check,
//                       color: AppColors.primary,
//                       size: totalEtapas > 6 ? 96 / totalEtapas : 16,
//                     )
//                   : Text(
//                       (index + 1).toString(),
//                       style: TextStyle(
//                         color: etapa >= index + 1
//                             ? AppColors.primary
//                             : AppColors.primary.withOpacity(.5),
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//             ),
//           ),
//           separatorBuilder: (context, index) => SizedBox(
//             width: (MediaQuery.of(context).size.width - 80) / (totalEtapas * 3),
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4),
//                 child: Container(
//                   color: AppColors.primary.withOpacity(.5),
//                   height: 2,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TabEtapa extends StatelessWidget {
//   final int totalEtapas;
//   final int etapa;
//   final void Function()? onTap;
//   final List<Widget>? content;
//   const TabEtapa({
//     required this.totalEtapas,
//     required this.etapa,
//     this.onTap,
//     this.content,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//           minHeight: MediaQuery.of(context).size.height -
//               MediaQuery.of(context).padding.top -
//               kToolbarHeight * 2,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(40),
//           child: Column(
//             children: [
//               ProgressoEtapas(
//                 totalEtapas: totalEtapas,
//                 etapa: etapa,
//                 onTap: onTap,
//               ),
//               Column(
//                 children: content ?? [],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
