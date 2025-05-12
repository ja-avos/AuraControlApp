import 'package:aura_control/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../presentation/settings_notifier.dart';
import '../core/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SettingsNotifier>();

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: Padding(
        padding: kDefaultMargin,
        child:
            notifier.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                  children: [
                    SwitchListTile(
                      title: Text(AppLocalizations.of(context)!.darkMode),
                      value: notifier.isDarkMode,
                      onChanged: notifier.updateDarkMode,
                    ),
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.language),
                      subtitle: Text(notifier.language),
                      onTap: () async {
                        final newLanguage = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            String tempLanguage = notifier.language;
                            return AlertDialog(
                              title: Text(
                                AppLocalizations.of(context)!.language,
                              ),
                              content: DropdownButton<String>(
                                value: tempLanguage,
                                items: [
                                  DropdownMenuItem(
                                    value: 'English',
                                    child: Text(
                                      AppLocalizations.of(context)!.language,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Español',
                                    child: Text('Español'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    tempLanguage = value;
                                  }
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel,
                                  ),
                                ),
                                TextButton(
                                  onPressed:
                                      () =>
                                          Navigator.pop(context, tempLanguage),
                                  child: Text(
                                    AppLocalizations.of(context)!.save,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        if (newLanguage != null &&
                            newLanguage != notifier.language) {
                          notifier.updateLanguage(newLanguage);
                        }
                      },
                    ),
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.robotIp),
                      subtitle: Text(notifier.robotIp),
                      onTap: () async {
                        final newIp = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            String tempIp = notifier.robotIp;
                            return AlertDialog(
                              title: Text(
                                AppLocalizations.of(context)!.editRobotIp,
                              ),
                              content: TextField(
                                controller: TextEditingController(text: tempIp),
                                onChanged: (value) => tempIp = value,
                                decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context)!.robotIp,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel,
                                  ),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, tempIp),
                                  child: Text(
                                    AppLocalizations.of(context)!.save,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        if (newIp != null && newIp.isNotEmpty) {
                          notifier.updateRobotIp(newIp);
                        }
                      },
                    ),
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.sshUser),
                      subtitle: Text(notifier.sshUser),
                      onTap: () async {
                        final newUser = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            String tempUser = notifier.sshUser;
                            return AlertDialog(
                              title: Text(
                                AppLocalizations.of(context)!.editSshUser,
                              ),
                              content: TextField(
                                controller: TextEditingController(
                                  text: tempUser,
                                ),
                                onChanged: (value) => tempUser = value,
                                decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context)!.sshUser,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel,
                                  ),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, tempUser),
                                  child: Text(
                                    AppLocalizations.of(context)!.save,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        if (newUser != null && newUser.isNotEmpty) {
                          notifier.updateSshUser(newUser);
                        }
                      },
                    ),
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.sshPassword),
                      subtitle: Text('********'),
                      onTap: () async {
                        final newPassword = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            String tempPassword = '';
                            return AlertDialog(
                              title: Text(
                                AppLocalizations.of(context)!.editSshPassword,
                              ),
                              content: TextField(
                                obscureText: true,
                                onChanged: (value) => tempPassword = value,
                                decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context)!.sshPassword,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel,
                                  ),
                                ),
                                TextButton(
                                  onPressed:
                                      () =>
                                          Navigator.pop(context, tempPassword),
                                  child: Text(
                                    AppLocalizations.of(context)!.save,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        if (newPassword != null && newPassword.isNotEmpty) {
                          notifier.updateSshPassword(newPassword);
                        }
                      },
                    ),
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context)!.remoteCommandsDir,
                      ),
                      subtitle: Text(notifier.remoteCommandsDir),
                      onTap: () async {
                        final newDir = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            String tempDir = notifier.remoteCommandsDir;
                            return AlertDialog(
                              title: Text(
                                AppLocalizations.of(
                                  context,
                                )!.editRemoteCommandsDir,
                              ),
                              content: TextField(
                                controller: TextEditingController(
                                  text: tempDir,
                                ),
                                onChanged: (value) => tempDir = value,
                                decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(
                                        context,
                                      )!.remoteCommandsDir,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel,
                                  ),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, tempDir),
                                  child: Text(
                                    AppLocalizations.of(context)!.save,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        if (newDir != null && newDir.isNotEmpty) {
                          notifier.updateRemoteCommandsDir(newDir);
                        }
                      },
                    ),
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.pingInterval),
                      subtitle: Text('${notifier.pingInterval} seconds'),
                      onTap: () async {
                        final newInterval = await showDialog<int>(
                          context: context,
                          builder: (context) {
                            int tempValue = notifier.pingInterval;
                            return AlertDialog(
                              title: Text(
                                AppLocalizations.of(context)!.pingInterval,
                              ),
                              content: TextField(
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  tempValue =
                                      int.tryParse(value) ??
                                      notifier.pingInterval;
                                },
                                decoration: InputDecoration(
                                  hintText:
                                      AppLocalizations.of(
                                        context,
                                      )!.enterPingInterval,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, null),
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel,
                                  ),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, tempValue),
                                  child: Text(
                                    AppLocalizations.of(context)!.save,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        if (newInterval != null && newInterval > 0) {
                          notifier.updatePingInterval(newInterval);
                        }
                      },
                    ),
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context)!.resetToDefaults,
                      ),
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                AppLocalizations.of(context)!.resetToDefaults,
                              ),
                              content: Text(
                                AppLocalizations.of(context)!.resetConfirmation,
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, false),
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(
                                    AppLocalizations.of(context)!.confirm,
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirm == true) {
                          notifier.resetToDefaults();
                        }
                      },
                    ),
                  ],
                ),
      ),
    );
  }
}
