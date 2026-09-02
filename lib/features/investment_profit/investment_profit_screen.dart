import 'package:flutter/material.dart';

import '../../core/theme/orenza_theme.dart';

class InvestmentProfitScreen extends StatefulWidget {
  const InvestmentProfitScreen({super.key});

  @override
  State<InvestmentProfitScreen> createState() => _InvestmentProfitScreenState();
}

class _InvestmentProfitScreenState extends State<InvestmentProfitScreen> {
  final _amountController = TextEditingController(text: '1000');
  final _rateController = TextEditingController(text: '10');
  final _durationController = TextEditingController(text: '12');
  bool compound = true;

  @override
  void dispose() {
    _amountController.dispose();
    _rateController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  double _number(TextEditingController controller) {
    final value = controller.text.trim().replaceAll(' ', '');
    if (value.isEmpty) return 0;

    // Support both 10.5 and 10,5 while retaining common grouped values such
    // as 1,000. A comma followed by one or two digits is treated as decimal.
    if (value.contains(',') && !value.contains('.')) {
      final parts = value.split(',');
      if (parts.length == 2 && parts.last.length <= 2) {
        return double.tryParse('${parts.first}.${parts.last}') ?? 0;
      }
    }

    return double.tryParse(value.replaceAll(',', '')) ?? 0;
  }

  Map<String, double> get projection {
    final principal = _number(_amountController);
    final annualRate = _number(_rateController) / 100;
    final months = _number(_durationController).clamp(0, 600);
    final years = months / 12;

    // Compound growth is undefined for this projection at or below -100%.
    // Return unavailable values instead of silently showing a false zero loss.
    if (compound && annualRate <= -1) {
      return {'principal': principal, 'profit': double.nan, 'total': double.nan};
    }

    final total = compound
        ? principal * _compoundFactor(annualRate, months.toInt())
        : principal * (1 + annualRate * years);
    final profit = total - principal;

    return {'principal': principal, 'profit': profit, 'total': total};
  }

  double _compoundFactor(double annualRate, int months) {
    if (months <= 0) return 1;
    return _fastPower(1 + annualRate / 12, months);
  }

  double _fastPower(double base, int exponent) {
    var result = 1.0;
    var factor = base;
    var n = exponent;
    while (n > 0) {
      if (n.isOdd) result *= factor;
      factor *= factor;
      n ~/= 2;
    }
    return result;
  }

  void _recalculate() => setState(() {});

  bool get invalidCompoundRate => compound && _number(_rateController) <= -100;

  @override
  Widget build(BuildContext context) {
    final data = projection;
    final principal = data['principal']!;
    final profit = data['profit']!;
    final total = data['total']!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'INVESTMENT PROFIT',
                style: TextStyle(
                  color: OrenzaColors.gold,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.6,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Plan your investment outcome',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                'A sandbox projection tool. Results are estimates, not guaranteed returns or live account profit.',
                style: TextStyle(color: OrenzaColors.slate, fontSize: 13),
              ),
              const SizedBox(height: 22),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 720;
                  final form = _InputCard(
                    amountController: _amountController,
                    rateController: _rateController,
                    durationController: _durationController,
                    compound: compound,
                    invalidCompoundRate: invalidCompoundRate,
                    onCompoundChanged: (value) => setState(() => compound = value),
                    onChanged: _recalculate,
                  );

                  final result = _ResultCard(
                    principal: principal,
                    profit: profit,
                    total: total,
                  );

                  if (wide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: form),
                        const SizedBox(width: 16),
                        Expanded(child: result),
                      ],
                    );
                  }

                  return Column(children: [form, const SizedBox(height: 16), result]);
                },
              ),
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.shield_outlined, color: OrenzaColors.gold),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Sandbox only. This calculator does not execute trades, move funds, or represent a withdrawal balance. Live P&L must come from the authorized backend ledger.',
                          style: TextStyle(color: OrenzaColors.slate, fontSize: 12, height: 1.45),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final TextEditingController amountController;
  final TextEditingController rateController;
  final TextEditingController durationController;
  final bool compound;
  final bool invalidCompoundRate;
  final ValueChanged<bool> onCompoundChanged;
  final VoidCallback onChanged;

  const _InputCard({
    required this.amountController,
    required this.rateController,
    required this.durationController,
    required this.compound,
    required this.invalidCompoundRate,
    required this.onCompoundChanged,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Projection inputs', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 18),
            _field('Investment amount', amountController, 'e.g. 1000'),
            const SizedBox(height: 14),
            _field(
              'Expected annual return (%)',
              rateController,
              'e.g. 10 or 10,5',
              errorText: invalidCompoundRate ? 'Use a rate above -100% for compound growth.' : null,
            ),
            const SizedBox(height: 14),
            _field('Duration (months)', durationController, 'e.g. 12'),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Compound growth', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('Reinvest projected gains in the calculation.'),
              value: compound,
              onChanged: onCompoundChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
    String hint, {
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: const Icon(Icons.edit_outlined),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final double principal;
  final double profit;
  final double total;

  const _ResultCard({required this.principal, required this.profit, required this.total});

  String _money(double value) => value.isFinite ? '\$${value.toStringAsFixed(2)}' : 'Unavailable';

  @override
  Widget build(BuildContext context) {
    final valid = profit.isFinite && total.isFinite;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Projected outcome', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 18),
            _row('Starting investment', _money(principal)),
            const SizedBox(height: 12),
            _row('Projected profit', _money(profit), positive: valid && profit >= 0),
            const Divider(height: 28),
            const Text('Estimated total value', style: TextStyle(color: OrenzaColors.slate, fontSize: 12)),
            const SizedBox(height: 5),
            Text(
              _money(total),
              style: TextStyle(
                color: valid ? OrenzaColors.forest : OrenzaColors.slate,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool positive = false}) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(color: OrenzaColors.slate, fontSize: 12))),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: positive ? OrenzaColors.success : OrenzaColors.charcoal,
          ),
        ),
      ],
    );
  }
}
