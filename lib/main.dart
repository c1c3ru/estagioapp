import 'dart:io'
    show
    Directory,
    HttpClient,
    HttpOverrides,
    Platform,
    SecurityContext,
    X509Certificate;

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dataJson.dart';

Future<void> main() async {
  runApp(const Estagio());
  HttpOverrides.global = MyHttpOverrides();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

var link = ListDados.getData;

class Estagio extends StatelessWidget {
  const Estagio({Key? key}) : super(key: key);

  //void initState() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Estagio',
      theme: ThemeData(
        textTheme: GoogleFonts.sourceCodeProTextTheme(),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Estagioapp(
        title: 'App para baixar documentos do estágio',
      ),
    );
  }
}

class Estagioapp extends StatefulWidget {
  const Estagioapp({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Estagioapp> createState() => _EstagioappState();
}

class _EstagioappState extends State<Estagioapp> {
  late String localDoarquivo;
  late bool permissao;
  late TargetPlatform? platform;

  //double progressValue = 0;

  @override
  void initState() {
    super.initState();
    platform = defaultTargetPlatform;
    _prepareSaveDir();
  }

  Future<void> _prepareSaveDir() async {
    var localPath = (await _findLocalPath())!;
    final savedDir = Directory(localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return '/sdcard/download';
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }

  Future<void> _download(BuildContext context, String url, String fileName) async {
    final status = await Permission.storage.request();
    try {
      if (status.isGranted) {
        final Dio dio = Dio();
        // Permission is already granted, proceed with the download
        (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
            (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };

        String? path = await _findLocalPath();
        // Prepare the save directory
        await _prepareSaveDir();
        final response = await dio.download(
          url,
          '$path/$fileName',
          onReceiveProgress: (received, total) {
            if (total != -1) {
              double progressValue = ((received / total) * 100);
              //Update the progress indicator
              if (kDebugMode) {
                print('$progressValue');
                print('${(received / total * 100).toStringAsFixed(0)}%');
              }
            }
          },
        );
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Download concluído o arquivo está na pasta de download'),
              duration: Duration(seconds: 1),
            ),
          );
        }
        OpenFile.open(path);
      } else if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permissão negada para acesso ao armazenamento'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      /// The above code is creating a list of cards that are being populated by
      /// the data from the link.dart file.
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Colors.green,
            Colors.red,
          ],
          tileMode: TileMode.mirror,
          // begin: Alignment.topCenter,
          // end: Alignment.bottomCenter,
        ),
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),

              SizedBox(
                height: topPadding,
              ),

              const SizedBox(
                height: 5,
              ),

              const AnimatedImage(),
              Container(), //<= chamando a animacao
              /// The above code is creating a list of cards.
              Expanded(
                child: ListView.builder(
                  //scrollDirection: Axis.horizontal,
                  itemCount: link.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      //height: 220,
                      width: double.maxFinite,
                      child: Card(
                        elevation: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top:
                              BorderSide(width: 2.0, color: Colors.black12),
                            ),
                            color: Colors.white38,
                          ),

                          /// This is a widget that is being used to create a list
                          /// of cards.
                          child: Padding(
                            padding: const EdgeInsets.all(7),
                            child: Stack(children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 1, top: 5),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              avatar(link[index]),
                                              const Spacer(),
                                              nameChange(link[index]),
                                              const Spacer(
                                                //width: 10,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              textSide(link[index])
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//avatar

  Widget avatar(data) {
    return Align(
      alignment: Alignment.topLeft,
      child: CircleAvatar(
        radius: 60.0,
        backgroundImage: AssetImage('${data['img']}'),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget nameChange(data) {
    return Align(
      alignment: Alignment.topRight,
      child: RichText(
        text: TextSpan(
          text: '${data['subtitulo']}',
          style: const TextStyle(
              fontFamily: 'SourceSansPro-Regular',
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
              fontSize: 17),
          children: <TextSpan>[
            TextSpan(
              text: '\n${data['titulo']}',
              style: TextStyle(
                color: data['changeColor'],
                fontFamily: 'Source Code Pro',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A function that returns a widget.
  Widget textSide(data) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 120.0),
        child: Row(
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).hideCurrentSnackBar;
                _download(context, '${data['link']}', '${data['arquivo']}');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                disabledForegroundColor: Colors.black.withOpacity(0.38),
                disabledBackgroundColor: Colors.black.withOpacity(0.12),
                elevation: 20,
                shadowColor: Colors.redAccent,
              ),
              child: const Text('Download do documento'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
//bloco de animação

/// `AnimatedImage` is a stateful widget that displays an animated image
class AnimatedImage extends StatefulWidget {
  const AnimatedImage({Key? key}) : super(key: key);

  @override
  AnimatedImageState createState() => AnimatedImageState();
}

/// `AnimatedImageState` is a `State` class that uses
/// `SingleTickerProviderStateMixin` to provide a `Ticker` for the
/// `AnimationController` that is used to animate the `Image` widget
class AnimatedImageState extends State<AnimatedImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  late final Animation<Offset> _animation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.01, -0.05),
  ).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInCirc),
  );

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/nuvens.png'),
        const SizedBox(height: 5),
        SlideTransition(
          position: _animation,
          child: Image.asset('assets/rocket.png'),
        ),
      ],
    );
  }
}