import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../core/logger.dart';
import '../presentation/settings_notifier.dart';
import 'package:dartssh2/dartssh2.dart';
import 'dart:io';
import '../l10n/app_localizations.dart';
import '../core/constants.dart';

class FileTransferScreen extends StatefulWidget {
  const FileTransferScreen({Key? key}) : super(key: key);

  @override
  _FileTransferScreenState createState() => _FileTransferScreenState();
}

class _FileTransferScreenState extends State<FileTransferScreen> {
  String? _selectedFile;
  bool _isTransferring = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _remoteDirController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsNotifier>();
    _remoteDirController.text = settings.remoteCommandsDir;
  }

  @override
  void dispose() {
    _remoteDirController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = result.files.single.path;
      });
    }
  }

  Future<void> _transferFile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.noFileSelected)),
      );
      return;
    }

    final settings = context.read<SettingsNotifier>();
    final remoteDir = _remoteDirController.text;
    final robotIp = settings.robotIp;
    final username = settings.sshUser;
    final password = settings.sshPassword;

    setState(() {
      _isTransferring = true;
    });

    try {
      final client = SSHClient(
        await SSHSocket.connect(robotIp, 22),
        username: username,
        onPasswordRequest: () => password,
      );

      Logger().log(
        'Info',
        'Transferring file to robot',
        metadata: {'file': _selectedFile, 'remoteDir': remoteDir},
      );

      final fileName = _selectedFile!.split('/').last;
      final fileContent = await File(_selectedFile!).readAsBytes();

      final sftp = await client.sftp();
      final fileStream = await sftp.open(
        '$remoteDir/$fileName',
        mode: SftpFileOpenMode.create | SftpFileOpenMode.write,
      );
      await fileStream.write(Stream.value(fileContent));
      await fileStream.close();

      Logger().log(
        'Info',
        'File transferred successfully',
        metadata: {'file': _selectedFile, 'remoteDir': remoteDir},
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.fileTransferSuccess),
        ),
      );

      Navigator.of(context).pop(); // Redirect to home
    } catch (e) {
      Logger().log(
        'Error',
        'Failed to transfer file',
        metadata: {'error': e.toString()},
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context)!.fileTransferFailed}: $e',
          ),
        ),
      );
    } finally {
      setState(() {
        _isTransferring = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.fileTransfer)),
      body: Padding(
        padding: kDefaultMargin + const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _remoteDirController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.remoteCommandsDir,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.enterValidPath;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isTransferring ? null : _pickFile,
                child: Text(AppLocalizations.of(context)!.selectFile),
              ),
              if (_selectedFile != null) ...[
                const SizedBox(height: 8.0),
                Text(
                  '${AppLocalizations.of(context)!.selectedFile}: $_selectedFile',
                ),
              ],
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed:
                    (_isTransferring ||
                            _selectedFile == null ||
                            _remoteDirController.text.isEmpty)
                        ? null
                        : _transferFile,
                child:
                    _isTransferring
                        ? const CircularProgressIndicator()
                        : Text(AppLocalizations.of(context)!.transferFile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
