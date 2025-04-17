import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reward_provider.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rewards'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Available'),
              Tab(text: 'Claimed'),
            ],
          ),
        ),
        body: Consumer<RewardProvider>(
          builder: (context, rewardProvider, child) {
            return TabBarView(
              children: [
                _buildAvailableRewards(context, rewardProvider),
                _buildClaimedRewards(context, rewardProvider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvailableRewards(BuildContext context, RewardProvider rewardProvider) {
    final availableRewards = rewardProvider.availableRewards;
    final userPoints = rewardProvider.userPoints;

    return Column(
      children: [
        _buildPointsCard(userPoints),
        Expanded(
          child: availableRewards.isEmpty
              ? const Center(
                  child: Text('No available rewards'),
                )
              : ListView.builder(
                  itemCount: availableRewards.length,
                  itemBuilder: (context, index) {
                    final reward = availableRewards[index];
                    return _buildRewardCard(
                      context,
                      reward,
                      userPoints >= reward.pointsRequired,
                      () => rewardProvider.claimReward(reward.id),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildClaimedRewards(BuildContext context, RewardProvider rewardProvider) {
    final claimedRewards = rewardProvider.claimedRewards;

    return claimedRewards.isEmpty
        ? const Center(
            child: Text('No claimed rewards'),
          )
        : ListView.builder(
            itemCount: claimedRewards.length,
            itemBuilder: (context, index) {
              final reward = claimedRewards[index];
              return _buildRewardCard(
                context,
                reward,
                false,
                null,
                isClaimed: true,
              );
            },
          );
  }

  Widget _buildPointsCard(int points) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Your Points',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              points.toString(),
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardCard(
    BuildContext context,
    dynamic reward,
    bool canClaim,
    VoidCallback? onClaim, {
    bool isClaimed = false,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        title: Text(reward.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reward.description),
            const SizedBox(height: 4),
            Text(
              '${reward.pointsRequired} points required',
              style: TextStyle(
                color: canClaim ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isClaimed && reward.claimedAt != null)
              Text(
                'Claimed on ${reward.claimedAt!.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        trailing: isClaimed
            ? const Icon(Icons.check_circle, color: Colors.green)
            : ElevatedButton(
                onPressed: canClaim ? onClaim : null,
                child: const Text('Claim'),
              ),
      ),
    );
  }
} 