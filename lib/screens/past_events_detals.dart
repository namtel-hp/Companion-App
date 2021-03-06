import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import '../models/student_data.dart';
import '../services/database.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/custom_appbar.dart';
import 'add_events.dart';

class PastEventDetails extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final DateFormat _dateFormat = DateFormat('hh:mm a, d MMM yyyy');

  final Event event;

  PastEventDetails({Key key, this.event}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bool _isAdmin =
        Provider.of<StudentData>(context, listen: false).isAdmin;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppBar(
          actions: _isAdmin
              ? [
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.check),
                    onPressed: () => customAlertDialog(
                        context: context,
                        title: 'Toggle Event!',
                        description:
                            'Are you sure you want to mark event unfinished?',
                        onOK: () async {
                          DatabaseService.toggleEvent(
                            id: event.id,
                            isFinished: !event.isFinished,
                          );
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }),
                  ),
                  const SizedBox(width: 5),
                ]
              : null,
          leading: IconButton(
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
              size: 30,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: 'Event',
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  textScaleFactor: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Event was On: ${_dateFormat.format(event.date)}',
                  textScaleFactor: 1.3,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  event.description,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.2,
                ),
                if (_isAdmin) ...[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.pen,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEvent(
                              event: event,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.trash,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () => customAlertDialog(
                          context: context,
                          title: 'Deleting Event!!!',
                          description:
                              'Are you sure you want to delete this event!?',
                          onOK: () {
                            DatabaseService.deleteEvent(id: event.id);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (event.participantsEmail.isNotEmpty)
                    Center(
                      child: FlatButton(
                        color: Theme.of(context).accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text: event.participantsEmail.join(',')));

                          _scaffoldKey.currentState.showSnackBar(const SnackBar(
                              content: Text(
                                  'Participants email have been copied to clipboard')));
                        },
                        child: const Text(
                          'Get Participants Email',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
