import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xenoscalculadoram2/core/helpers/extensions/number_ptbr.dart';
import 'package:xenoscalculadoram2/core/helpers/extensions/text_styless.dart';
import 'package:xenoscalculadoram2/core/widgets/drawview.dart';
import 'package:xenoscalculadoram2/core/widgets/text_editable.dart';
import 'package:xenoscalculadoram2/core/widgets/text_input_box.dart';
import 'package:xenoscalculadoram2/view/home/widgets/pdf_generate_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int numberOfRooms = 0;
  double price = 0;
  List<TextEditingController> lengthControllers = [];
  List<TextEditingController> widthControllers = [];
  List<TextEditingController> nameRoom = [];
  List<double> amount = [];

  int numberLinearMeter = 0;
  List<TextEditingController> nameOfLinerarMeter = [];
  List<TextEditingController> inputLinearMeter = [];
  double priceLnearMeter = 0;

  @override
  void dispose() {
    super.dispose();

    if (lengthControllers.isNotEmpty) {
      for (int i = 0; i <= lengthControllers.length; i++) {
        lengthControllers[i].dispose();
        widthControllers[i].dispose();
      }
    }
  }

  @override
  void initState() {
    resquestPermission();
    super.initState();
  }

  void resquestPermission() async {
    var status = await Permission.storage.status;

    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CALCULAR METROS'),
        backgroundColor: const Color(0xff7437bc),
      ),
      drawer: const Drawer(
        child: Drawview(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Metro Quadrado',
                style: context.textStyless.title,
              ),
              Text(
                'Número de cômodos',
                style: context.textStyless.title,
              ),
              TextInputBox(
                keyboardType: TextInputType.number,
                maxLengthNumber: 2,
                onChange: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      numberOfRooms = 0;
                    } else {
                      numberOfRooms = int.parse(value);
                    }

                    lengthControllers = List.generate(
                        numberOfRooms, (index) => TextEditingController());
                    widthControllers = List.generate(
                        numberOfRooms, (index) => TextEditingController());
                    amount = List.generate(numberOfRooms, (index) => 0);
                    nameRoom = List.generate(
                        numberOfRooms,
                        (index) =>
                            TextEditingController(text: 'Sala ${index + 1}'));
                  });
                },
              ),
              Text(
                'Preço por metro',
                style: context.textStyless.title,
              ),
              TextInputBox(
                keyboardType: TextInputType.number,
                onChange: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      price = 0;
                    } else {
                      price = double.parse(value);
                    }
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: lengthControllers.isEmpty
                    ? 10
                    : height * .30, // ou outra altura fixa desejada
                child: ListView.builder(
                  itemCount: numberOfRooms,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text('Sala ${index + 1}'),
                        TextEditable(
                          controller: nameRoom[index],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextInputBox(
                                contoller: lengthControllers[index],
                                keyboardType: TextInputType.number,
                                labelText: 'Comprimento',
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: TextInputBox(
                                contoller: widthControllers[index],
                                keyboardType: TextInputType.number,
                                labelText: 'Largura',
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ), //Geração dos M²

              Text(
                'Calcular metro linear',
                style: context.textStyless.title,
              ),
              TextInputBox(
                keyboardType: TextInputType.number,
                maxLengthNumber: 2,
                labelText: 'Quantidade',
                onChange: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      numberLinearMeter = 0;
                    } else {
                      numberLinearMeter = int.parse(value);
                      nameOfLinerarMeter = List.generate(
                          numberLinearMeter,
                          (index) =>
                              TextEditingController(text: 'Sala $index'));
                      inputLinearMeter = List.generate(numberLinearMeter,
                          (index) => TextEditingController());
                    }
                  });
                },
              ),
              const SizedBox(height: 10),

              TextInputBox(
                keyboardType: TextInputType.number,
                labelText: 'Preço',
                onChange: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      priceLnearMeter = 0;
                    } else {
                      priceLnearMeter = double.parse(value);
                    }
                  });
                },
              ),

              SizedBox(
                  height: numberLinearMeter == 0
                      ? 10
                      : MediaQuery.of(context).size.height * .3,
                  child: ListView.builder(
                    itemCount: numberLinearMeter,
                    itemBuilder: (context, index) => Column(
                      children: [
                        TextEditable(
                          controller: nameOfLinerarMeter[index],
                        ),
                        TextInputBox(
                          contoller: inputLinearMeter[index],
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  )),

              //Divisor, botaão de calculo abaixo
              // const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    double totalArea = 0.0;
                    double totalAreaLiner = 0.0;
                    for (int i = 0; i < numberOfRooms; i++) {
                      totalArea += double.parse(lengthControllers[i].text) *
                          double.parse(widthControllers[i].text);
                      amount[i] = double.parse(lengthControllers[i].text) *
                          double.parse(widthControllers[i].text);
                    }

                    for (int i = 0; i < numberLinearMeter; i++) {
                      totalAreaLiner += double.parse(inputLinearMeter[i].text);
                    }

                    ListView listViewDialog = ListView.builder(
                      itemCount: lengthControllers.length,
                      itemBuilder: (context, index) => Row(
                        children: [
                          Text(nameRoom[index].text),
                          Text(': ${amount[index].toStringAsFixed(2)}² '),
                          Text(' => ${(amount[index] * price).toPTBR}'),
                        ],
                      ),
                    );
                    ListView listViewDialogMeter = ListView.builder(
                      itemCount: numberLinearMeter,
                      itemBuilder: (context, index) => Row(
                        children: [
                          Text(nameOfLinerarMeter[index].text),
                          Text(': ${inputLinearMeter[index].text}'),
                          Text(
                              ' => ${(priceLnearMeter * double.parse(inputLinearMeter[index].text)).toPTBR}'),
                        ],
                      ),
                    );

                    double totalPrice = totalArea * price;
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Área Total'),
                          content: Wrap(children: [
                            Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width: MediaQuery.of(context).size.width * .6,
                                  child: listViewDialog,
                                ),
                                const Text('Metro Linear'),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width: MediaQuery.of(context).size.width * .6,
                                  child: listViewDialogMeter,
                                ),
                              ],
                            ),
                            Text(
                                'A área total é ${totalArea.toStringAsFixed(2)} metros quadrados.'),
                            Text('Preço total é: ${totalPrice.toPTBR}'),
                            const Divider(),
                            Text(
                                'Área linear Tota é: ${totalAreaLiner.toStringAsFixed(2)}'),
                            Text(
                                'Preço total: ${(priceLnearMeter * totalAreaLiner).toPTBR}'),
                          ]),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Fechar'),
                            ),
                            TextButton(
                                onPressed: () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => PdfGenerateHome(
                                        name: nameRoom,
                                        lenghtRoom: lengthControllers,
                                        widthRoom: widthControllers,
                                        amount: amount,
                                        price: price,
                                        totalPrice: totalPrice,
                                        totalArea: totalArea,
                                        inputLinearMete: inputLinearMeter,
                                        nameOflinearMeter: nameOfLinerarMeter,
                                        totalPriceLinear:
                                            totalAreaLiner * priceLnearMeter,
                                        priceLinearMeter: priceLnearMeter,
                                        totalAreaLinear: totalAreaLiner,
                                      ),
                                    )),
                                child: const Text('Gerar PDF'))
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Calcular Área',
                    style: context.textStyless.boldText
                        .copyWith(color: const Color(0xff7437bc), fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
