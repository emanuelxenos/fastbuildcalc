import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pdf/widgets.dart' as pdflib;
import 'package:xenoscalculadoram2/core/helpers/class/directory.dart';
import 'package:xenoscalculadoram2/core/helpers/class/image_picker.dart';
import 'package:xenoscalculadoram2/core/helpers/extensions/number_ptbr.dart';
import 'package:xenoscalculadoram2/core/helpers/extensions/text_styless.dart';
import 'package:xenoscalculadoram2/view/pdf/pdf_view.dart';

class PdfGenerateHome extends StatefulWidget {
  final List<TextEditingController> name;
  final List<TextEditingController> lenghtRoom;
  final List<TextEditingController> widthRoom;
  final List<double> amount;
  final double price;
  final double totalPrice;
  final double totalArea;
  final List<TextEditingController>? nameOflinearMeter;
  final List<TextEditingController>? inputLinearMete;
  final double? totalPriceLinear;
  final double? priceLinearMeter;
  final double? totalAreaLinear;

  const PdfGenerateHome({
    super.key,
    required this.name,
    required this.lenghtRoom,
    required this.widthRoom,
    required this.amount,
    required this.price,
    required this.totalPrice,
    required this.totalArea,
    this.nameOflinearMeter,
    this.inputLinearMete,
    this.totalPriceLinear,
    this.priceLinearMeter,
    this.totalAreaLinear,
  });

  @override
  State<PdfGenerateHome> createState() => _PdfGenerateHomeState();
}

