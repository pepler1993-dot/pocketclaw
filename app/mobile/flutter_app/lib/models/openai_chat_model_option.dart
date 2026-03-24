/// ChatGPT-class models selectable after OpenAI sign-in (IDs match OpenAI API `model` field).
class OpenAiChatModelOption {
  const OpenAiChatModelOption({required this.id, required this.label, this.subtitle});

  final String id;
  final String label;
  final String? subtitle;

  /// Curated list when `/v1/models` is unavailable (offline / mock).
  static const List<OpenAiChatModelOption> defaults = <OpenAiChatModelOption>[
    OpenAiChatModelOption(
      id: 'gpt-4o',
      label: 'GPT-4o',
      subtitle: 'Strong general model',
    ),
    OpenAiChatModelOption(
      id: 'gpt-4o-mini',
      label: 'GPT-4o mini',
      subtitle: 'Faster, lower cost',
    ),
    OpenAiChatModelOption(
      id: 'gpt-4-turbo',
      label: 'GPT-4 Turbo',
      subtitle: 'Large context',
    ),
    OpenAiChatModelOption(
      id: 'o3-mini',
      label: 'o3-mini',
      subtitle: 'Reasoning-focused',
    ),
    OpenAiChatModelOption(
      id: 'gpt-4.1',
      label: 'GPT-4.1',
      subtitle: 'When available on your account',
    ),
  ];
}
