import 'package:flutter/material.dart';
import 'component_registry.dart';
import 'component_metadata.dart';
import 'package:designkit/components/atoms/glass_container.dart';

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  ComponentMetadata? selectedComponent;
  Map<String, dynamic> currentProps = {};
  bool isMobile = true;
  final Map<String, TextEditingController> _controllers = {};
  int _refreshCounter = 0;
  
  // Track expansion state for categories
  final Map<String, bool> _expandedCategories = {
    "Atoms": false,
    "Molecules": false,
    "Organisms": false,
    "Pages": false,
  };

  @override
  void initState() {
    super.initState();
    if (componentRegistry.isNotEmpty) {
      selectedComponent = componentRegistry.first;
      currentProps = Map.from(selectedComponent!.defaultProps);
      _updateControllers();
    }
  }

  void _updateControllers() {
    // Clear existing if needed, or just update
    _controllers.forEach((key, controller) => controller.dispose());
    _controllers.clear();
    
    currentProps.forEach((key, value) {
      if (value is String) {
        _controllers[key] = TextEditingController(text: value);
      } else if (value is double || value is int) {
        _controllers[key] = TextEditingController(
          text: value is double ? value.toStringAsFixed(2) : value.toString(),
        );
      }
    });
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6), Color(0xFF1D4ED8)], // More vibrant blue gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            _header(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Sidebar
                  Container(
                    width: 400,
                    decoration: BoxDecoration(
                      border: Border(right: BorderSide(color: Colors.white.withAlpha(25), width: 1)),
                    ),
                    child: _sidebar(),
                  ),
                  // Preview
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: Colors.white.withAlpha(25), width: 1)),
                      ),
                      child: _preview(),
                    ),
                  ),
                  // Properties
                  SizedBox(
                    width: 400,
                    child: _properties(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _header() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        border: Border(bottom: BorderSide(color: Colors.white.withAlpha(25), width: 1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFF40B4), size: 28),
          const SizedBox(width: 12),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: "Design System Playground  ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "Netbanking Login - Glassmorphism - Atomic Design",
                  style: TextStyle(color: Colors.white.withAlpha(153), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= SIDEBAR =================

  Widget _sidebar() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "COMPONENTS",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 20,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          _categoryGlassContainer("Pages"),
          const SizedBox(height: 20),
          _categoryGlassContainer("Atoms"),
          const SizedBox(height: 20),
          _categoryGlassContainer("Molecules"),
          const SizedBox(height: 20),
          _categoryGlassContainer("Organisms"),
        ],
      ),
    );
  }

  Widget _categoryGlassContainer(String category) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      opacity: 0.05,
      borderRadius: BorderRadius.circular(16),
      child: _category(category),
    );
  }

  Widget _category(String category) {
    final items = componentRegistry
        .where((c) => c.category == category)
        .toList();
    final bool isExpanded = _expandedCategories[category] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expandedCategories[category] = !isExpanded),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0 : -0.25,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 26),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Column(
            children: [
              if (items.isEmpty)
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    "No components",
                    style: TextStyle(color: Colors.white24, fontSize: 12),
                  ),
                )
              else
                ...items.map(
                  (c) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      dense: false,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      title: Text(
                        c.name,
                        style: TextStyle(
                          color: selectedComponent?.name == c.name ? Colors.white : Colors.white60,
                          fontSize: 20,
                          fontWeight: selectedComponent?.name == c.name ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: selectedComponent?.name == c.name,
                      selectedTileColor: Colors.white.withAlpha(25),
                       onTap: () {
                        setState(() {
                          selectedComponent = c;
                          currentProps = Map.from(c.defaultProps);
                          _updateControllers();
                          _refreshCounter++;
                        });
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 8),
            ],
          ),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }

  // ================= PREVIEW =================

  Widget _preview() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Component Name and Category
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedComponent?.name ?? "Select Component",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selectedComponent?.category ?? "",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Mobile Indicator (just a label now)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: const [
                    Icon(Icons.phone_iphone, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Mobile View",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Component Preview
          Expanded(
            child: GlassContainer(
              padding: EdgeInsets.zero,
              opacity: 0.05,
              borderRadius: BorderRadius.circular(24),
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: selectedComponent == null
                        ? const Text(
                            "Select Component to Preview",
                            style: TextStyle(color: Colors.white38),
                          )
                        : AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            width: isMobile ? 375 : null,
                            height: isMobile ? 667 : null,
                            decoration: BoxDecoration(
                              color: isMobile ? Colors.black.withOpacity(0.5) : Colors.transparent,
                              borderRadius: BorderRadius.circular(isMobile ? 24 : 0),
                              border: isMobile ? Border.all(color: Colors.white24, width: 2) : null,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Center(
                              key: ValueKey("${selectedComponent!.name}_$_refreshCounter"),
                              child: selectedComponent!.builder(currentProps),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  // ================= PROPERTIES =================

  Widget _properties() {
    if (selectedComponent == null) return const SizedBox();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "PROPERTIES",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  letterSpacing: 1.2,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.white70, size: 20),
                onPressed: () {
                  setState(() {
                    currentProps = Map.from(selectedComponent!.defaultProps);
                    _updateControllers();
                    _refreshCounter++;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Render all properties dynamically
          ...currentProps.entries.map((entry) {
            final key = entry.key;
            final value = entry.value;

            if (value is bool) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _propertyBoolInput(_capitalize(key), key),
              );
            } else if (value is double || value is int) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _propertyNumericInput(_capitalize(key), key),
              );
            } else if (value is Color) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _propertyColorInput(_capitalize(key), key),
              );
            } else if (value is String) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _propertyTextInput(_capitalize(key), key),
              );
            } else if (value is FontWeight) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _propertyFontWeightInput(_capitalize(key), key),
              );
            }
            return const SizedBox();
          }),

          const SizedBox(height: 16),
          _propertyGroup(
            title: "Component Info",
            children: [
              _infoRow("Name", selectedComponent?.name ?? ""),
              _infoRow("Category", selectedComponent?.category ?? ""),
              _infoRow("Props", currentProps.length.toString()),
            ],
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  Widget _propertyGroup({required String title, required List<Widget> children}) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      opacity: 0.05,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _propertyBoolInput(String label, String key) {
    return SwitchListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 18)),
      value: currentProps[key] ?? false,
      onChanged: (val) => setState(() => currentProps[key] = val),
      activeColor: const Color(0xFFFF40B4),
    );
  }

  Widget _propertyTextInput(String label, String key) {
    bool disabled = currentProps["disabled"] ?? false;
    final controller = _controllers[key];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 8),
        TextField(
          enabled: !disabled,
          style: TextStyle(
            color: disabled ? Colors.white38 : Colors.white,
            fontSize: 18,
          ),
          controller: controller,
          onChanged: (val) => setState(() => currentProps[key] = val),
          decoration: _inputDecoration(),
        ),
      ],
    );
  }

  Widget _propertyNumericInput(String label, String key) {
    bool disabled = currentProps["disabled"] ?? false;
    final value = (currentProps[key] ?? 0.0).toDouble();
    final controller = _controllers[key];
    
    // Determine bounds based on key name
    double min = 0;
    double max = 1000;
    if (key.toLowerCase().contains("opacity")) max = 1.0;
    if (key.toLowerCase().contains("radius")) max = 100.0;
    if (key.toLowerCase().contains("offset")) {
      min = -500;
      max = 500;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white54, fontSize: 15)),
            SizedBox(
              width: 60,
              height: 24,
              child: TextField(
                enabled: !disabled,
                controller: controller,
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (val) {
                  final parsedValue = double.tryParse(val);
                  if (parsedValue != null) {
                    setState(() {
                      currentProps[key] = parsedValue.clamp(min, max);
                    });
                  }
                },
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            onChanged: disabled ? null : (val) {
              setState(() {
                currentProps[key] = val;
                if (controller != null) {
                  controller.text = max == 1.0 ? val.toStringAsFixed(2) : val.toInt().toString();
                }
              });
            },
            activeColor: const Color(0xFFFF40B4),
            inactiveColor: Colors.white10,
          ),
        ),
      ],
    );
  }

  Widget _propertyColorInput(String label, String key) {
    final Color currentColor = currentProps[key] ?? Colors.white;
    
    // Define color presets with banking-friendly palette
    final List<Color> presets = [
      // Default HDFC colors
      const Color.fromARGB(255, 174, 195, 215),
      const Color.fromARGB(255, 141, 177, 231),
      const Color.fromARGB(255, 200, 220, 240),
      // HDFC Blue shades
      const Color(0xFF2938AD),
      const Color(0xFF5371F9),
      const Color.fromARGB(255, 32, 66, 255),
      // Additional professional colors
      const Color(0xFFFF40B4),
      Colors.white,
      Colors.black,
      Colors.grey,
      Colors.red,
      Colors.green,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 12),
        // Color presets
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: presets.map((color) {
            final isSelected = color.value == currentColor.value;
            return GestureDetector(
              onTap: () => setState(() => currentProps[key] = color),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.white24,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: Colors.white.withAlpha(128),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        // Custom color input with hex
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(13),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: currentColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '#${currentColor.value.toRadixString(16).substring(2).toUpperCase()}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 15)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      filled: true,
      fillColor: Colors.black12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _propertyFontWeightInput(String label, String key) {
    final FontWeight currentWeight = currentProps[key] ?? FontWeight.normal;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 15)),
        const SizedBox(height: 8),
        Row(
          children: [
            _weightOption("Normal", FontWeight.normal, currentWeight == FontWeight.normal, key),
            const SizedBox(width: 8),
            _weightOption("Bold", FontWeight.bold, currentWeight == FontWeight.bold, key),
          ],
        ),
      ],
    );
  }

  Widget _weightOption(String label, FontWeight weight, bool isSelected, String key) {
    return GestureDetector(
      onTap: () => setState(() => currentProps[key] = weight),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF40B4) : Colors.white10,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white60,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
