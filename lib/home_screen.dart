import 'package:age_calculator/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _todayDateController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();


  int year = 0;
  int months = 0;
  int days = 0;
  int liftMonths = 0;
  int liftDays = 0;
  int totalMonths = 0 ;
  int totalWeeks = 0;
  int totalDays = 0 ;
  int totalHours = 0;
  int totalMinutes = 0;
  int totalSeconds = 0;

// Date picker methods
  void _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      controller.text = DateFormat('dd-MM-yyyy')
          .format(pickedDate); // Format the date as needed
    }
  }

// Age Calculate Function
  void calculateAge(DateTime dob) {
    final now = DateTime.now();

    // Calculate age in years
    int years = now.year - dob.year;

    // Adjust for if the birthday hasn't occurred yet this year
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      years--;
    }

    // Calculate months
    int months = now.month - dob.month;
    if (now.day < dob.day) {
      months--;
    }

    // Adjust months if negative
    if (months < 0) {
      months += 12;
    }

    // Calculate days
    int days = now.day - dob.day;
    if (days < 0) {
      final lastMonth = DateTime(
          now.year, now.month, 0); // Get last day of the previous month
      days += lastMonth.day;
    }

    // Calculate total weeks, hours, minutes, and seconds
    int totalDays = years * 365 + months * 30 + days;
    int totalMonths = (years * 12) + months;
    int totalWeeks = (totalDays / 7).floor();
    int totalHours = totalDays * 24;
    int totalMinutes = totalHours * 60;
    int totalSeconds = totalMinutes * 60;

    setState(() {
      year = years;
      this.months = months;
      this.days = days;
      this.totalWeeks = totalWeeks;
      this.totalHours = totalHours;
      this.totalMinutes = totalMinutes;
      this.totalSeconds = totalSeconds;
      this.totalDays = totalDays ;
      this.totalMonths = totalMonths ;
    });
  }

