// Simple Either implementation for handling success/failure states
class Either<L, R> {
  final L? _left;
  final R? _right;

  Either.left(L left) : _left = left, _right = null;
  Either.right(R right) : _left = null, _right = right;

  bool get isLeft => _left != null;
  bool get isRight => _right != null;

  L get left => _left!;
  R get right => _right!;

  T fold<T>(T Function(L) leftFn, T Function(R) rightFn) {
    return isLeft ? leftFn(_left!) : rightFn(_right!);
  }
}
