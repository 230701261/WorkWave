import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../app_themes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/stats_card.dart';

class IndustryAnalysisScreen extends StatelessWidget {
  const IndustryAnalysisScreen({super.key});

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
        title: Text('Industry Analysis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Market trends
            Text(
              'Market Trends',
              style: AppThemes.subheadingStyle,
            ),
            const SizedBox(height: 16),
            Container(
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
                    'Job Postings by Category',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 20,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
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
                                const titles = ['Web', 'Mobile', 'UI/UX', 'Backend', 'Data'];
                                if (value.toInt() >= 0 && value.toInt() < titles.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      titles[value.toInt()],
                                      style: TextStyle(
                                        color: AppThemes.textSecondaryColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                }
                                return Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value % 5 == 0) {
                                  return Text(
                                    '${value.toInt()}',
                                    style: TextStyle(
                                      color: AppThemes.textSecondaryColor,
                                      fontSize: 12,
                                    ),
                                  );
                                }
                                return Text('');
                              },
                              reservedSize: 30,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: 15,
                                color: AppThemes.primaryColor,
                                width: 22,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              )
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: 12,
                                color: AppThemes.primaryColor,
                                width: 22,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              )
                            ],
                          ),
                          BarChartGroupData(
                            x: 2,
                            barRods: [
                              BarChartRodData(
                                toY: 8,
                                color: AppThemes.primaryColor,
                                width: 22,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              )
                            ],
                          ),
                          BarChartGroupData(
                            x: 3,
                            barRods: [
                              BarChartRodData(
                                toY: 10,
                                color: AppThemes.primaryColor,
                                width: 22,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              )
                            ],
                          ),
                          BarChartGroupData(
                            x: 4,
                            barRods: [
                              BarChartRodData(
                                toY: 6,
                                color: AppThemes.primaryColor,
                                width: 22,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Skill demand
            Text(
              'Skill Demand',
              style: AppThemes.subheadingStyle,
            ),
            const SizedBox(height: 16),
            Container(
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
                    'Most In-Demand Skills',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSkillDemandItem(
                    skill: 'Flutter',
                    percentage: 85,
                  ),
                  const SizedBox(height: 12),
                  _buildSkillDemandItem(
                    skill: 'React Native',
                    percentage: 78,
                  ),
                  const SizedBox(height: 12),
                  _buildSkillDemandItem(
                    skill: 'Figma',
                    percentage: 72,
                  ),
                  const SizedBox(height: 12),
                  _buildSkillDemandItem(
                    skill: 'Node.js',
                    percentage: 65,
                  ),
                  const SizedBox(height: 12),
                  _buildSkillDemandItem(
                    skill: 'Python',
                    percentage: 60,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Salary insights
            Text(
              'Salary Insights',
              style: AppThemes.subheadingStyle,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'Mobile Developer',
                    value: '\$45/hr',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatsCard(
                    title: 'Web Developer',
                    value: '\$40/hr',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'UI/UX Designer',
                    value: '\$38/hr',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatsCard(
                    title: 'Backend Developer',
                    value: '\$42/hr',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Location trends
            Text(
              'Location Trends',
              style: AppThemes.subheadingStyle,
            ),
            const SizedBox(height: 16),
            Container(
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
                    'Hot Job Markets',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLocationItem(
                    location: 'United States',
                    jobCount: 1250,
                  ),
                  _buildLocationItem(
                    location: 'United Kingdom',
                    jobCount: 860,
                  ),
                  _buildLocationItem(
                    location: 'Australia',
                    jobCount: 650,
                  ),
                  _buildLocationItem(
                    location: 'Canada',
                    jobCount: 540,
                  ),
                  _buildLocationItem(
                    location: 'Germany',
                    jobCount: 490,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSkillDemandItem({
    required String skill,
    required int percentage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(skill),
            Text('$percentage%'),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: AppThemes.dividerColor,
          valueColor: AlwaysStoppedAnimation<Color>(AppThemes.primaryColor),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
  
  Widget _buildLocationItem({
    required String location,
    required int jobCount,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(location),
          Text(
            '$jobCount jobs',
            style: TextStyle(
              color: AppThemes.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
