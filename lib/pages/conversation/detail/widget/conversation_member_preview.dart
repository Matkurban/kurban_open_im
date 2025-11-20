import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kurban_open_im/widgets/avatar_view.dart';

class ConversationMemberPreview extends StatelessWidget {
  const ConversationMemberPreview({
    super.key,
    required this.members,
    this.onViewAll,
    this.onMemberTap,
    this.title,
  });

  final List<GroupMembersInfo> members;
  final VoidCallback? onViewAll;
  final ValueChanged<GroupMembersInfo>? onMemberTap;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayMembers = members.take(9).toList();
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title ?? '群成员', style: theme.textTheme.titleMedium),
                const Spacer(),
                if (onViewAll != null) TextButton(onPressed: onViewAll, child: const Text('查看全部')),
              ],
            ),
            Gap(12.h),
            Wrap(
              spacing: 16.w,
              runSpacing: 16.h,
              children: displayMembers
                  .map((member) => _ConversationMemberItem(member: member, onTap: onMemberTap))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationMemberItem extends StatelessWidget {
  const _ConversationMemberItem({required this.member, this.onTap});

  final GroupMembersInfo member;
  final ValueChanged<GroupMembersInfo>? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = member.nickname?.isNotEmpty == true
        ? member.nickname!
        : (member.userID ?? '');
    return GestureDetector(
      onTap: onTap != null ? () => onTap!(member) : null,
      child: SizedBox(
        width: 64.w,
        child: Column(
          children: [
            AvatarView(url: member.faceURL, name: displayName),
            Gap(6.h),
            Text(
              displayName,
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
