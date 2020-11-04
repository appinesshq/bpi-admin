import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/user_provider.dart';
import '../widgets/app_card.dart';

class UsersScreen extends StatelessWidget {
  static const routeName = '/users';

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: 'Users',
      division: 1.5,
      child: Consumer<UserProvider>(
        builder: (context, userProvider, widget) {
          userProvider.fetch();

          return userProvider.users.length != 0
              ? Table(
                  columnWidths: {
                    0: FlexColumnWidth(0.5),
                    1: FlexColumnWidth(),
                    2: FlexColumnWidth(1.5),
                    3: FlexColumnWidth(1.5),
                    4: FlexColumnWidth(1),
                  },
                  children: [
                    _tableHeader(),
                    ..._data(userProvider, context),
                  ],
                )
              : Text('No data...');
        },
      ),
    );
  }

  List<TableRow> _data(UserProvider userProvider, BuildContext context) {
    final theme = Theme.of(context);
    List<TableRow> d = [];

    userProvider.users.forEach((user) {
      d.add(
        TableRow(
          children: [
            Icon(
              Icons.supervisor_account,
              color: user.isAdmin() ? Colors.green : Colors.red,
            ),
            Text(user.id),
            Text(DateFormat('y-MM-d HH:mm:ss').format(user.dateCreated)),
            Text(DateFormat('y-MM-d HH:mm:ss').format(user.dateCreated)),
            Row(
              children: [
                IconButton(
                  splashRadius: 15.0,
                  icon: Icon(
                    Icons.edit,
                    color: theme.primaryColor,
                  ),
                  tooltip: 'Edit user',
                  onPressed: () {
                    print('Edit user!');
                  },
                ),
                IconButton(
                  splashRadius: 15.0,
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  tooltip: 'Delete user',
                  onPressed: () {
                    showConfirmationDialog(
                        context,
                        'Are you sure you want to delete this user?',
                        () => {
                              // TODO: Delete action
                              print('Delete user!')
                            });
                  },
                ),
              ],
            ),
          ],
        ),
      );
    });

    return d;
  }

  TableRow _tableHeader() {
    return TableRow(
      children: [
        _tableHeaderText(''),
        _tableHeaderText('ID'),
        _tableHeaderText('Created'),
        _tableHeaderText('Updated'),
        _tableHeaderText('Actions'),
      ],
    );
  }

  Widget _tableHeaderText(String s) {
    return Text(
      s,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

showConfirmationDialog(BuildContext context, String text, Function() action,
    {String title = 'Confirm', confirmText = 'Yes', cancelText = 'No'}) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text(cancelText),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text(confirmText),
    onPressed: () {
      Navigator.of(context).pop();
      action();
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(text),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
