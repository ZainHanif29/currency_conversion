import 'package:flutter/material.dart';
import '../utils/Constants.dart';
import '../utils/currency_service.dart';

class CurrencyConvert extends StatefulWidget {
  @override
  _CurrencyConvertState createState() => _CurrencyConvertState();
}

class _CurrencyConvertState extends State<CurrencyConvert> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'PKR';
  double _convertedAmount = 0.0;
  bool _isLoading = false;
  String? _errorMessage;
  List<String> _currencies = []; // Add the currencies list here
  final CurrencyService _currencyService = CurrencyService();

  @override
  void initState() {
    super.initState();
    _fetchCurrencies();
  }

  void _fetchCurrencies() async {
    try {
      List<String> currencies = await _currencyService.fetchCurrencies();
      setState(() {
        _currencies = currencies;
      });
    } catch (error) {
      debugPrint('Failed to fetch currencies: $error');
    }
  }

  void _convertCurrency() async {
    if (_amountController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final double amount = double.parse(_amountController.text);
      double result = await _currencyService.convertCurrency(
          _fromCurrency, _toCurrency, amount);
      setState(() {
        _convertedAmount = result;
        _errorMessage = null;
      });
    } catch (error) {
      setState(() {
        AppDesignSystem.showToastMessage("Error: $error");
        _errorMessage = 'Error: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.whiteColor,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Form(
            key: key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: AppDesignSystem.amount('Amount'),
                  style: AppDesignSystem.inputFieldTextStyle,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Invalid amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _fromCurrency,
                        items: _currencies.map((currency) {
                          return DropdownMenuItem<String>(
                            value: currency,
                            child: Center(
                              child: Text(currency,
                                  style: AppDesignSystem.dropdowntext),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _fromCurrency = value ?? 'USD';
                            _convertedAmount = 0.0;
                            _errorMessage = null;
                          });
                        },
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        iconEnabledColor: Color(0xff092E20),
                        iconSize: 30,
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _toCurrency,
                        items: _currencies.map((currency) {
                          return DropdownMenuItem<String>(
                            value: currency,
                            child: Center(
                              child: Text("$currency",
                                  style: AppDesignSystem.dropdowntext),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _toCurrency = value ?? 'PKR';
                            _convertedAmount = 0.0;
                            _errorMessage = null;
                          });
                        },
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        iconEnabledColor: Color(0xff092E20),
                        iconSize: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                InkWell(
                    onTap: () {
                      if (key.currentState!.validate()) {
                        _isLoading ? null : _convertCurrency();
                      }
                    },
                    child: Constants.btn(_isLoading ? "Waiting" : "Process")),
                SizedBox(height: 20),
                if (_convertedAmount > 0.0)
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppDesignSystem.whiteColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                          color: AppDesignSystem.greenColor,
                          borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                '$_fromCurrency to $_toCurrency',
                                style: AppDesignSystem.currencyHeading,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Selected Amount:',
                                  style: AppDesignSystem.currencySubHeading,
                                ),
                                Text(
                                  '${_amountController.text}',
                                  style: AppDesignSystem.ammountText,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Converted Amount:',
                                  style: AppDesignSystem.currencySubHeading,
                                ),
                                Text(
                                  '${_currencyService.formatCurrency(_toCurrency, 'en_US', _convertedAmount)}',
                                  style: AppDesignSystem.ammountText,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: AppDesignSystem.currencyError,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
