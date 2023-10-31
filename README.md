# estagioapp

Aplicativo para facilitar acesso a documentação de estágio

Este código é um aplicativo Flutter que baixa documentos a partir de uma URL. A classe principal é a classe Estagio, que é uma subclasse de StatelessWidget. Quando a aplicação é iniciada, o método main é chamado, que cria uma instância da classe Estagio e a passa para o método runApp.

A classe Estagio tem um objeto home que é uma instância da classe Estagioapp, que é uma subclasse de StatefulWidget. Estagioapp tem um título que é passado para ele como argumento. A classe Estagioapp tem uma classe interna chamada _EstagioappState, que é uma subclasse de State<Estagioapp>. Essa classe tem o estado da aplicação e inclui informações sobre o local de salvamento do arquivo, a permissão do usuário e a plataforma atual.

A classe _EstagioappState tem um método _download que é usado para baixar o documento da URL fornecida. Ele usa a biblioteca dio para realizar o download. O método _download verifica se a permissão de armazenamento foi concedida e, se sim, começa a realizar o download. Durante o download, ele atualiza o indicador de progresso. Quando o download for concluído, ele exibe uma mensagem de status na barra de notificações. Além disso, o método open da biblioteca open_file_safe é usado para abrir o arquivo baixado.

## Getting Started
Flutter application that downloads files from a server and saves them on the local file system of the device. The file download process is handled by the Dio library, which is a powerful and easy-to-use HTTP client library for Dart.

The Estagio class is the main widget of the application, and it sets up a MaterialApp widget. The home property of the MaterialApp widget is set to an instance of the Estagioapp class, which is a StatefulWidget.

The _EstagioappState class, which is the state object of the Estagioapp widget, contains the logic to download a file. In the initState method, it initializes the value of the platform variable to the current platform, and calls the prepareSaveDir method, which creates a directory to store the downloaded files, if it doesn't exist already.

The prepareSaveDir method uses the findLocalPath method to get the local path of the download directory, and creates it using the Directory class if it doesn't exist. The findLocalPath method returns the path to the download directory based on the platform. For Android, it returns /sdcard/download, and for other platforms, it returns /<application-document-directory>/Download.

The _download method is called when the user clicks the download button. It starts by requesting the Permission.storage permission, and if the permission is granted, it sets up a Dio instance and sets the onHttpClientCreate property to a function that sets the badCertificateCallback property of the HttpClient to return true. This allows the download to proceed even if the server certificate is not valid.

Next, the method gets the local path of the download directory using the findLocalPath method and calls the prepareSaveDir method to ensure that the directory exists. After that, it calls the dio.download method to start the download process. The onReceiveProgress parameter of the download method takes a callback function that is called every time the progress of the download changes. This function calculates the progress of the download as a percentage and logs it to the console.

Finally, after the download is complete, the method opens the file using the OpenFile.open method and shows a snackbar to the user indicating that the download is complete. If the permission is denied, it shows an error message to the user.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# estagioapp
