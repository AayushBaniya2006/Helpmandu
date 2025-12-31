import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import '../Services/booking_service.dart';
import '../Services/payment_service.dart';
import '../Services/app_config.dart';

class BookPage extends StatefulWidget {
  final String name;

  const BookPage({Key? key, required this.name}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final TextEditingController _textFieldControllerDescription =
      TextEditingController();

  final BookingService _bookingService = BookingService();
  final PaymentService _paymentService = PaymentService();
  final AppConfig _appConfig = AppConfig();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool _isLoading = false;
  String? _errorMessage;

  void _showDatePicker(context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF667eea),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _errorMessage = null;
      });
    }
  }

  void _showTimePicker(context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF667eea),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        _errorMessage = null;
      });
    }
  }

  @override
  void dispose() {
    _textFieldControllerDescription.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    if (selectedDate == null) {
      setState(() => _errorMessage = 'Please select a date');
      return false;
    }
    if (selectedTime == null) {
      setState(() => _errorMessage = 'Please select a time');
      return false;
    }
    if (_textFieldControllerDescription.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please enter a description');
      return false;
    }
    return true;
  }

  Future<void> _createBooking() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final booking = await _bookingService.createBooking(
        serviceName: widget.name,
        bookingDate: selectedDate!,
        bookingTime: selectedTime!.format(context),
        description: _textFieldControllerDescription.text.trim(),
      );

      if (mounted) {
        _showBookingSuccessDialog(booking);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().contains('not authenticated')
            ? 'Please login to create a booking'
            : 'Failed to create booking. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showBookingSuccessDialog(Booking booking) {
    final price = _paymentService.getServicePrice(widget.name);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.check_rounded, color: Color(0xFF2E7D32), size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Booking Created!', style: TextStyle(fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your booking for ${widget.name} has been submitted.',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            _buildInfoRow('Date', _formatDate(selectedDate!)),
            _buildInfoRow('Time', selectedTime!.format(context)),
            _buildInfoRow('Status', 'Pending'),
            _buildInfoRow('Est. Price', _paymentService.formatPrice(price)),
            const SizedBox(height: 16),
            Text(
              'You will receive a confirmation once our provider accepts.',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Done', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showPaymentOptions(booking);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Pay Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showPaymentOptions(Booking booking) {
    final price = booking.price ?? _paymentService.getServicePrice(widget.name);

    showDialog(
      context: context,
      builder: (context) => PaymentMethodDialog(
        amount: price,
        onMethodSelected: (method) => _processPayment(booking, method, price),
      ),
    );
  }

  Future<void> _processPayment(
    Booking booking,
    PaymentMethod method,
    double amount,
  ) async {
    try {
      final payment = await _paymentService.initializePayment(
        bookingId: booking.id,
        amount: amount,
        method: method,
      );

      bool success = false;

      switch (method) {
        case PaymentMethod.esewa:
          success = await _paymentService.processEsewaPayment(
            paymentId: payment.id,
            amount: amount,
            productName: widget.name,
          );
          break;
        case PaymentMethod.khalti:
          success = await _paymentService.processKhaltiPayment(
            paymentId: payment.id,
            amount: amount,
            productName: widget.name,
          );
          break;
        case PaymentMethod.cashOnDelivery:
          success = true;
          await _paymentService.updatePaymentStatus(
            paymentId: payment.id,
            status: PaymentStatus.pending,
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Cash on Delivery selected.'),
                backgroundColor: const Color(0xFF667eea),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
            Navigator.pop(context);
          }
          return;
      }

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not open payment gateway.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment error: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  Future<void> _sendSMS() async {
    if (!_validateInputs()) return;

    final phoneNumber = _appConfig.providerPhone;
    String time = selectedTime!.format(context);
    String date = _formatDate(selectedDate!);
    String description = _textFieldControllerDescription.text;

    String message = 'Appointment: ${widget.name}\n'
        'Date: $date\n'
        'Time: $time\n'
        'Description: $description';

    try {
      Uri smsUri;
      if (Platform.isIOS) {
        smsUri = Uri(scheme: 'sms', path: phoneNumber);
      } else {
        smsUri = Uri(
          scheme: 'sms',
          path: phoneNumber,
          queryParameters: <String, String>{'body': message},
        );
      }

      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Could not open SMS app'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = _paymentService.getServicePrice(widget.name);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A), size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Book Service',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.home_repair_service_rounded, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'From ${_paymentService.formatPrice(price)}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Date & Time
              const Text(
                'Select Date & Time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(child: _buildDateTimeButton(
                    onPressed: () => _showDatePicker(context),
                    icon: Icons.calendar_today_outlined,
                    label: selectedDate != null ? _formatDate(selectedDate!) : 'Select Date',
                    isSelected: selectedDate != null,
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _buildDateTimeButton(
                    onPressed: () => _showTimePicker(context),
                    icon: Icons.access_time_outlined,
                    label: selectedTime != null ? selectedTime!.format(context) : 'Select Time',
                    isSelected: selectedTime != null,
                  )),
                ],
              ),

              const SizedBox(height: 28),

              // Description
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: _textFieldControllerDescription,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Describe your service requirements...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  contentPadding: const EdgeInsets.all(16),
                ),
                onChanged: (_) => setState(() => _errorMessage = null),
              ),

              // Error
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline_rounded, color: Colors.red.shade700, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Book Button
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: _isLoading ? null : _createBooking,
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: _isLoading
                          ? null
                          : const LinearGradient(
                              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                            ),
                      color: _isLoading ? Colors.grey[300] : null,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Book Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // SMS Option
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _sendSMS,
                  icon: const Icon(Icons.sms_outlined, size: 20),
                  label: const Text('Book via SMS'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF667eea),
                    side: const BorderSide(color: Color(0xFF667eea)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Disclaimer
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, color: Colors.amber.shade700, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Booking is subject to provider availability. Confirmation within 24 hours.',
                        style: TextStyle(fontSize: 13, color: Colors.amber.shade800),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF667eea).withOpacity(0.1) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF667eea) : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? const Color(0xFF667eea) : Colors.grey[600]),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? const Color(0xFF667eea) : Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
