import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:xenoscalculadoram2/core/helpers/class/directory.dart';
import 'package:xenoscalculadoram2/core/helpers/class/image_picker.dart';
import 'package:xenoscalculadoram2/core/helpers/extensions/number_ptbr.dart';
import 'package:xenoscalculadoram2/core/helpers/extensions/text_styless.dart';
import 'package:xenoscalculadoram2/core/widgets/text_input_box.dart';
import 'package:pdf/widgets.dart' as pdflib;
import 'package:xenoscalculadoram2/view/home/widgets/pdf_generate_home.dart';
import 'package:xenoscalculadoram2/view/pdf/pdf_view.dart';

class PdfGeneratorService extends StatefulWidget {
  final List<TextEditingController> nameOfServices;
  final List<TextEditingController> priceOfSerices;
  final double amount;

  const PdfGeneratorService(
      {super.key,
      required this.nameOfServices,
      required this.priceOfSerices,
      required this.amount});

  @override
  State<PdfGeneratorService> createState() => _PdfGeneratorServiceState();
}

class _PdfGeneratorServiceState extends State<PdfGeneratorService> {
  Uint8List? image;
  final contructionEC = TextEditingController();
  final dateEC = TextEditingController();
  final adressEC = TextEditingController();
  final clientEC = TextEditingController();
  final durationEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preencher os dados'),
        backgroundColor: const Color(0xff7437bc),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              image == null
                  ? Text(
                      'Nenhuma imagem seleiconada',
                      style:
                          context.textStyless.boldText.copyWith(fontSize: 15),
                    )
                  : Image.memory(
                      image!,
                      width: 200,
                    ),
              ElevatedButton(
                onPressed: () async {
                  image = await ImagePickerH.pickImageBytes();
                  setState(() {});
                },
                child: const Text('Selecionar'),
              ),
              const SizedBox(
                height: 15,
              ),
              TextInputBox(
                labelText: 'Contrutora',
                contoller: contructionEC,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 10),
              TextInputBox(
                labelText: 'Data',
                contoller: dateEC,
              ),
              const SizedBox(height: 10),
              TextInputBox(
                labelText: 'Endereço',
                contoller: adressEC,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 10),
              TextInputBox(
                labelText: 'Cliente',
                contoller: clientEC,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 10),
              TextInputBox(
                contoller: durationEC,
                labelText: 'Prazo',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      NavigatorState nav = Navigator.of(context);
                      String file = await _onCreatPdf(
                          image,
                          contructionEC.text,
                          dateEC.text,
                          adressEC.text,
                          clientEC.text,
                          durationEC.text,
                          widget.nameOfServices,
                          widget.priceOfSerices,
                          widget.amount);
                      nav.push(MaterialPageRoute(
                        builder: (context) => PdfScreenView(pathPdf: file),
                      ));
                    },
                    child: Text(
                      'Gerar PDF',
                      style: context.textStyless.boldText.copyWith(
                        color: const Color(0xff7437bc),
                        fontSize: 18,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _onCreatPdf(
      Uint8List? image,
      String construction,
      String date,
      String adress,
      String client,
      String duration,
      List<TextEditingController> nameOfSerices,
      List<TextEditingController> priceOfservices,
      double amount) async {
    image ??= await loadAsset('assets/images/logo-sf.png');
    List<List<String>> data = List.generate(
        nameOfSerices.length,
        (index) => [
              nameOfSerices[index].text,
              double.parse(priceOfservices[index].text).toPTBR
            ]);

    final pdf = pdflib.Document();
    pdf.addPage(pdflib.MultiPage(
      build: (context) => [
        pdflib.Center(
          child: pdflib.Column(children: [
            pdflib.Image(pdflib.MemoryImage(image!), width: 200, height: 200),
            pdflib.SizedBox(height: 15),
            pdflib.Text(construction,
                style: pdflib.TextStyle(
                    fontSize: 20, fontWeight: pdflib.FontWeight.bold)),
          ]),
        ),
        pdflib.SizedBox(height: 5),
        pdflib.Text('Data: $date'),
        pdflib.SizedBox(height: 5),
        pdflib.Text('End.: $adress'),
        pdflib.SizedBox(height: 5),
        pdflib.Text('Clte.: $client'),
        pdflib.SizedBox(height: 10),
        pdflib.Text('Serviços Prestados'),
        pdflib.TableHelper.fromTextArray(
            headers: ['Serviço', 'Preço'], data: data),
        pdflib.SizedBox(height: 10),
        pdflib.Text('Subtotal ${amount.toPTBR}',
            style: pdflib.TextStyle(
                fontSize: 15, fontWeight: pdflib.FontWeight.bold)),
        pdflib.SizedBox(height: 15),
        pdflib.Text('Prazo',
            style: pdflib.TextStyle(
                fontSize: 15, fontWeight: pdflib.FontWeight.bold)),
        pdflib.Text(duration),
        pdflib.SizedBox(height: 10),
        pdflib.Text('Desenvolvio por Emanuel Xenos',
            style: const pdflib.TextStyle(fontSize: 10)),
      ],
    ));

    String filepath = await DirectoryHelper.fileName();
    File file = File(filepath);
    file.writeAsBytesSync(await pdf.save());
    return filepath;
  }
}
