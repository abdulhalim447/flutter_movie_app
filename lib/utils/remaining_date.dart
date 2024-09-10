
import 'package:flutter/material.dart';

import '../models/remaining_date.dart';

class RemainingDate extends StatelessWidget {
  const RemainingDate({
    super.key,
    required this.futureDate,
  });

  final Future<GetDate?> futureDate;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetDate?>(
      future: futureDate,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // Check if data is available and display it
          GetDate? dateData = snapshot.data;
          return Center(
            child: Text(
                dateData?.remainingDate ?? 'N/A',
              style: TextStyle(fontSize: 24,color: Colors.amber),
            ),
          );
        } else {
          return Center(child: Text('No data available.'));
        }
      },
    );
  }
}
