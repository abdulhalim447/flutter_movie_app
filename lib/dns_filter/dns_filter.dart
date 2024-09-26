import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import 'package:flutter/services.dart'; // For clipboard
import 'package:url_launcher/url_launcher.dart'; // For opening settings

class DnsTutorialPage extends StatefulWidget {
  const DnsTutorialPage({super.key});

  @override
  State<DnsTutorialPage> createState() => _DnsTutorialPageState();
}

class _DnsTutorialPageState extends State<DnsTutorialPage> {
  int currentStep = 0;

  continueStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep = currentStep + 1; //currentStep+=1;
      });
    }
  }

  cancelStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep = currentStep - 1; //currentStep-=1;
      });
    }
  }

  onStepTapped(int value) {
    setState(() {
      currentStep = value;
    });
  }

  Widget controlBuilders(context, details) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: details.onStepContinue,
            child: const Text('Next'),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: details.onStepCancel,
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stepper(
        elevation: 0,
        //Horizontal Impact
        // margin: const EdgeInsets.all(20), //vertical impact
        controlsBuilder: controlBuilders,
        type: StepperType.vertical,
        physics: const ScrollPhysics(),
        onStepTapped: onStepTapped,
        onStepContinue: continueStep,
        onStepCancel: cancelStep,
        currentStep: currentStep,
        //0, 1, 2
        steps: [
          Step(
              title: const Text('Step 1'),
              content: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Copy the link',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 10),
                      Text('Touch the below box to copy'),
                      SizedBox(height: 10),
                      Container(
                        height: 70,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: 'dns.adguard.com'));

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Copied to clipboard!')),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('dns.adguard.com'),
                                  SizedBox(width: 45),
                                  Icon(Icons.copy),
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
              isActive: currentStep >= 0,
              state:
                  currentStep >= 0 ? StepState.complete : StepState.disabled),
          Step(
            title: const Text('Step 2'),
            content: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ineternet Settings',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 10),
                    Text(
                      ' Follow the direction',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 10),
                    Text(' => Open your phone settings'),
                    SizedBox(height: 10),
                    Text(' => Click on the search bar'),
                    SizedBox(height: 10),
                    Text(' => Type Private DNS'),
                    SizedBox(height: 10),
                    Text(' => Select the private DNS provider hostname '),
                    SizedBox(height: 10),
                    Text(' => Past the copied code in below box'),
                    SizedBox(height: 10),
                    Text(' => Save'),
                    SizedBox(height: 50),
                    GestureDetector(
                      onTap: () async {
                        const url =
                            'https://www.youtube.com/shorts/xFOsmGcKY6A';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not open $url';
                        }
                      },
                      child: Text(
                        'Watch Video tutorial',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            isActive: currentStep >= 0,
            state: currentStep >= 1 ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: const Text('Step 3'),
            content: GestureDetector(
              onTap: () async {
                try {
                  final intent = AndroidIntent(
                    action: 'android.settings.SETTINGS',
                  );
                  await intent.launch();


                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                          (Route<dynamic> route) => false,
                    );
                  });
                } catch (e) {
                  print('Error opening device settings: $e');
                }
              },
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'Open your Phone settings',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            isActive: currentStep >= 0,
            state: currentStep >= 2 ? StepState.complete : StepState.disabled,
          ),


        ],
      ),
    );
  }
}
