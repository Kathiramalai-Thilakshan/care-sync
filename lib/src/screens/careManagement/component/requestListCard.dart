import 'package:care_sync/src/component/text/bodyText.dart';
import 'package:care_sync/src/component/text/primaryText.dart';
import 'package:care_sync/src/models/enums/userRole.dart';
import 'package:care_sync/src/models/user/careGiverRequest.dart';
import 'package:care_sync/src/models/user/userSummary.dart';
import 'package:care_sync/src/theme/customColors.dart';
import 'package:care_sync/src/utils/textFormatUtils.dart';
import 'package:flutter/material.dart';

import '../../../component/badge/simpleBadge.dart';
import '../../../component/text/btnText.dart';
import '../../../component/text/subText.dart';
import '../../../models/enums/careGiverPermission.dart';

class RequestListCard extends StatelessWidget {
  final CareGiverRequest request;
  final UserRole role;
  final void Function(bool) responseRequest;

  const RequestListCard(
      {super.key,
      required this.request,
      required this.role,
      required this.responseRequest});

  @override
  Widget build(BuildContext context) {
    UserSummary userSummary =
        role == UserRole.CAREGIVER ? request.toUser : request.fromUser;
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(text: userSummary.name),
                const SizedBox(height: 4),
                BodyText(
                  text: userSummary.email,
                ),
                const SizedBox(height: 4),
                SubText(
                  text: TextFormatUtils.formatDateTime(request.requestedAt),
                ),
                const SizedBox(height: 4),
                SimpleBadge(
                  color: _getStatusColor(request.requestedPermission, context),
                  child: Text(
                    TextFormatUtils.formatEnum(request.requestedPermission),
                    style: TextStyle(
                      color:
                          _getStatusColor(request.requestedPermission, context),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            if (role == UserRole.PATIENT)
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).extension<CustomColors>()?.success,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      responseRequest(true);
                    },
                    child: BtnText(
                        text: "Accept",
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      responseRequest(false);
                    },
                    child: BtnText(
                        text: "Cancel",
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(CareGiverPermission permission, BuildContext context) {
    switch (permission) {
      case CareGiverPermission.FULL_ACCESS:
        return Colors.green;
      case CareGiverPermission.VIEW_ONLY:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
