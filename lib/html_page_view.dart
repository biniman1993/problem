import 'package:appone/appbar.dart';
import 'package:appone/home2.dart';
import 'package:appone/listoftimhirt.dart';
import 'package:appone/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';

class HtmlPageView extends StatefulWidget {
  final int startIndex;
  final List<String> titles;

  const HtmlPageView({
    super.key,
    required this.startIndex,
    required this.titles,
  });

  @override
  State<HtmlPageView> createState() => _HtmlPageViewState();
}

class _HtmlPageViewState extends State<HtmlPageView> {
  late final PageController _controller;
  late final PanelController _panelController;
  List<String> htmlContents = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.startIndex;
    _controller = PageController(initialPage: widget.startIndex);
    _panelController = PanelController();
    loadAllHtmlPages();
  }

  Future<void> loadAllHtmlPages() async {
    List<String> contents = [];
    for (int i = 1; i <= widget.titles.length; i++) {
      final filePath = 'assets/html/page_$i.html';
      try {
        final content = await rootBundle.loadString(filePath);
        contents.add(content);
      } catch (_) {
        contents.add('<p>Page $i not found.</p>');
      }
    }
    setState(() {
      htmlContents = contents;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSettingsPanel() {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Container(
          decoration: BoxDecoration(
            color: settings.isDarkMode ? Colors.grey[900] : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Panel Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              // Settings Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Text Settings',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: settings.textColor,
                          fontFamily: 'GeezMahtem',
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Font Size Slider
                      Text(
                        'Font Size: ${settings.fontSize.toInt()}',
                        style: TextStyle(
                          fontSize: 16,
                          color: settings.textColor,
                          fontFamily: 'GeezMahtem',
                        ),
                      ),
                      Slider(
                        value: settings.fontSize,
                        min: 12,
                        max: 32,
                        divisions: 20,
                        activeColor: const Color.fromARGB(255, 55, 67, 138),
                        onChanged: settings.setFontSize,
                      ),
                      const SizedBox(height: 20),
                      
                      // Line Height Slider
                      Text(
                        'Line Height: ${settings.lineHeight.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: settings.textColor,
                          fontFamily: 'GeezMahtem',
                        ),
                      ),
                      Slider(
                        value: settings.lineHeight,
                        min: 1.0,
                        max: 2.5,
                        divisions: 15,
                        activeColor: const Color.fromARGB(255, 55, 67, 138),
                        onChanged: settings.setLineHeight,
                      ),
                      const SizedBox(height: 20),
                      
                      // Font Family Dropdown
                      Text(
                        'Font Family:',
                        style: TextStyle(
                          fontSize: 16,
                          color: settings.textColor,
                          fontFamily: 'GeezMahtem',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(8),
                          color: settings.isDarkMode ? Colors.grey[800] : Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: settings.fontFamily,
                            style: TextStyle(
                              color: settings.textColor,
                              fontSize: 16,
                            ),
                            dropdownColor: settings.isDarkMode ? Colors.grey[800] : Colors.white,
                            items: settings.fontOptions
                                .map((font) => DropdownMenuItem(
                                      value: font,
                                      child: Text(
                                        font,
                                        style: TextStyle(
                                          fontFamily: font,
                                          color: settings.textColor,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                settings.setFontFamily(value);
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Dark Mode Switch
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dark Mode:',
                            style: TextStyle(
                              fontSize: 16,
                              color: settings.textColor,
                              fontFamily: 'GeezMahtem',
                            ),
                          ),
                          Switch(
                            value: settings.isDarkMode,
                            activeColor: const Color.fromARGB(255, 55, 67, 138),
                            onChanged: settings.setDarkMode,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      
                      // Reset Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: settings.resetToDefaults,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 55, 67, 138),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Reset to Defaults',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'GeezMahtem',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          drawer: const Mybar(),
          backgroundColor: settings.backgroundColor,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 255, 255, 255),
                    Color.fromARGB(255, 20, 32, 104),
                  ],
                ),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 7.0),
              child: Text(
                widget.titles[currentIndex],
                style: const TextStyle(
                  fontFamily: 'GeezMahtem',
                  fontSize: 25,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                  top: 10,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: IconButton(
                    iconSize: 25.0,
                    onPressed: () {
                      _panelController.open();
                    },
                    icon: const Icon(Icons.text_fields),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 3.85,
                colors: [
                  Color.fromARGB(255, 46, 55, 109),
                  Color.fromARGB(255, 253, 253, 255),
                ],
                stops: [0.9, 4.0],
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              elevation: 0,
              onTap: (index) {
                if (index == 1) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const Photos(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            const begin = Offset(-1.0, 0.0);
                            const end = Offset.zero;
                            final tween = Tween(
                              begin: begin,
                              end: end,
                            ).chain(CurveTween(curve: Curves.easeInOut));
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                      transitionDuration: const Duration(milliseconds: 600),
                    ),
                  );
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const ScrollableListView(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                      transitionDuration: const Duration(milliseconds: 500),
                    ),
                  );
                } else if (index == 3) {
                  // Settings button - open the panel
                  _panelController.open();
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.auto_stories),
                  label: 'Read',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Help'),
              ],
            ),
          ),
          body: SlidingUpPanel(
            controller: _panelController,
            panel: _buildSettingsPanel(),
            minHeight: 0,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            backdropEnabled: true,
            backdropOpacity: 0.3,
            parallaxEnabled: true,
            parallaxOffset: 0.1,
            body: htmlContents.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      color: settings.isDarkMode ? Colors.white : Colors.black,
                    ),
                  )
                : PageView.builder(
                    controller: _controller,
                    itemCount: widget.titles.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return SafeArea(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(14, 4, 8, 2),
                          child: Html(
                            data: htmlContents[index],
                            style: {
                              "body": Style(
                                fontSize: FontSize(settings.fontSize),
                                lineHeight: LineHeight.number(settings.lineHeight),
                                fontFamily: settings.fontFamily,
                                color: settings.textColor,
                                backgroundColor: settings.backgroundColor,
                              ),
                              "li": Style(
                                fontSize: FontSize(settings.fontSize * 0.9),
                                color: settings.textColor,
                                fontFamily: settings.fontFamily,
                              ),
                              "h2": Style(
                                margin: Margins.only(bottom: 1),
                                padding: HtmlPaddings.symmetric(vertical: 4.0),
                                fontSize: FontSize(settings.fontSize * 1.4),
                                color: settings.headingColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: settings.fontFamily,
                              ),
                              "p": Style(
                                textAlign: TextAlign.justify,
                                margin: Margins.only(top: 0),
                                fontSize: FontSize(settings.fontSize),
                                fontFamily: settings.fontFamily,
                                color: settings.textColor,
                                lineHeight: LineHeight.number(settings.lineHeight),
                              ),
                              "ul": Style(
                                margin: Margins.only(bottom: 1),
                                lineHeight: LineHeight.number(settings.lineHeight * 0.9),
                                padding: HtmlPaddings.symmetric(vertical: 2.0),
                                fontSize: FontSize(settings.fontSize),
                                color: settings.textColor,
                                fontFamily: settings.fontFamily,
                              ),
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}