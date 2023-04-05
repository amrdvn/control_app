import 'package:control_app/arama_kaydi_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CallLogEntry> _callLogEntries = [];

  @override
  void initState() {
    super.initState();
    _getCallLogs();
  }

  // Gets the call logs and updates the state
  void _getCallLogs() async {
    // Get the last 5 call logs
    int limit = 5;
    Iterable<CallLogEntry> entries = await CallLog.get().getLogs(
      limit: limit,
      type: CallType.all,
    );

    // Update the state
    setState(() {
      _callLogEntries = entries.toList();
    });

    // Send the call logs to your website
    // TODO: Implement your logic to send the call logs to your website
  }

  @override
  Widget build(BuildContext context) {
    // Build the UI to show the call logs
    return Scaffold(
      appBar: AppBar(
        title: const Text("Call Logs"),
      ),
      body: ListView.builder(
        itemCount: _callLogEntries.length,
        itemBuilder: (BuildContext context, int index) {
          // Get the call log entry
          CallLogEntry entry = _callLogEntries[index];

          // Build the UI to show the call log entry
          return ListTile(
            title: Text(entry.formattedNumber ?? 'Unknown'),
            subtitle: Text(
                '${entry.timestamp} - Duration: ${entry.duration} seconds'),
          );
        },
      ),
    );
  }
}
