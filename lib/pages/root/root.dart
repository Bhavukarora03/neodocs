import 'package:flutter/material.dart';
import 'package:neodocs/components/range_bar.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<double> userValue = ValueNotifier<double>(0.0);

  final List<RangeSection> sections = const [
    RangeSection(min: 0, max: 20, color: Colors.red, label: 'Dangerous'),
    RangeSection(min: 20, max: 40, color: Colors.orange, label: 'Moderate'),
    RangeSection(min: 40, max: 60, color: Colors.green, label: 'Ideal'),
    RangeSection(min: 60, max: 70, color: Colors.orange, label: 'Moderate'),
    RangeSection(min: 70, max: 120, color: Colors.red, label: 'Dangerous'),

  ];


  void onSubmitted(String value) {
    final double inputValue = double.tryParse(value) ?? 0.0;
    final isValid = sections.any((section) => inputValue >= section.min && inputValue <= section.max);
    if (isValid) {
      userValue.value = inputValue;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Invalid input. Please enter a value within the range.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NeoDocs - Task by Bhavuk'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 10,
              width:  MediaQuery.of(context).size.width * 0.9,
              child: ValueListenableBuilder<double>(
                valueListenable: userValue,
                builder: (context, value, child) {
                  return BarWidget(
                    sections: sections,
                    userValue: value,
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter a number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                    onSubmitted: onSubmitted,
                  ),
                ),
                IconButton(
                  onPressed: () => onSubmitted(_controller.text),
                  iconSize: 40.0,
                  icon: const Icon(Icons.arrow_circle_right_outlined),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
