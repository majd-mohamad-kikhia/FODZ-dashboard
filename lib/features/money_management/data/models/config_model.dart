class ConfigItem {
  final int? id;
  final String name;
  final String value;

  ConfigItem({
    this.id,
    required this.name,
    required this.value,
  });

  factory ConfigItem.fromJson(Map<String, dynamic> json) {
    return ConfigItem(
      id: json['id'] as int?,
      name: json['name'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'value': value,
    };
  }
}

class ConfigResponse {
  final String message;
  final List<ConfigItem> configs;

  ConfigResponse({
    required this.message,
    required this.configs,
  });

  factory ConfigResponse.fromJson(Map<String, dynamic> json) {
    return ConfigResponse(
      message: json['message'] as String,
      configs: (json['configs'] as List<dynamic>)
          .map((item) => ConfigItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'configs': configs.map((c) => c.toJson()).toList(),
    };
  }
}