// Method to calculate the next birthday
  void calculateNextBirthday(DateTime dob) {
    final now = DateTime.now();
    DateTime nextBirthday = DateTime(now.year, dob.month, dob.day);

    // If the birthday this year has already passed, move to next year
    if (nextBirthday.isBefore(now) || nextBirthday.isAtSameMomentAs(now)) {
      nextBirthday = DateTime(now.year + 1, dob.month, dob.day);
    }

    // Calculate remaining months and days
    int liftMonths = nextBirthday.month - now.month;
    int liftDays = nextBirthday.day - now.day;

    // If days are negative, borrow from the month
    if (liftDays < 0) {
      liftMonths--;
      final lastMonth = DateTime(nextBirthday.year, nextBirthday.month, 0);
      liftDays += lastMonth.day; // Get last day of the previous month
    }

    // If months are negative, add 12
    if (liftMonths < 0) {
      liftMonths += 12;
    }

    setState(() {
      this.liftMonths = liftMonths;
      this.liftDays = liftDays;
    });
  }

  @override
  void dispose() {
    _todayDateController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        title: const Text(
          "Age Calculator",
          style: TextStyle(
              fontSize: 28, fontFamily: "appFont", fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      body: SingleChildScrollView(
        // Wrap the main Column in SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Today's date",
                    style: TextStyle(fontSize: 20, fontFamily: "appFont"),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 2, color: appTextBorder),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              controller: _todayDateController,
                              readOnly: true,
                              style: const TextStyle(fontSize: 25 , fontFamily: "appFont" , fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _selectDate(context,
                              _todayDateController), // Open date picker
                          icon: const Icon(
                            Icons.date_range,
                            size: 35,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Date of birth",
                    style: TextStyle(fontSize: 20, fontFamily: "appFont"),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 2, color: appTextBorder),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              controller: _dobController,
                              readOnly: true,
                              style: const TextStyle(fontSize: 25 , fontFamily: "appFont" , fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _selectDate(
                              context, _dobController), // Open date picker
                          icon: const Icon(
                            Icons.date_range,
                            size: 35,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Clear Button
                      SizedBox(
                        width: 160,
                        height: 70,
                        child: ElevatedButton(
                          onPressed: () {
                            _dobController.clear();
                            _todayDateController.clear();
                            setState(() {
                              year = 0;
                              months = 0;
                              days = 0;
                              liftMonths = 0;
                              liftDays = 0;
                              totalMonths = 0 ;
                              totalDays = 0 ;
                              totalSeconds = 0 ;
                              totalMinutes = 0 ;
                              totalHours = 0 ;
                              totalWeeks = 0 ;

                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            side: const BorderSide(width: 2, color: Colors.red),
                          ),
                          child: const Text(
                            "Clear",
                            style: TextStyle(
                                fontFamily: "appFont",
                                color: Colors.red,
                                fontSize: 24),
                          ),
                        ),
                      ),
                      // Calculate Button
                      SizedBox(
                        width: 160,
                        height: 70,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_dobController.text.isNotEmpty) {
                              DateTime dob = DateFormat('dd-MM-yyyy')
                                  .parse(_dobController.text);
                              calculateAge(dob);
                              calculateNextBirthday(dob);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xf969fa97),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text(
                            "Calculate",
                            style: TextStyle(
                                fontFamily: "appFont",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: appLight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Total Age",
                      style: TextStyle(fontSize: 20, fontFamily: "appFont"),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 8,
                      color: appTextBorder,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Years",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: "appFont",
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black87,
                                          blurRadius: 1,
                                          offset: Offset(2.0, 2.0))
                                    ]),
                              ),
                              Text(
                                "$year",
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontFamily: "appFont",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black87,
                                          blurRadius: 1,
                                          offset: Offset(2.0, 2.0))
                                    ]),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Months",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: "appFont",
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black87,
                                          blurRadius: 1,
                                          offset: Offset(2.0, 2.0))
                                    ]),
                              ),
                              Text(
                                "$months",
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontFamily: "appFont",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black87,
                                          blurRadius: 1,
                                          offset: Offset(2.0, 2.0))
                                    ]),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Days",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: "appFont",
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black87,
                                          blurRadius: 1,
                                          offset: Offset(2.0, 2.0))
                                    ]),
                              ),
                              Text(
                                "$days",
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontFamily: "appFont",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black87,
                                          blurRadius: 1,
                                          offset: Offset(2.0, 2.0))
                                    ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Next Birthday

                    const SizedBox(height: 20),
                    const Text(
                      "Next Birthday",
                      style: TextStyle(fontSize: 20, fontFamily: "appFont"),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 8,
                      color: appTextBorder,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Months",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: "appFont",
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black87,
                                          blurRadius: 1,
                                          offset: Offset(2.0, 2.0))
                                    ]),
                              ),
                              Text(
                                "$liftMonths",
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontFamily: "appFont",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black87,
                                          blurRadius: 1,
                                          offset: Offset(2.0, 2.0))
                                    ]),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Days",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: "appFont",
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black87,
                                          blurRadius: 1,
                                          offset: Offset(2.0, 2.0))
                                    ]),
                              ),
                              Text(
                                "$liftDays",
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontFamily: "appFont",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black87,
                                          blurRadius: 1,
                                          offset: Offset(2.0, 2.0))
                                    ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Details

                    const SizedBox(height: 20),
                    const Text(
                      "Extra Details",
                      style: TextStyle(fontSize: 20, fontFamily: "appFont"),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: Colors.white),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Total Years
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Years",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "appFont"),
                                ),
                                Text(
                                  "$year",
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "appFont"),
                                ),
                              ],
                            ),
                          ),
                          // Total Months
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Months",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "appFont"),
                                ),
                                Text(
                                  "$totalMonths",
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "appFont"),
                                ),
                              ],
                            ),
                          ),

                          // Total Weeks
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Weeks",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "appFont"),
                                ),
                                Text(
                                  "$totalWeeks",
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "appFont"),
                                ),
                              ],
                            ),
                          ),
                          // Total Days
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Days",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "appFont"),
                                ),
                                Text(
                                  "$totalDays",
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "appFont"),
                                ),
                              ],
                            ),
                          ),

                          //   Total Hours
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Hours",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "appFont"),
                                ),
                                Text(
                                  "$totalHours",
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "appFont"),
                                ),
                              ],
                            ),
                          ),
                          //   Total Minutes
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Minutes",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "appFont"),
                                ),
                                Text(
                                  "$totalMinutes",
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "appFont"),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Seconds",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "appFont"),
                                ),
                                Text(
                                  "$totalSeconds",
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "appFont"),
                                ),
                              ],
                            ),
                          ),
                          //   Total second
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
