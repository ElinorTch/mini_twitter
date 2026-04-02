String timeAgo(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);

  if (diff.inSeconds < 60) {
    return "now";
  } else if (diff.inMinutes < 60) {
    return "${diff.inMinutes} min";
  } else if (diff.inHours < 24) {
    return "${diff.inHours} h";
  } else if (diff.inDays < 7) {
    return "${diff.inDays} d";
  } else if (diff.inDays < 30) {
    return "${(diff.inDays / 7).floor()} w";
  } else if (diff.inDays < 365) {
    return "${(diff.inDays / 30).floor()} m";
  } else {
    return "${(diff.inDays / 365).floor()} y";
  }
}