class _PdfGenerateHomeState extends State<PdfGenerateHome> {
  Uint8List? _imageLogo;
  final constructEC = TextEditingController();
  final dateEC = TextEditingController();
  final clientEC = TextEditingController();
  final durationEC = TextEditingController();
  final adressEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preencher dados para PDF'),
        backgroundColor: const Color(0xff7437bc),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Center(
                child: _imageLogo != null
                    ? Image.memory(
                        _imageLogo!,
                        width: 200,
                        height: 200,
                      )
                    : Text(
                        'Nenhuma imagem selecionada',
                        style:
                            context.textStyless.boldText.copyWith(fontSize: 15),
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    _imageLogo = await ImagePickerH.pickImageBytes();
                    setState(() {});
                  },
                  child: const Text('Selecionar'),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: constructEC,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(label: Text('Construtora')),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dateEC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(label: Text('Data')),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: adressEC,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(label: Text('Endereço')),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: clientEC,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(label: Text('Cliente')),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: durationEC,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(label: Text('Prazo')),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      NavigatorState nav = Navigator.of(context);
                      ScaffoldMessengerState scal =
                          ScaffoldMessenger.of(context);
                      try {
                        String pdf = await _createPdf(
                          name: widget.name,
                          widtRoom: widget.widthRoom,
                          lenghtRoom: widget.lenghtRoom,
                          amount: widget.amount,
                          price: widget.price,
                          totalPrice: widget.totalPrice,
                          totalArea: widget.totalArea,
                          construction: constructEC.text,
                          date: dateEC.text,
                          client: clientEC.text,
                          duration: durationEC.text,
                          imgLogo: _imageLogo,
                          adress: adressEC.text,
                          inputLInear: widget.inputLinearMete,
                          nameOflinear: widget.nameOflinearMeter,
                          totalPriceLinearMeter: widget.totalPriceLinear,
                          priceLinearMete: widget.priceLinearMeter,
                          totalAreaLinear: widget.totalAreaLinear,
                        );
                        nav.push(MaterialPageRoute(
                          builder: (context) => PdfScreenView(pathPdf: pdf),
                        ));
                      } on Exception catch (e, s) {
                        log('Erro ao gerar pdf', error: e, stackTrace: s);
                        scal.showSnackBar(
                          const SnackBar(content: Text('Erro ao gerar o pdf')),
                        );
                      }
                    },
                    child: Text(
                      'Gerar pdf',
                      style: context.textStyless.boldText.copyWith(
                          fontSize: 18, color: const Color(0xff7437bc)),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Uint8List> loadAsset(String path) async {
  final ByteData data = await rootBundle.load(path);
  return data.buffer.asUint8List();
}

Future<String> _createPdf({
  required List<TextEditingController> name,
  required List<TextEditingController> widtRoom,
  required List<TextEditingController> lenghtRoom,
  required List<double> amount,
  required double price,
  required double totalPrice,
  required double totalArea,
  required String construction,
  required String date,
  required String client,
  required String duration,
  Uint8List? imgLogo,
  required String adress,
  List<TextEditingController>? nameOflinear,
  List<TextEditingController>? inputLInear,
  double? totalPriceLinearMeter,
  double? priceLinearMete,
  double? totalAreaLinear,
}) async {
  // final pdflib.Document pdf = pdflib.Document(deflate: zlib.encoder);
  Uint8List? img = imgLogo;
  List<List<String>> dataLinear = [];

  List<List<String>> dataa = List.generate(
      name.length,
      (index) => [
            name[index].text,
            lenghtRoom[index].text,
            widtRoom[index].text,
            amount[index].toStringAsFixed(2),
            (amount[index] * price).toPTBR,
          ]);

  if (nameOflinear != null) {
    dataLinear = List.generate(
        nameOflinear.length,
        (index) => [
              nameOflinear[index].text,
              (double.parse(inputLInear![index].text).toStringAsFixed(2)),
              (double.parse(inputLInear[index].text) * priceLinearMete!).toPTBR,
            ]);
  }

  img ??= await loadAsset('assets/images/logo-sf.png');

  final pdf = pdflib.Document();

  pdf.addPage(pdflib.MultiPage(
    build: (context) => [
      pdflib.Center(
        child: pdflib.Column(
          crossAxisAlignment: pdflib.CrossAxisAlignment.center,
          children: [
            pdflib.Image(pdflib.MemoryImage(img!), width: 200, height: 200),
          ],
        ),
      ),
      pdflib.SizedBox(height: 10),
      pdflib.Center(
        child: pdflib.Text(construction,
            style: pdflib.TextStyle(
                fontSize: 20, fontWeight: pdflib.FontWeight.bold)),
      ),
      pdflib.SizedBox(height: 5),
      pdflib.Text('Data: $date'),
      pdflib.SizedBox(height: 5),
      pdflib.Text('End.: $adress'),
      pdflib.SizedBox(height: 5),
      pdflib.Text('Cliente: $client'),
      pdflib.SizedBox(height: 10),
      pdflib.Text('METRO QUADRADO'),
      // pdflib.SizedBox(height: 10),
      pdflib.TableHelper.fromTextArray(
        headers: ['Cômodo', 'Comprimento', 'Largura', 'M²', 'Preço'],
        data: dataa,
      ),
      pdflib.SizedBox(height: 5),
      pdflib.Text(
          'A área total é ${totalArea.toStringAsFixed(2)} metros quadrados.'),
      pdflib.Text('Preço total é: ${totalPrice.toPTBR}'),
      pdflib.SizedBox(height: 20),
      nameOflinear != null ? pdflib.Text('METRO LINEAR') : pdflib.Text(''),
      nameOflinear != null
          ? pdflib.TableHelper.fromTextArray(
              headers: ['Cômodo', 'Metros', 'Preço'], data: dataLinear)
          : pdflib.Text(''),
      nameOflinear != null
          ? pdflib.Text(
              'A área total é de : ${totalAreaLinear!.toStringAsFixed(2)} metros linear')
          : pdflib.Text(''),
      nameOflinear != null
          ? pdflib.Text('O preço total é: ${totalPriceLinearMeter!.toPTBR}')
          : pdflib.Text(''),
      nameOflinear != null ? pdflib.SizedBox(height: 15) : pdflib.Text(''),
      nameOflinear != null
          ? pdflib.Text(
              'Subtotal : ${(totalPrice + totalPriceLinearMeter!).toPTBR}',
              style: pdflib.TextStyle(
                  fontSize: 13, fontWeight: pdflib.FontWeight.bold))
          : pdflib.Text(''),
      nameOflinear != null ? pdflib.SizedBox(height: 10) : pdflib.Text(''),
      pdflib.Text('Prazo',
          style: pdflib.TextStyle(
              fontSize: 15, fontWeight: pdflib.FontWeight.bold)),
      pdflib.Text(duration),
      pdflib.SizedBox(height: 10),
      pdflib.Text(
          'Ass.: Proposta para fornecimento de mão de obra civil especelizado para colocação de revestimentos'),
      pdflib.SizedBox(height: 20),
      pdflib.Text('Desenvolvido por Emanuel Xenos',
          style: const pdflib.TextStyle(fontSize: 10)),
    ],
  ));

  // final String dir = (await getApplicationDocumentsDirectory()).path;
  // final String dir = await DirectoryHelper.getApppDocumentsDicrectory();

  final String fileName = await DirectoryHelper.fileName();
  final File file = File(fileName);
  file.writeAsBytesSync(await pdf.save());

  return fileName;
}
