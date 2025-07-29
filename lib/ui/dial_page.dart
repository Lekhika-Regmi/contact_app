import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/contact_model.dart';
import '../../data/database_helper.dart';
import 'calling_page.dart';
import 'contact_detail_page.dart';

class DialPage extends StatefulWidget {
  const DialPage({super.key});

  @override
  State<DialPage> createState() => _DialPageState();
}

class _DialPageState extends State<DialPage> {
  final TextEditingController _numberController = TextEditingController();
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  bool _showContacts = false;
  String _pressedButton = '';

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _numberController.addListener(_filterContacts);
  }

  Future<void> _loadContacts() async {
    final allContacts = await DatabaseHelper.instance.getContacts();
    setState(() {
      _contacts = allContacts;
    });
  }

  void _filterContacts() {
    final query = _numberController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        _filteredContacts = [];
        _showContacts = false;
      });
    } else {
      setState(() {
        _filteredContacts = _contacts.where((contact) {
          return contact.phone.contains(query) ||
              contact.name.toLowerCase().contains(query);
        }).toList();
        _showContacts = _filteredContacts.isNotEmpty;
      });
    }
  }

  void _onNumberPressed(String number) {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Set pressed button for visual feedback
    setState(() {
      _pressedButton = number;
      _numberController.text += number;
    });

    // Reset pressed button after a short delay
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _pressedButton = '';
        });
      }
    });
  }

  void _onDeletePressed() {
    HapticFeedback.selectionClick();
    if (_numberController.text.isNotEmpty) {
      setState(() {
        _numberController.text = _numberController.text.substring(
          0,
          _numberController.text.length - 1,
        );
      });
    }
  }

  void _onCallPressed() {
    final number = _numberController.text.trim();
    if (number.isNotEmpty) {
      HapticFeedback.mediumImpact();

      // Find contact name if exists
      String contactName = number; // Default to number
      try {
        final contact = _contacts.firstWhere((c) => c.phone == number);
        contactName = contact.name;
      } catch (e) {
        // Contact not found, use the number as name
        contactName = number;
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CallingPage(name: contactName)),
      );
    }
  }

  void _onLongPressDelete() {
    HapticFeedback.heavyImpact();
    setState(() {
      _numberController.clear();
    });
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    // Define colors based on theme
    final backgroundColor = isDark
        ? Colors.black
        : theme.scaffoldBackgroundColor;
    final dialButtonColor = isDark ? Colors.grey[850] : theme.cardColor;
    final dialButtonPressedColor = isDark
        ? Colors.grey[700]
        : theme.primaryColor.withOpacity(0.2);
    final dialButtonBorderColor = isDark
        ? Colors.grey[700]
        : theme.dividerColor;
    final numberTextColor = isDark
        ? Colors.white
        : theme.textTheme.headlineMedium?.color ?? Colors.black87;
    final hintTextColor = isDark
        ? Colors.grey[600]
        : theme.textTheme.bodyMedium?.color?.withOpacity(0.6) ?? Colors.grey;
    final lettersTextColor = isDark
        ? Colors.grey[400]
        : theme.textTheme.bodySmall?.color?.withOpacity(0.7) ??
              Colors.grey[600];
    final suggestionBackgroundColor = isDark
        ? Colors.grey[900]
        : theme.primaryColor.withOpacity(0.1);
    final suggestionTextColor = isDark ? Colors.white70 : theme.primaryColor;
    final actionButtonColor = isDark ? Colors.grey[800] : theme.cardColor;
    final actionButtonDisabledColor = isDark
        ? Colors.grey[900]
        : theme.disabledColor.withOpacity(0.1);
    final actionIconColor = isDark
        ? Colors.white
        : theme.iconTheme.color ?? Colors.black87;
    final actionIconDisabledColor = isDark
        ? Colors.grey[600]
        : theme.disabledColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Phone Number Display
            Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // Number Display
                  Expanded(
                    child: Center(
                      child: Text(
                        _numberController.text.isEmpty
                            ? 'Enter number'
                            : _formatPhoneNumber(_numberController.text),
                        style: TextStyle(
                          color: _numberController.text.isEmpty
                              ? hintTextColor
                              : numberTextColor,
                          fontSize: _numberController.text.length > 10
                              ? 28
                              : 36,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // Contact suggestion
                  if (_filteredContacts.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: suggestionBackgroundColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _filteredContacts.first.name,
                        style: TextStyle(
                          color: suggestionTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Dial Pad
            // Replace your existing dial pad section with this updated version

            // Dial Pad - Updated section
            Flexible(
              flex: _showContacts ? 2 : 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Dial pad grid - UPDATED
                    SizedBox(
                      height: 440, // Reduced from 530
                      child: GridView.count(
                        crossAxisCount: 3,
                        childAspectRatio:
                            1.2, // Increased from 1 to make circles smaller
                        crossAxisSpacing: 30, // Increased spacing
                        mainAxisSpacing: 20, // Increased spacing
                        children: [
                          _buildDialButton(
                            '1',
                            '',
                            dialButtonColor,
                            dialButtonPressedColor,
                            dialButtonBorderColor,
                            numberTextColor,
                            lettersTextColor,
                            isDark,
                          ),
                          _buildDialButton(
                            '2',
                            'ABC',
                            dialButtonColor,
                            dialButtonPressedColor,
                            dialButtonBorderColor,
                            numberTextColor,
                            lettersTextColor,
                            isDark,
                          ),
                          _buildDialButton(
                            '3',
                            'DEF',
                            dialButtonColor,
                            dialButtonPressedColor,
                            dialButtonBorderColor,
                            numberTextColor,
                            lettersTextColor,
                            isDark,
                          ),
                          _buildDialButton(
                            '4',
                            'GHI',
                            dialButtonColor,
                            dialButtonPressedColor,
                            dialButtonBorderColor,
                            numberTextColor,
                            lettersTextColor,
                            isDark,
                          ),
                          _buildDialButton(
                            '5',
                            'JKL',
                            dialButtonColor,
                            dialButtonPressedColor,
                            dialButtonBorderColor,
                            numberTextColor,
                            lettersTextColor,
                            isDark,
                          ),
                          _buildDialButton(
                            '6',
                            'MNO',
                            dialButtonColor,
                            dialButtonPressedColor,
                            dialButtonBorderColor,
                            numberTextColor,
                            lettersTextColor,
                            isDark,
                          ),
                          _buildDialButton(
                            '7',
                            'PQRS',
                            dialButtonColor,
                            dialButtonPressedColor,
                            dialButtonBorderColor,
                            numberTextColor,
                            lettersTextColor,
                            isDark,
                          ),
                          _buildDialButton(
                            '8',
                            'TUV',
                            dialButtonColor,
                            dialButtonPressedColor,
                            dialButtonBorderColor,
                            numberTextColor,
                            lettersTextColor,
                            isDark,
                          ),
                          _buildDialButton(
                            '9',
                            'WXYZ',
                            dialButtonColor,
                            dialButtonPressedColor,
                            dialButtonBorderColor,
                            numberTextColor,
                            lettersTextColor,
                            isDark,
                          ),
                          _buildDialButton(
                            '*',
                            '',
                            dialButtonColor,
                            dialButtonPressedColor,
                            dialButtonBorderColor,
                            numberTextColor,
                            lettersTextColor,
                            isDark,
                          ),
                          _buildDialButton(
                            '0',
                            '+',
                            dialButtonColor,
                            dialButtonPressedColor,
                            dialButtonBorderColor,
                            numberTextColor,
                            lettersTextColor,
                            isDark,
                          ),
                          _buildDialButton(
                            '#',
                            '',
                            dialButtonColor,
                            dialButtonPressedColor,
                            dialButtonBorderColor,
                            numberTextColor,
                            lettersTextColor,
                            isDark,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50), // Increased spacing
                    // Bottom action row (unchanged)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Contacts button
                        _buildActionButton(
                          icon: Icons.contacts,
                          onPressed: () {
                            // Navigate to contacts or show contact list
                          },
                          enabledColor: actionButtonColor,
                          disabledColor: actionButtonDisabledColor,
                          iconColor: actionIconColor,
                          iconDisabledColor: actionIconDisabledColor,
                          isDark: isDark,
                        ),

                        // Call button
                        _buildCallButton(isDark),

                        // Delete button
                        _buildActionButton(
                          icon: Icons.backspace_outlined,
                          onPressed: _numberController.text.isNotEmpty
                              ? _onDeletePressed
                              : null,
                          onLongPress: _numberController.text.isNotEmpty
                              ? _onLongPressDelete
                              : null,
                          enabledColor: actionButtonColor,
                          disabledColor: actionButtonDisabledColor,
                          iconColor: actionIconColor,
                          iconDisabledColor: actionIconDisabledColor,
                          isDark: isDark,
                        ),
                      ],
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

  Widget _buildDialButton(
    String number,
    String letters,
    Color? normalColor,
    Color? pressedColor,
    Color? borderColor,
    Color? textColor,
    Color? lettersColor,
    bool isDark,
  ) {
    final isPressed = _pressedButton == number;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () => _onNumberPressed(number),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.identity()..scale(isPressed ? 0.95 : 1.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPressed ? pressedColor : normalColor,
            border: Border.all(color: borderColor!, width: 1),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                number,
                style: TextStyle(
                  color: textColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                ),
              ),
              if (letters.isNotEmpty)
                Text(
                  letters,
                  style: TextStyle(
                    color: lettersColor,
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallButton(bool isDark) {
    final theme = Theme.of(context);
    final callButtonColor = _numberController.text.isNotEmpty
        ? Colors.green[600]
        : (isDark ? Colors.grey[700] : theme.disabledColor.withOpacity(0.3));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(35),
        onTap: _numberController.text.isNotEmpty ? _onCallPressed : null,
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: callButtonColor,
            boxShadow: [
              if (_numberController.text.isNotEmpty)
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
            ],
          ),
          child: const Icon(Icons.call, color: Colors.white, size: 40),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    Color? enabledColor,
    Color? disabledColor,
    Color? iconColor,
    Color? iconDisabledColor,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: onPressed,
        onLongPress: onLongPress,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: onPressed != null ? enabledColor : disabledColor,
            boxShadow: [
              if (onPressed != null && !isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
            ],
          ),
          child: Icon(
            icon,
            color: onPressed != null ? iconColor : iconDisabledColor,
            size: 24,
          ),
        ),
      ),
    );
  }

  String _formatPhoneNumber(String number) {
    if (number.length <= 3) return number;
    if (number.length <= 6) {
      return '${number.substring(0, 3)}-${number.substring(3)}';
    }
    if (number.length <= 10) {
      return '(${number.substring(0, 3)}) ${number.substring(3, 6)}-${number.substring(6)}';
    }
    return number; // For longer numbers, return as is
  }
}
