import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/reward_model.dart';

class RewardProvider with ChangeNotifier {
  List<Reward> _rewards = [];
  int _userPoints = 0;

  List<Reward> get rewards => _rewards;
  int get userPoints => _userPoints;
  List<Reward> get availableRewards => _rewards.where((reward) => !reward.isClaimed).toList();
  List<Reward> get claimedRewards => _rewards.where((reward) => reward.isClaimed).toList();

  RewardProvider() {
    _loadRewards();
    _loadUserPoints();
  }

  Future<void> _loadRewards() async {
    final prefs = await SharedPreferences.getInstance();
    final rewardsJson = prefs.getString('rewards');
    if (rewardsJson != null) {
      final List<dynamic> decodedRewards = json.decode(rewardsJson);
      _rewards = decodedRewards.map((reward) => Reward.fromJson(reward)).toList();
      notifyListeners();
    } else {
      // Initialize with default rewards
      _rewards = [
        Reward(
          id: '1',
          title: 'First Task',
          description: 'Complete your first task',
          pointsRequired: 10,
        ),
        Reward(
          id: '2',
          title: 'Habit Master',
          description: 'Maintain a 7-day streak',
          pointsRequired: 50,
        ),
        Reward(
          id: '3',
          title: 'Task Champion',
          description: 'Complete 10 tasks',
          pointsRequired: 100,
        ),
      ];
      await _saveRewards();
    }
  }

  Future<void> _loadUserPoints() async {
    final prefs = await SharedPreferences.getInstance();
    _userPoints = prefs.getInt('userPoints') ?? 0;
    notifyListeners();
  }

  Future<void> _saveRewards() async {
    final prefs = await SharedPreferences.getInstance();
    final rewardsJson = json.encode(_rewards.map((reward) => reward.toJson()).toList());
    await prefs.setString('rewards', rewardsJson);
  }

  Future<void> _saveUserPoints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userPoints', _userPoints);
  }

  Future<void> addPoints(int points) async {
    _userPoints += points;
    await _saveUserPoints();
    notifyListeners();
  }

  Future<void> claimReward(String rewardId) async {
    final reward = _rewards.firstWhere((r) => r.id == rewardId);
    if (!reward.isClaimed && _userPoints >= reward.pointsRequired) {
      final index = _rewards.indexWhere((r) => r.id == rewardId);
      _rewards[index] = reward.copyWith(
        isClaimed: true,
        claimedAt: DateTime.now(),
      );
      _userPoints -= reward.pointsRequired;
      await _saveRewards();
      await _saveUserPoints();
      notifyListeners();
    }
  }

  Future<void> addReward(Reward reward) async {
    _rewards.add(reward);
    await _saveRewards();
    notifyListeners();
  }

  Future<void> updateReward(Reward reward) async {
    final index = _rewards.indexWhere((r) => r.id == reward.id);
    if (index != -1) {
      _rewards[index] = reward;
      await _saveRewards();
      notifyListeners();
    }
  }

  Future<void> deleteReward(String rewardId) async {
    _rewards.removeWhere((reward) => reward.id == rewardId);
    await _saveRewards();
    notifyListeners();
  }
} 