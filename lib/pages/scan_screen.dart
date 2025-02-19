import 'dart:convert';
import 'dart:io';
import 'package:ecosort/pages/scan_result.dart';
import 'package:ecosort/providers/question_answer_provider.dart';
import 'package:flutter/material.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/category_provider.dart';
import '../providers/question_provider.dart';
import '../widgets/modal_bottom_shett.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  bool isThinking = false;

  @override
  Widget build(BuildContext context) {
    final gemini = Gemini.instance;

    return FutureBuilder(
        future: fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CameraAwesomeBuilder.custom(
              imageAnalysisConfig: AnalysisConfig(
                  androidOptions: AndroidAnalysisOptions.nv21(width: 150)),
              sensorConfig: SensorConfig.single(
                  sensor: Sensor.position(
                SensorPosition.back,
              )), // Added thi: true,
              builder: (CameraState state, Preview preview) {
                return Stack(
                  children: [
                    Positioned.fill(
                        child: Container()), // Ensure camera preview is visible
                    Positioned(
                      bottom: 30,
                      left: 30,
                      right: 30,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isThinking = true;
                          });
                          if (state is PhotoCameraState) {
                            try {
                              final cameraState = state;
                              final CaptureRequest request =
                                  await cameraState.takePhoto();

                              final File file = File(
                                  request.path == null ? '' : request.path!);

                              gemini.chat(
                                  generationConfig: GenerationConfig(
                                    temperature: 0.8,
                                    maxOutputTokens: 512,
                                  ),
                                  [
                                    Content(parts: [
                                      Part.bytes(file.readAsBytesSync()),
                                      Part.text(
                                          "Create a JSON with name and category for waste segregation, "
                                          "possible categories are ${snapshot.data?.join(', ')} "
                                          "like {name: 'bottle', category : 'Glass'}"
                                          " if you are not sure for category use Null "
                                          "only for the item in Foreground only return one result no list of items"),
                                    ])
                                  ]).then((value) async {
                                String result = value?.output
                                        ?.replaceAll('json', '')
                                        .replaceAll("`", "") ??
                                    '';

                                Map<String, dynamic> jsonMap =
                                    jsonDecode(result);

                                int detectedCategoryId = snapshot.data
                                        ?.where((element) =>
                                            element.name.toLowerCase() ==
                                            jsonMap['category']
                                                .toString()
                                                .toLowerCase())
                                        .first
                                        .id ??
                                    0;
                                Question? fetchedQuestions =
                                    await fetchQuestion(
                                        categoryId: detectedCategoryId);

                                if (detectedCategoryId != 0 &&
                                    fetchedQuestions != null) {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return QuestionModalBottomSheet(
                                        question: fetchedQuestions.text ?? '',
                                        description:
                                           fetchedQuestions.description ?? '',
                                      );
                                    },
                                  );
                                } else if (detectedCategoryId != 0) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ScanResultScreen(
                                          categoryId: detectedCategoryId,
                                          categoryName: jsonMap['name'],
                                        ),
                                      ));
                                }

                                setState(() {
                                  isThinking = false;
                                });
                              });
                            } catch (error) {
                              setState(() {
                                isThinking = false;
                              });
                              SnackBar(
                                content: Text(error.toString()),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              );
                            }
                          } else {}
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.white.withOpacity(0.7),
                        ),
                        child: isThinking
                            ? CircularProgressIndicator()
                            : const Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.black,
                              ),
                      ),
                    ),
                  ],
                );
              },
              saveConfig: SaveConfig.photo(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading categories'));
          }
          return CircularProgressIndicator();
        });
  }
}

void showError(BuildContext context, String message) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  });
}
