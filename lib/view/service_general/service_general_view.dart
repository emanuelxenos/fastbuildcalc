import 'package:flutter/material.dart';
import 'package:xenoscalculadoram2/core/helpers/extensions/number_ptbr.dart';
import 'package:xenoscalculadoram2/core/helpers/extensions/text_styless.dart';
import 'package:xenoscalculadoram2/core/widgets/drawview.dart';
import 'package:xenoscalculadoram2/core/widgets/text_input_box.dart';
import 'package:xenoscalculadoram2/view/service_general/widgets/pdf_generator_service.dart';

class ServiceGeneralView extends StatefulWidget {
  const ServiceGeneralView({super.key});

  @override
  State<ServiceGeneralView> createState() => _ServiceGeneralViewState();
}

class _ServiceGeneralViewState extends State<ServiceGeneralView> {
  final numberOfserviceEC = TextEditingController();
  int numberOfService = 0;
  double amount = 0;
  List<TextEditingController> nameOfServiceEC = [];
  List<TextEditingController> priceOfServiceEC = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SERVIÇOS GERAIS'),
        backgroundColor: const Color(0xff7437bc),
      ),
      drawer: const Drawview(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextInputBox(
                contoller: numberOfserviceEC,
                onChange: (value) {
                  setState(() {
                    if (value == null) {
                      numberOfService = 0;
                    } else if (value == '') {
                      numberOfService = 0;
                    } else {
                      numberOfService = int.parse(value);
                    }
                    nameOfServiceEC = List.generate(
                        numberOfService,
                        (index) => TextEditingController(
                            text: 'Serviço ${index + 1}'));
                    priceOfServiceEC = List.generate(
                        numberOfService, (index) => TextEditingController());
                  });
                },
                labelText: 'Número de serviços',
              ),
              SizedBox(
                height: numberOfService == 0
                    ? 10
                    : MediaQuery.of(context).size.height * .7,
                child: ListView.builder(
                    itemCount: numberOfService,
                    itemBuilder: (context, index) => Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextInputBox(
                                    keyboardType: TextInputType.text,
                                    contoller: nameOfServiceEC[index],
                                  ),
                                ),
                                Expanded(
                                  child: TextInputBox(
                                    contoller: priceOfServiceEC[index],
                                    labelText: 'Preço',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    amount = 0;
                    for (int i = 0; i < numberOfService; i++) {
                      amount += double.parse(priceOfServiceEC[i].text);
                    }

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        content: SizedBox(
                            height: 100,
                            width: 100,
                            child: Column(
                              children: [
                                const Text('O preço total é:'),
                                Text(amount.toPTBR),
                              ],
                            )),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Fechar')),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PdfGeneratorService(
                                        amount: amount,
                                        nameOfServices: nameOfServiceEC,
                                        priceOfSerices: priceOfServiceEC),
                                  ));
                            },
                            child: const Text('Gerar PDF'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    'Clacular Serviços',
                    style: context.textStyless.boldText
                        .copyWith(color: const Color(0xff7437bc), fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
