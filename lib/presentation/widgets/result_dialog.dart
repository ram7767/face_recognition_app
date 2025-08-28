import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/verification_result.dart';

class ResultDialog extends StatelessWidget {
  final User? user;
  final VerificationResult? result;
  final bool isVerification;

  const ResultDialog({
    super.key,
    this.user,
    this.result,
    required this.isVerification,
  });

  @override
  Widget build(BuildContext context) {
    if (isVerification) {
      return _buildVerificationResult(context);
    } else {
      return _buildRegistrationResult(context);
    }
  }

  Widget _buildVerificationResult(BuildContext context) {
    final isVerified = result?.verified ?? false;
    final verifiedUser = result?.user;
    final message = result?.message ?? 'Unknown error';

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            isVerified ? Icons.check_circle : Icons.cancel,
            color: isVerified ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(isVerified ? 'Verified!' : 'Not Verified'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          if (isVerified && verifiedUser != null) ...[
            const SizedBox(height: 16),
            const Text('User Details:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Name: ${verifiedUser.name}'),
            Text('Email: ${verifiedUser.email}'),
            Text('Phone: ${verifiedUser.phone}'),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }

  Widget _buildRegistrationResult(BuildContext context) {
    final isSuccess = user != null;

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            color: isSuccess ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(isSuccess ? 'Registration Successful!' : 'Registration Failed'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isSuccess ? 'User has been registered successfully!' : 'Failed to register user'),
          if (isSuccess && user != null) ...[
            const SizedBox(height: 16),
            const Text('User Details:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('ID: ${user!.id}'),
            Text('Name: ${user!.name}'),
            Text('Email: ${user!.email}'),
            Text('Phone: ${user!.phone}'),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
