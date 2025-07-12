import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_suitmedia/models/user_models.dart';
import 'package:test_suitmedia/providers/ThirdScreen_provider.dart';

/// Third Screen yang menampilkan daftar user dari API regres.in
class ThirdScreen extends StatefulWidget {
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  late ScrollController _scrollController;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    
    // Load pengguna saat inisialisasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userProvider = Provider.of<UserProvider>(context, listen: false);
      if (_userProvider.users.isEmpty) {
        _userProvider.loadUsers();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Listener untuk detect scroll sampai bottom untuk load lengkap
  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _userProvider.loadMoreUsers();
    }
  }

  /// menampilkan pesan error
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            _userProvider.clearError();
          },
        ),
      ),
    );
  }

  /// Build empty state widget ketika tidak ada data
  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_outline,
                size: 80,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'No users found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Pull down to refresh',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build user item widget untuk setiap user dalam list
  Widget _buildUserItem(User user) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey[300],
          child: ClipOval(
            child: Image.network(
              user.avatar,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.person,
                  size: 28,
                  color: Colors.grey[600],
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 56,
                  height: 56,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        title: Text(
          user.fullName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            user.email,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
        onTap: () {
          _userProvider.selectUser(user);
          Navigator.pop(context);
        },
      ),
    );
  }

  /// peroses loading indikator
  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2B637B)),
      ),
    );
  }

  /// Build load more indicator untuk pagination
  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2B637B)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Third Screen',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          _userProvider = userProvider;

          if (userProvider.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showError(userProvider.error!);
            });
          }

          // Jika sedang loading dan tidak ada pengguna
          if (userProvider.isLoading && userProvider.users.isEmpty) {
            return _buildLoadingIndicator();
          }

          // Jika tidak ada pengguna dan tidak dalam proses loading
          if (userProvider.users.isEmpty && !userProvider.isLoading) {
            return RefreshIndicator(
              onRefresh: userProvider.refreshUsers,
              color: Color(0xFF2B637B),
              child: _buildEmptyState(),
            );
          }

          // menampilkan daftar pengguna
          return RefreshIndicator(
            onRefresh: userProvider.refreshUsers,
            color: Color(0xFF2B637B),
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.only(top: 8, bottom: 16),
              itemCount: userProvider.users.length + 
                        (userProvider.hasMore && userProvider.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < userProvider.users.length) {
                  return _buildUserItem(userProvider.users[index]);
                } else {
                  return _buildLoadMoreIndicator();
                }
              },
            ),
          );
        },
      ),
    );
  }
}