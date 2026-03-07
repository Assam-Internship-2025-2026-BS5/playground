import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final Map<String, TextEditingController> _controllers = {};
  int _refreshCounter = 0;
  
  // Track expansion state for categories
  final Map<String, bool> _expandedCategories = {
    "Atoms": false,
    "Molecules": false,
    "Organisms": false,
    "Pages": false,
  };

  int _selectedRightTab = 0; // 0 for Properties, 1 for Code
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    if (componentRegistry.isNotEmpty) {
      selectedComponent = componentRegistry.first;
      currentProps = Map.from(selectedComponent!.defaultProps);
      _updateControllers();
    }
  }

  String _formatNum(num value, {bool isOpacity = false}) {
    if (isOpacity) return value.toStringAsFixed(2);
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }

  void _updateControllers() {
    // Clear existing if needed, or just update
    _controllers.forEach((key, controller) => controller.dispose());
    _controllers.clear();
    
    currentProps.forEach((key, value) {
      if (value is String) {
        _controllers[key] = TextEditingController(text: value);
      } else if (value is double || value is int) {
        bool isOpacity = key.toLowerCase().contains("opacity");
        _controllers[key] = TextEditingController(
          text: _formatNum(value as num, isOpacity: isOpacity),
        );
      }
    });
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 900;
        
        return Scaffold(
          drawer: isMobile ? Drawer(
            width: 300,
            child: _sidebar(),
          ) : null,
          endDrawer: isMobile ? Drawer(
            width: 300,
            child: _properties(),
          ) : null,
          body: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC), // Clean white-ish background
            ),
            child: Column(
              children: [  
                _header(isMobile: isMobile),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Sidebar (Desktop only)
                      if (!isMobile)
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD0DDF2), // Light blue-grey tint for sidebar
                            border: Border(right: BorderSide(color: Colors.black.withAlpha(20), width: 1)),
                          ),
                          child: _sidebar(),
                        ),
                      
                      // Preview (Always visible)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              right: !isMobile ? BorderSide(color: Colors.black.withAlpha(20), width: 1) : BorderSide.none,
                            ),
                          ),
                          child: _preview(),
                        ),
                      ),
                      
                      // Properties (Desktop only)
                      if (!isMobile)
                        SizedBox(
                          width: 300,
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
    );
  }

  // ================= HEADER =================

  Widget _header({bool isMobile = false}) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16), // Slightly tighter for mobile
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        border: Border(bottom: BorderSide(color: Colors.black.withAlpha(20), width: 1)),
      ),
      child: Row(
        children: [
          // Left Side: Sidebar Toggle (Mobile) or HDFC Logo (Desktop)
          if (isMobile)
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: Color(0xFF1E3A8A)),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          
          const SizedBox(width: 8),
          
          Image.asset(
            'assets/hdfc_logo.png',
            height: 28,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.account_balance_rounded, color: Color(0xFF1E3A8A), size: 28),
          ),
          
          if (!isMobile) ...[
            const Spacer(),
            const Text(
              "Design System Playground",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF1E3A8A),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
          ] else
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Playground",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Right Side: Properties Toggle (Mobile) or Spacer/Registry Info (Desktop)
          if (isMobile)
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.tune_rounded, color: Color(0xFF1E3A8A)),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            )
          else
            const SizedBox(width: 48), // Balance for logo
        ],
      ),
    );
  }

  // ================= SIDEBAR =================

  Widget _sidebar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "COMPONENTS",
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 16,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                decoration: InputDecoration(
                  hintText: "Search components...",
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
                  suffixIcon: _searchQuery.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = "");
                        },
                      )
                    : null,
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.5),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _categoryGlassContainer("Pages"),
                const SizedBox(height: 20),
                _categoryGlassContainer("Atoms"),
                const SizedBox(height: 20),
                _categoryGlassContainer("Molecules"),
                const SizedBox(height: 20),
                _categoryGlassContainer("Organisms"),
              ],
            ),
          ),
        ),
      ],
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
    var items = componentRegistry
        .where((c) => c.category == category)
        .toList();

    // Filter by search query if present
    if (_searchQuery.isNotEmpty) {
      items = items.where((c) => c.name.toLowerCase().startsWith(_searchQuery)).toList();
      // If no items match in this category and we are searching, hide the category
      if (items.isEmpty) return const SizedBox();
    }

    final bool isExpanded = _searchQuery.isNotEmpty || (_expandedCategories[category] ?? false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expandedCategories[category] = !(_expandedCategories[category] ?? false)),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0 : -0.25,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B), size: 26),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Column(
            children: [
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
                        color: selectedComponent?.name == c.name ? const Color(0xFF1E3A8A) : const Color(0xFF475569),
                        fontSize: 16,
                        fontWeight: selectedComponent?.name == c.name ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: selectedComponent?.name == c.name,
                    selectedTileColor: Colors.white.withOpacity(0.5),
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
      padding: const EdgeInsets.all(24),
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
                      color: Color(0xFF1E3A8A),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selectedComponent?.category ?? "",
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 32),
          // Component Preview
          Expanded(
            child: GlassContainer(
              padding: EdgeInsets.zero,
              opacity: 0.1, // Slightly more visible glass for light mode
              borderRadius: BorderRadius.circular(24),
              child: Center(
                    child: selectedComponent == null
                      ? const Text(
                          "Select Component to Preview",
                          style: TextStyle(color: Color(0xFF94A3B8)),
                        )
                      : FittedBox(
                          fit: BoxFit.scaleDown,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              // Pages need a minimum "screen" size to layout correctly
                              minWidth: selectedComponent?.category == "Pages" ? 375 : 0,
                              minHeight: selectedComponent?.category == "Pages" ? 812 : 0,
                              maxWidth: selectedComponent?.category == "Pages" ? 375 : double.infinity,
                              maxHeight: selectedComponent?.category == "Pages" ? 812 : double.infinity,
                            ),
                            child: Align(
                              alignment: selectedComponent!.name == "BottomNav" ? Alignment.bottomCenter : Alignment.center,
                              key: ValueKey("${selectedComponent!.name}_$_refreshCounter"),
                              child: selectedComponent!.builder(
                                currentProps,
                                onPropChanged: (key, val) {
                                  setState(() {
                                    currentProps[key] = val;
                                    _updateControllers();
                                  });
                                },
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.black.withAlpha(10))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 15,
            offset: const Offset(-5, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tab Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              border: Border(bottom: BorderSide(color: Colors.black.withAlpha(10))),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPanelTab("Properties", Icons.tune_rounded, 0),
                  const SizedBox(width: 8),
                  _buildPanelTab("View Code", Icons.code_rounded, 1),
                  const SizedBox(width: 8),
                  if (_selectedRightTab == 0)
                    IconButton(
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.refresh_rounded, color: Color(0xFF64748B), size: 20),
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
            ),
          ),
          
          // Panel Content
          Expanded(
            child: _selectedRightTab == 0 
              ? _buildPropertiesList()
              : _buildRightSideCodePanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildPanelTab(String label, IconData icon, int index) {
    bool isSelected = _selectedRightTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedRightTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ] : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? const Color(0xFF1E3A8A) : const Color(0xFF64748B),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF1E3A8A) : const Color(0xFF64748B),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightSideCodePanel() {
    if (selectedComponent == null) return const Center(child: Text("Select a component"));
    
    final code = selectedComponent!.codeBuilder(currentProps);
    
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: SelectableText(
                code,
                style: const TextStyle(
                  color: Color(0xFF334155),
                  fontFamily: 'monospace',
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Code copied to clipboard!'),
                    backgroundColor: Color(0xFF1E3A8A),
                    behavior: SnackBarBehavior.floating,
                    width: 250,
                  ),
                );
              },
              icon: const Icon(Icons.copy_rounded, size: 18),
              label: const Text("Copy Code"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertiesList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Render all properties dynamically
          ...currentProps.entries.map((entry) {
            final key = entry.key;
            final value = entry.value;

            if (value is bool) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _propertyBoolInput(_formatLabel(key), key),
              );
            } else if (value is double || value is int) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _propertyNumericInput(_formatLabel(key), key),
              );
            } else if (value is Color) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _propertyColorInput(_formatLabel(key), key),
              );
            } else if (value is String) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _propertyTextInput(_formatLabel(key), key),
              );
            } else if (value is FontWeight) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _propertyFontWeightInput(_formatLabel(key), key),
              );
            }
            return const SizedBox();
          }),

          const SizedBox(height: 8),
          _propertyGroup(
            title: "Component Info",
            children: [
              _infoRow("Name", selectedComponent?.name ?? ""),
              _infoRow("Category", selectedComponent?.category ?? ""),
            ],
          ),
          const SizedBox(height: 40), // Bottom padding for scroll
        ],
      ),
    );
  }

  String _formatLabel(String s) {
    if (s == 'borderRadius') return 'Rounded Corners';
    if (s.isEmpty) return s;
    final result = s.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (Match m) => '${m[1]} ${m[2]}');
    return result[0].toUpperCase() + result.substring(1);
  }

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
            style: const TextStyle(color: Color(0xFF1E3A8A), fontSize: 16, fontWeight: FontWeight.bold),
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
      title: Text(label, style: const TextStyle(color: Color(0xFF334155), fontSize: 14)),
      value: currentProps[key] ?? false,
      onChanged: (val) => setState(() => currentProps[key] = val),
      activeThumbColor: const Color(0xFFFF40B4),
    );
  }

  Widget _propertyTextInput(String label, String key) {
    bool disabled = currentProps["disabled"] ?? false;
    final controller = _controllers[key];
    
    // Add validation based on key name
    List<TextInputFormatter> formatters = [];
    if (key.toLowerCase().contains("name")) {
      // Only allow letters and spaces
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')));
    } else if (key.toLowerCase().contains("id")) {
      // Only allow numbers and limit to 9 digits
      formatters.add(FilteringTextInputFormatter.digitsOnly);
      formatters.add(LengthLimitingTextInputFormatter(9));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
        const SizedBox(height: 8),
        TextField(
          enabled: !disabled,
          inputFormatters: formatters,
          style: TextStyle(
            color: disabled ? const Color(0xFF94A3B8) : const Color(0xFF334155),
            fontSize: 14,
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
    if (key.toLowerCase().contains("font")) max = 150.0;
    if (key.toLowerCase().contains("width")) max = 750.0;
    if (key.toLowerCase().contains("offsetx")) {
      min = -300;
      max = 300;
    } else if (key.toLowerCase().contains("offsety")) {
      min = -210;
      max = 210;
    } else if (key.toLowerCase().contains("offset")) {
      min = -500;
      max = 500;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
            SizedBox(
              width: 70, // Slightly wider for suffix
              height: 24,
              child: TextField(
                enabled: !disabled,
                controller: controller,
                textAlign: TextAlign.right,
                style: const TextStyle(color: Color(0xFF1E3A8A), fontSize: 14, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  suffixText: (key.toLowerCase().contains("font") || 
                               key.toLowerCase().contains("radius") || 
                               key.toLowerCase().contains("width") || 
                               key.toLowerCase().contains("height") || 
                               key.toLowerCase().contains("offset")) ? " px" : null,
                  suffixStyle: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
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
        Row(
          children: [
            IconButton(
              onPressed: disabled ? null : () {
                final step = max == 1.0 ? 0.05 : 1.0;
                final newValue = (value - step).clamp(min, max);
                setState(() {
                  currentProps[key] = newValue;
                  if (controller != null) {
                    controller.text = _formatNum(newValue, isOpacity: max == 1.0);
                  }
                });
              },
              icon: const Icon(Icons.remove_circle_outline, size: 20, color: Color(0xFF3B82F6)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            Expanded(
              child: SliderTheme(
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
                        controller.text = _formatNum(val, isOpacity: max == 1.0);
                      }
                    });
                  },
                  activeColor: const Color(0xFF3B82F6),
                  inactiveColor: const Color(0xFFE2E8F0),
                ),
              ),
            ),
            IconButton(
              onPressed: disabled ? null : () {
                final step = max == 1.0 ? 0.05 : 1.0;
                final newValue = (value + step).clamp(min, max);
                setState(() {
                  currentProps[key] = newValue;
                  if (controller != null) {
                    controller.text = _formatNum(newValue, isOpacity: max == 1.0);
                  }
                });
              },
              icon: const Icon(Icons.add_circle_outline, size: 20, color: Color(0xFF3B82F6)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _propertyColorInput(String label, String key) {
    final Color currentColor = currentProps[key] ?? Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        const SizedBox(height: 12),
        _HSVColorPicker(
          color: currentColor,
          onColorChanged: (newColor) {
            setState(() {
              currentProps[key] = newColor;
            });
          },
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
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          Text(value, style: const TextStyle(color: Color(0xFF1E3A8A), fontSize: 13, fontWeight: FontWeight.bold)),
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
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _propertyFontWeightInput(String label, String key) {
    final FontWeight currentWeight = currentProps[key] ?? FontWeight.normal;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
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
          color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF475569),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ================= HSV COLOR PICKER =================

class _HSVColorPicker extends StatefulWidget {
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const _HSVColorPicker({
    required this.color,
    required this.onColorChanged,
  });

  @override
  State<_HSVColorPicker> createState() => _HSVColorPickerState();
}

class _HSVColorPickerState extends State<_HSVColorPicker> {
  late HSVColor hsvColor;

  @override
  void initState() {
    super.initState();
    hsvColor = HSVColor.fromColor(widget.color);
  }

  @override
  void didUpdateWidget(_HSVColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.color != oldWidget.color) {
      hsvColor = HSVColor.fromColor(widget.color);
    }
  }

  void _updateColor() {
    widget.onColorChanged(hsvColor.toColor());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // S/V Box
        GestureDetector(
          onPanUpdate: (details) {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final Offset localOffset = box.globalToLocal(details.globalPosition);
            setState(() {
              hsvColor = hsvColor.withSaturation((localOffset.dx / 250).clamp(0.0, 1.0));
              hsvColor = hsvColor.withValue((1.0 - (localOffset.dy / 150)).clamp(0.0, 1.0));
            });
            _updateColor();
          },
          onTapDown: (details) {
            setState(() {
              hsvColor = hsvColor.withSaturation((details.localPosition.dx / 250).clamp(0.0, 1.0));
              hsvColor = hsvColor.withValue((1.0 - (details.localPosition.dy / 150)).clamp(0.0, 1.0));
            });
            _updateColor();
          },
          child: Container(
            height: 150,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black.withOpacity(0.1)),
            ),
            child: Stack(
              children: [
                CustomPaint(
                  size: Size.infinite,
                  painter: _SVPainter(hsvColor.hue),
                ),
                Positioned(
                  left: hsvColor.saturation * 250 - 8,
                  top: (1.0 - hsvColor.value) * 150 - 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Hue Slider
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              hsvColor = hsvColor.withHue((details.localPosition.dx / 250 * 360).clamp(0.0, 360.0));
            });
            _updateColor();
          },
          onTapDown: (details) {
            setState(() {
              hsvColor = hsvColor.withHue((details.localPosition.dx / 250 * 360).clamp(0.0, 360.0));
            });
            _updateColor();
          },
          child: Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black.withOpacity(0.05)),
            ),
            child: CustomPaint(
              size: Size.infinite,
              painter: _HuePainter(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Hex Display
        GestureDetector(
          onTap: () {
            final hexCode = widget.color.value.toRadixString(16).substring(2).toUpperCase();
            Clipboard.setData(ClipboardData(text: hexCode));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Copied #$hexCode to clipboard'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: const Color(0xFF1E3A8A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black.withAlpha(10)),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "HEX CODE",
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    Text(
                      widget.color.value.toRadixString(16).substring(2).toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF1E3A8A),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(Icons.copy_rounded, color: Colors.blue.withOpacity(0.5), size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SVPainter extends CustomPainter {
  final double hue;
  _SVPainter(this.hue);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Gradient hGradient = LinearGradient(
      colors: [Colors.white, HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor()],
    );
    const Gradient vGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, Colors.black],
    );

    canvas.drawRect(rect, Paint()..shader = hGradient.createShader(rect));
    canvas.drawRect(rect, Paint()..shader = vGradient.createShader(rect)..blendMode = BlendMode.multiply);
  }

  @override
  bool shouldRepaint(_SVPainter oldDelegate) => oldDelegate.hue != hue;
}

class _HuePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final List<Color> colors = List.generate(360, (index) => HSVColor.fromAHSV(1.0, index.toDouble(), 1.0, 1.0).toColor());
    final Gradient gradient = LinearGradient(colors: colors);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
