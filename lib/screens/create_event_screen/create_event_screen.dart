import 'package:evently_app/core/theme/app_colors.dart';
import 'package:evently_app/models/task_model.dart';
import 'package:evently_app/providers/create_event_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/theme/base_theme.dart';
import '../../models/fire_base/firebase_manager.dart';
import '../../providers/my_provider.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/picker_location_widget.dart' show PickerLocationWidget;
import '../home_screen/tabs/map_tab/map_tab.dart';

class CreateEventScreen extends StatefulWidget {
  final TaskModel? task;
  static const String routeName = "CreateEvent";

  const CreateEventScreen({super.key, this.task});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  var selectedDate;
  var selectedTime;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late TextEditingController locationController;

  String? titleError;
  String? descriptionError;
  String? dateError;
  String? timeError;
  String? locationError;
  String buttonText = "Add Event";
  String labelText = "Choose Event Location";
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();

    locationController = TextEditingController();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      selectedDate = widget.task!.date;

      if (widget.task!.time != null) {
        final parts = widget.task!.time.split(RegExp(r'[: ]'));
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);
        if (parts[2] == 'PM' && hour != 12) hour += 12;
        selectedTime = TimeOfDay(hour: hour, minute: minute);
      }
      locationController.text = widget.task!.location;
      labelText = widget.task!.location;

      buttonText = "Update Event";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          CreateEventProvider()
            ..selectedCategory = widget.task?.categoryIndex ?? 0,

      builder: (context, child) {
        var provider = Provider.of<MyProvider>(context);
        var eventProvider = Provider.of<CreateEventProvider>(context);

        final bool isDark = provider.themeMode == ThemeMode.dark;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: isDark
                ? BaseTheme.dark.scaffoldBackgroundColor
                : BaseTheme.light.scaffoldBackgroundColor,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: isDark
                  ? BaseTheme.dark.scaffoldBackgroundColor
                  : BaseTheme.light.scaffoldBackgroundColor,
              centerTitle: true,
              title: const Text(
                "Create Event",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              iconTheme: const IconThemeData(color: AppColors.primary),
            ),
            backgroundColor: isDark
                ? BaseTheme.dark.scaffoldBackgroundColor
                : BaseTheme.light.scaffoldBackgroundColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Image.asset(
                              eventProvider.eventCategories[eventProvider
                                  .selectedCategory]["image"]!,
                              key: ValueKey(eventProvider.selectedCategory),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                          ),
                          if (eventProvider.isLoading)
                            Container(
                              color: Colors.black.withOpacity(0.3),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              eventProvider.selectCategory(index);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              alignment: Alignment.center,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: eventProvider.selectedCategory == index
                                    ? AppColors.primary
                                    : Colors.transparent,
                                border: Border.all(color: AppColors.primary),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    eventProvider
                                        .eventCategories[index]["icon"]!,
                                    height: 20,
                                    width: 20,
                                    color:
                                        eventProvider.selectedCategory ==
                                                index &&
                                            isDark
                                        ? BaseTheme.dark.scaffoldBackgroundColor
                                        : eventProvider.selectedCategory ==
                                                  index &&
                                              !isDark
                                        ? BaseTheme
                                              .light
                                              .scaffoldBackgroundColor
                                        : AppColors.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    eventProvider
                                        .eventCategories[index]["name"]!,
                                    style: TextStyle(
                                      color:
                                          eventProvider.selectedCategory ==
                                                  index &&
                                              isDark
                                          ? BaseTheme
                                                .dark
                                                .scaffoldBackgroundColor
                                          : eventProvider.selectedCategory ==
                                                    index &&
                                                !isDark
                                          ? BaseTheme
                                                .light
                                                .scaffoldBackgroundColor
                                          : AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 16),
                        itemCount: eventProvider.eventCategories.length,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          "Title",
                          style: GoogleFonts.inter(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 361,
                          height: 56,
                          child: TextFormField(
                            controller: titleController,
                            style: GoogleFonts.inter(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            cursorColor: AppColors.primary,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Image.asset(
                                  "assets/images/Note_Edit.png",
                                  color: isDark
                                      ? AppColors.white
                                      : const Color(0xFF7B7B7B),
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              hintText: "Event Title",
                              hintStyle: GoogleFonts.inter(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF7B7B7B),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).unfocus(),
                          ),
                        ),
                        if (titleError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 12),
                            child: Text(
                              titleError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),

                        // Description
                        Text(
                          "Description",
                          style: GoogleFonts.inter(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 361,
                          height: 127,
                          child: TextFormField(
                            controller: descriptionController,
                            style: GoogleFonts.inter(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            cursorColor: AppColors.primary,
                            maxLines: null,
                            minLines: 5,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).unfocus(),
                            decoration: InputDecoration(
                              hintText: "Event Description",
                              hintStyle: GoogleFonts.inter(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF7B7B7B),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        if (descriptionError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 12),
                            child: Text(
                              descriptionError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),

                        // Date
                        Row(
                          children: [
                            ImageIcon(
                              const AssetImage(
                                "assets/images/Calendar_Days.png",
                              ),
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "Event Date",
                              style: GoogleFonts.inter(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () async {
                                var date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now().subtract(
                                    const Duration(days: 365),
                                  ),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                );
                                if (date != null) {
                                  setState(() => selectedDate = date);
                                }
                              },
                              child: Text(
                                selectedDate == null
                                    ? "Choose Date"
                                    : "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                                style: GoogleFonts.inter(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (dateError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 12),
                            child: Text(
                              dateError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),

                        // Time
                        Row(
                          children: [
                            ImageIcon(
                              const AssetImage("assets/images/Clock.png"),
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "Event Time",
                              style: GoogleFonts.inter(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () async {
                                var time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setState(() => selectedTime = time);
                                }
                              },
                              child: Text(
                                selectedTime == null
                                    ? "Choose Time"
                                    : "${selectedTime.hourOfPeriod.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')} ${selectedTime.period == DayPeriod.am ? 'AM' : 'PM'}",
                                style: GoogleFonts.inter(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (timeError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 12),
                            child: Text(
                              timeError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),

                        // Location
                        Text(
                          "Location",
                          style: GoogleFonts.inter(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5),

                        PickerLocationWidget(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MapTab(fromCreatePage: true),
                              ),
                            );

                            if (result != null) {
                              List<Placemark> place =
                                  await placemarkFromCoordinates(
                                    result.latitude,
                                    result.longitude,
                                  );

                              String city = place[0].locality ?? "";
                              String country = place[0].country ?? "";

                              setState(() {
                                selectedLocation = result;
                                labelText = "$city, $country";
                                locationController.text = "$city, $country";
                              });
                            }
                          },

                          label: labelText,
                        ),

                        SizedBox(height: 20),
                        Button_Widget(
                          text: buttonText,
                          onPressed: () async {
                            setState(() {
                              titleError = titleController.text.trim().isEmpty
                                  ? "Title is required"
                                  : null;

                              descriptionError =
                                  descriptionController.text.trim().isEmpty
                                  ? "Description is required"
                                  : null;

                              dateError = selectedDate == null
                                  ? "Date is required"
                                  : null;
                              timeError = selectedTime == null
                                  ? "Time is required"
                                  : null;
                            });

                            if (titleError != null ||
                                descriptionError != null ||
                                dateError != null ||
                                timeError != null) {
                              return;
                            }

                            String formattedTime =
                                "${selectedTime.hourOfPeriod.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')} ${selectedTime.period == DayPeriod.am ? 'AM' : 'PM'}";

                            TaskModel model = TaskModel(
                              id: widget.task?.id,
                              userId: FirebaseAuth.instance.currentUser!.uid,
                              title: titleController.text.trim(),
                              description: descriptionController.text.trim(),
                              categoryIndex: eventProvider.selectedCategory,
                              category:
                                  eventProvider.eventCategories[eventProvider
                                      .selectedCategory]['name']!,

                              date: selectedDate,
                              time: formattedTime,
                              location: locationController.text.trim(),
                            );

                            if (widget.task == null) {
                              await FirebaseManager.addEvent(model);
                              setState(() => buttonText = "Event Added ✅");
                            } else {
                              await FirebaseManager.updateTask(model);

                              setState(() => buttonText = "Event Updated ✅");
                            }

                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.pop(context);
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 💬 Toast-style message in center of screen
void showCustomMessage(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  OverlayEntry? overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height * 0.45,
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 250),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isError
                    ? Colors.redAccent
                    : Colors.black.withOpacity(0.85),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isError
                        ? Icons.error_outline_rounded
                        : Icons.check_circle_outline_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Overlay.of(context).insert(overlayEntry!);

  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry?.remove();
  });
}
