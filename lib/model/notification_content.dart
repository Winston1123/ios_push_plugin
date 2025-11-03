import 'dart:convert';

/// 通知附件
class NotificationAttachment {
  final String? identifier;
  final String? url;
  final String? type;

  NotificationAttachment({this.identifier, this.url, this.type});

  factory NotificationAttachment.fromJson(Map<String, dynamic> json) {
    return NotificationAttachment(
      identifier: json['identifier'],
      url: json['url'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() => {
        'identifier': identifier,
        'url': url,
        'type': type,
      };
}

/// payload 结构
class NotificationPayload {
  final String? targetUrl;
  final String? actionType;

  NotificationPayload({this.targetUrl, this.actionType});

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    return NotificationPayload(
      targetUrl: json['target_url'],
      actionType: json['action_type'],
    );
  }

  Map<String, dynamic> toJson() => {
        'target_url': targetUrl,
        'action_type': actionType,
      };
}

/// custom_data 结构
class NotificationCustomData {
  final String? appUrl;
  final String? scene;
  final String? targetUrl;
  final String? businessLogId;
  final String? pathType;
  final String? actionType;
  final int? timestamp;

  NotificationCustomData({
    this.appUrl,
    this.scene,
    this.targetUrl,
    this.businessLogId,
    this.pathType,
    this.actionType,
    this.timestamp,
  });

  factory NotificationCustomData.fromJson(Map<String, dynamic> json) {
    return NotificationCustomData(
      appUrl: json['appurl'],
      scene: json['scene'],
      targetUrl: json['target_url'],
      businessLogId: json['business_log_id'],
      pathType: json['pathtype'],
      actionType: json['action_type'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() => {
        'appurl': appUrl,
        'scene': scene,
        'target_url': targetUrl,
        'business_log_id': businessLogId,
        'pathtype': pathType,
        'action_type': actionType,
        'timestamp': timestamp,
      };
}

/// NotificationContent Dart 模型
class NotificationContent {
  final List<NotificationAttachment>? attachments;
  final int? badge;
  final String? body;
  final String? categoryIdentifier;
  final String? launchImageName;
  final String? sound;
  final String? subtitle;
  final String? threadIdentifier;
  final String? title;
  final Map<String, dynamic>? userInfo;
  final NotificationPayload? payload;
  final NotificationCustomData? customData;

  final String? summaryArgument;
  final int? summaryArgumentCount;
  final String? targetContentIdentifier;
  final String? interruptionLevel;
  final double? relevanceScore;
  final String? filterCriteria;

  NotificationContent({
    this.attachments,
    this.badge,
    this.body,
    this.categoryIdentifier,
    this.launchImageName,
    this.sound,
    this.subtitle,
    this.threadIdentifier,
    this.title,
    this.userInfo,
    this.payload,
    this.customData,
    this.summaryArgument,
    this.summaryArgumentCount,
    this.targetContentIdentifier,
    this.interruptionLevel,
    this.relevanceScore,
    this.filterCriteria,
  });

  factory NotificationContent.fromJson(Map<String, dynamic> json) {
    final userInfo = json['userInfo'] as Map<String, dynamic>? ?? {};

    return NotificationContent(
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => NotificationAttachment.fromJson(e))
          .toList(),
      badge: json['badge'],
      body: json['body'],
      categoryIdentifier: json['categoryIdentifier'],
      launchImageName: json['launchImageName'],
      sound: json['sound']?.toString(),
      subtitle: json['subtitle'],
      threadIdentifier: json['threadIdentifier'],
      title: json['title'],
      userInfo: userInfo,
      payload: userInfo.containsKey('payload')
          ? NotificationPayload.fromJson(userInfo['payload'])
          : null,
      customData: userInfo.containsKey('custom_data')
          ? NotificationCustomData.fromJson(userInfo['custom_data'])
          : null,
      summaryArgument: json['summaryArgument'],
      summaryArgumentCount: json['summaryArgumentCount'],
      targetContentIdentifier: json['targetContentIdentifier'],
      interruptionLevel: json['interruptionLevel']?.toString(),
      relevanceScore: (json['relevanceScore'] != null)
          ? (json['relevanceScore'] as num).toDouble()
          : null,
      filterCriteria: json['filterCriteria'],
    );
  }

  Map<String, dynamic> toJson() => {
        'attachments': attachments?.map((e) => e.toJson()).toList(),
        'badge': badge,
        'body': body,
        'categoryIdentifier': categoryIdentifier,
        'launchImageName': launchImageName,
        'sound': sound,
        'subtitle': subtitle,
        'threadIdentifier': threadIdentifier,
        'title': title,
        'userInfo': userInfo,
        'payload': payload?.toJson(),
        'custom_data': customData?.toJson(),
        'summaryArgument': summaryArgument,
        'summaryArgumentCount': summaryArgumentCount,
        'targetContentIdentifier': targetContentIdentifier,
        'interruptionLevel': interruptionLevel,
        'relevanceScore': relevanceScore,
        'filterCriteria': filterCriteria,
      };

  String toJsonString() => json.encode(toJson());
}
