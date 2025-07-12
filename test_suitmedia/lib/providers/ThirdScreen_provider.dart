import 'package:flutter/material.dart';
import 'package:test_suitmedia/models/user_models.dart';
import 'package:test_suitmedia/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _error;
  String _selectedUserName = 'Selected User Name';
  User? _selectedUser;

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  String? get error => _error;
  String get selectedUserName => _selectedUserName;
  User? get selectedUser => _selectedUser;

  // Inisialisasi pengguna
  Future<void> loadUsers({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
      _currentPage = 1;
      _error = null;
      _hasMore = true;
    } else {
      _isLoading = true;
      _error = null;
    }
    notifyListeners();

    try {
      final userResponse = await UserService.fetchUsers(_currentPage, 10);

      if (isRefresh) {
        _users = userResponse.data;
      } else {
        _users.addAll(userResponse.data);
      }

      _hasMore = _currentPage < userResponse.totalPages;
      _error = null;

      print(
          'Loaded ${userResponse.data.length} users, page $_currentPage/${userResponse.totalPages}');
    } catch (e) {
      _error = 'Failed to load users: ${e.toString()}';
      print('Error loading users: $e');
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  // Load lebih banyak pengguna
  Future<void> loadMoreUsers() async {
    if (_hasMore && !_isLoadingMore && !_isLoading && !_isRefreshing) {
      _isLoadingMore = true;
      _currentPage++;
      notifyListeners();

      try {
        final userResponse = await UserService.fetchUsers(_currentPage, 10);
        _users.addAll(userResponse.data);
        _hasMore = _currentPage < userResponse.totalPages;
        _error = null;

        print(
            'Loaded more ${userResponse.data.length} users, page $_currentPage/${userResponse.totalPages}');
      } catch (e) {
        _error = 'Failed to load more users: ${e.toString()}';
        _currentPage--; 
        print('Error loading more users: $e');
      } finally {
        _isLoadingMore = false;
        notifyListeners();
      }
    }
  }

  // load ulang pengguna
  Future<void> refreshUsers() async {
    await loadUsers(isRefresh: true);
  }

  // pilih pengguna
  void selectUser(User user) {
    _selectedUser = user;
    _selectedUserName = user.fullName;
    notifyListeners();
    print('Selected user: ${user.fullName}');
  }


  void clearError() {
    _error = null;
    notifyListeners();
  }

  // reset pengguna yang dipilih
  void clearSelection() {
    _selectedUser = null;
    _selectedUserName = 'Selected User Name';
    notifyListeners();
  }

  // hapus data ketika pindah halaman
  void clearData() {
    _users.clear();
    _currentPage = 1;
    _hasMore = true;
    _error = null;
    _isLoading = false;
    _isRefreshing = false;
    _isLoadingMore = false;
    notifyListeners();
  }
}
