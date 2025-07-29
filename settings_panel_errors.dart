import 'package:flutter/material.dart';

class SettingsPanel extends StatefulWidget {
  const SettingsPanel({Key? key}) : super(key: key);

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  String _fontSize = 16; // Error: Should be double, not String
  double _lineHeight = 1.5;
  bool _isDarkMode = false;
  String _fontFamily = 'GeezMahtem';

  final List<String> _fontOptions = [
    'GeezMahtem',
    'Roboto',
    'Arial',
    'NotoSans'  // Missing comma
  ];

  final panelController = SlidingUpPanelController(); // Error: Undefined class

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      body: SlidingUpPanelWidget( // Error: Undefined widget
        child: _buildMainContent(),
        controlHeight: 50,
        anchor: 0.4,
        panelController: panelController,
        enableOnTap: true,
        panelBuilder: (sc) => _buildSettingsPanel(sc),
      ),
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: Text(
        'እዚህ ጽሑፍ ነው።',
        style: TextStyle(
          fontSize: _fontSize, // Error: _fontSize is String, should be double
          height: _lineHeight,
          fontFamily: _fontFamily,
          color: _isDarkMode ? Colors.white : Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSettingsPanel(ScrollController sc) {
    return Material(
      elevation: 12,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SingleChildScrollView(
        controller: sc,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Font Size: ${_fontSize.toStringAsFixed(0)}'), // Error: toStringAsFixed on String
            Slider(
              value: _fontSize, // Error: value expects double, but _fontSize is String
              min: 10,
              max: 40,
              onChanged: (value) {
                setState(() => _fontSize = value); // Error: assigning double to String
              },
            ),
            const SizedBox(height: 10),
            Text('Line Height: ${_lineHeight.toStringAsFixed(1)}'),
            Slider(
              value: _lineHeight,
              min: 1,
              max: 3,
              onChanged: (value) {
                setState(() => _lineHeight = value);
              },
            ),
            const SizedBox(height: 10),
            const Text('Font Type:'),
            DropdownButton<String>(
              value: _fontFamily,
              items: _fontOptions
                  .map((font) => DropdownMenuItem(
                        value: font,
                        child: Text(font),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _fontFamily = value);
                }
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Dark Mode:'),
                Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() => _isDarkMode = value);
                  },
                ),
              ],
            ),
            // Missing closing bracket for children array
            // Missing closing brace for Column
            // Missing closing parenthesis for SingleChildScrollView
            // Missing closing parenthesis for Material