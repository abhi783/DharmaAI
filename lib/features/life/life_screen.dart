import 'package:flutter/material.dart';
import '../../core/theme/dharma_theme.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/services/daily_companion_service.dart';
import '../../core/viewmodels/life_viewmodel.dart';
import 'package:provider/provider.dart';
import '../home/home_screen.dart';
import '../chat/chat_screen.dart';

class LifeScreen extends StatelessWidget {
  const LifeScreen({super.key});

  Widget _sectionTitle(BuildContext c, String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(title, style: Theme.of(c).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
      );

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LifeViewModel>(context);

    return Scaffold(
      backgroundColor: kDeepBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: RefreshIndicator(
            onRefresh: vm.refreshDailyCompanion,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(vm.greeting, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(vm.subGreeting, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70)),
                  const SizedBox(height: 18),

                  _sectionTitle(context, "Today's Wisdom"),
                  GlassCard(
                      child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(vm.dailyCompanion.wisdom, style: Theme.of(context).textTheme.bodyLarge),
                  )),

                  const SizedBox(height: 12),
                  _sectionTitle(context, "Today's Goal"),
                  GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(vm.dailyCompanion.goal, style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  ),

                  const SizedBox(height: 12),
                  _sectionTitle(context, "Daily Companion"),
                  GlassCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Morning Motivation', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(vm.dailyCompanion.morningMotivation, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 10),
                      Text('Bhagavad Gita Concept', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(vm.dailyCompanion.gitaConcept, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 10),
                      Text('Productivity suggestion', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(vm.dailyCompanion.productivityTip, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 10),
                    ]),
                  ),

                  const SizedBox(height: 12),
                  _sectionTitle(context, 'Continue Learning'),
                  GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        for (var item in vm.learningJourney.items)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(children: [
                              Expanded(child: Text(item.title, style: Theme.of(context).textTheme.bodyLarge)),
                              Text('${(item.progress * 100).toStringAsFixed(0)}%', style: Theme.of(context).textTheme.bodySmall)
                            ]),
                          )
                      ]),
                    ),
                  ),

                  const SizedBox(height: 12),
                  _sectionTitle(context, 'Continue Previous Chat'),
                  GlassCard(child: ListTile(title: Text(vm.recentChatTitle ?? 'No recent chat'), trailing: Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())))),

                  const SizedBox(height: 12),
                  _sectionTitle(context, 'Suggested Conversations'),
                  GlassCard(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(spacing: 8, runSpacing: 8, children: vm.suggestedConversations.map((s) => ActionChip(label: Text(s), onPressed: () {})).toList()),
                  )),

                  const SizedBox(height: 12),
                  _sectionTitle(context, 'Mood Check'),
                  GlassCard(child: Padding(padding: const EdgeInsets.all(12), child: Text('How are you feeling today?', style: Theme.of(context).textTheme.bodyLarge))),

                  const SizedBox(height: 12),
                  _sectionTitle(context, 'Quote of the Day'),
                  GlassCard(child: Padding(padding: const EdgeInsets.all(12), child: Text(vm.dailyCompanion.quote, style: Theme.of(context).textTheme.bodyLarge))),

                  const SizedBox(height: 12),
                  _sectionTitle(context, "Today's Challenge"),
                  GlassCard(child: Padding(padding: const EdgeInsets.all(12), child: Text(vm.dailyCompanion.challenge, style: Theme.of(context).textTheme.bodyLarge))),

                  const SizedBox(height: 12),
                  _sectionTitle(context, 'Recently Learned'),
                  GlassCard(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: vm.recentLearned.map((t) => Text('• $t')).toList()))),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
