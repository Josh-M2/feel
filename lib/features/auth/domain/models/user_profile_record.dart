class UserProfileRecord {
  const UserProfileRecord({
    required this.userId,
    this.displayName,
    this.primaryTimezone,
  });

  final String userId;
  final String? displayName;
  final String? primaryTimezone;

  factory UserProfileRecord.fromRow(Map<String, dynamic> row) {
    return UserProfileRecord(
      userId: row['user_id'].toString(),
      displayName: row['display_name']?.toString(),
      primaryTimezone: row['primary_timezone']?.toString(),
    );
  }
}
