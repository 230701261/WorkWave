import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../app_themes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/stats_card.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPeriod = 'This Month';
  
  final List<String> _periods = [
    'This Week',
    'This Month',
    'Last Month',
    'This Year',
    'All Time',
  ];
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    if (authProvider.currentUser == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period selection
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppThemes.dividerColor),
              ),
              child: DropdownButton<String>(
                value: _selectedPeriod,
                isExpanded: true,
                underline: SizedBox(),
                items: _periods.map((period) {
                  return DropdownMenuItem<String>(
                    value: period,
                    child: Text(period),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedPeriod = value;
                    });
                  }
                },
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Payment overview
            Text(
              'Payment Overview',
              style: AppThemes.subheadingStyle,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'Total Spent',
                    value: '\$0.00',
                    backgroundColor: AppThemes.primaryColor,
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatsCard(
                    title: 'Pending',
                    value: '\$0.00',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'Active Projects',
                    value: '0',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatsCard(
                    title: 'Avg. Project Cost',
                    value: '\$0.00',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Payment chart
            Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Trend',
                    style: AppThemes.subheadingStyle,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                                if (value.toInt() >= 0 && value.toInt() < labels.length) {
                                  return Text(
                                    labels[value.toInt()],
                                    style: TextStyle(
                                      color: AppThemes.textSecondaryColor,
                                      fontSize: 12,
                                    ),
                                  );
                                }
                                return Text('');
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(0, 0),
                              FlSpot(1, 0),
                              FlSpot(2, 0),
                              FlSpot(3, 0),
                              FlSpot(4, 0),
                              FlSpot(5, 0),
                            ],
                            isCurved: true,
                            color: AppThemes.primaryColor,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppThemes.primaryColor.withOpacity(0.1),
                            ),
                            dotData: FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Payment Methods
            Text(
              'Payment Methods',
              style: AppThemes.subheadingStyle,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.credit_card,
                        color: AppThemes.primaryColor,
                      ),
                      title: Text('Add Payment Method'),
                      trailing: Icon(Icons.add),
                      onTap: () {
                        _showAddPaymentMethodModal();
                      },
                    ),
                    Divider(),
                    Icon(
                      Icons.payment_outlined,
                      size: 48,
                      color: AppThemes.textSecondaryColor.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No payment methods yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add a payment method to hire freelancers.',
                      style: TextStyle(
                        color: AppThemes.textSecondaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Recent Transactions
            Text(
              'Recent Transactions',
              style: AppThemes.subheadingStyle,
            ),
            const SizedBox(height: 16),
            
            // Empty state
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 48,
                    color: AppThemes.textSecondaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: AppThemes.subheadingStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your payments to freelancers will appear here',
                    style: TextStyle(
                      color: AppThemes.textSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showAddPaymentMethodModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Payment Method',
                style: AppThemes.subheadingStyle,
              ),
              const SizedBox(height: 16),
              
              // Card Options
              _buildPaymentMethodOption(
                icon: Icons.credit_card,
                title: 'Credit or Debit Card',
                subtitle: 'Add a new card to your account',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to add card screen
                },
              ),
              
              // PayPal Option
              _buildPaymentMethodOption(
                icon: Icons.account_balance_wallet,
                title: 'PayPal',
                subtitle: 'Connect your PayPal account',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to connect PayPal
                },
              ),
              
              // Bank Account Option
              _buildPaymentMethodOption(
                icon: Icons.account_balance,
                title: 'Bank Account',
                subtitle: 'Connect your bank account directly',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to add bank account
                },
              ),
              
              const SizedBox(height: 24),
              
              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text('Cancel'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildPaymentMethodOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppThemes.primaryColor,
          size: 28,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
