import 'package:flutter/material.dart';
import 'package:xenoscalculadoram2/core/helpers/extensions/text_styless.dart';

class Drawview extends Drawer {
  const Drawview({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                color: const Color(0xff7437bc),
                height: 150,
                child: Center(
                  child: Image.asset(
                    'assets/images/icon-logo.png',
                    width: 100,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xff7437bc),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/home', (route) => false);
                  },
                  child: Text(
                    'Calcular Metros',
                    style: context.textStyless.boldText.copyWith(fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xff7437bc),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/servicegeneral',
                      (route) => false,
                    );
                  },
                  child: Text(
                    'Serviços Gerais',
                    style: context.textStyless.boldText.copyWith(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'Versão 1.0.2',
                style:
                    context.textStyless.boldText.copyWith(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
