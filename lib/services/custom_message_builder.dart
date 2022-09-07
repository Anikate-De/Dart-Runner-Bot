import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

class CustomMessageBuilder {
  static ComponentMessageBuilder build({
    String? title,
    String? description,
    List<EmbedFieldBuilder>? fields,
    String? authorName,
  }) {
    ComponentMessageBuilder componentMessageBuilder = ComponentMessageBuilder();

    EmbedBuilder embed = EmbedBuilder()
      ..addFooter((EmbedFooterBuilder footer) {
        footer.text =
            'Love this bot? Star it on GitHub:\nhttps://github.com/Anikate-De/Dart-Runner-Bot';
        footer.iconUrl = 'https://avatars.githubusercontent.com/u/40452578?v=4';
      });

    embed.author = EmbedAuthorBuilder()
      ..iconUrl = 'https://dartpad.dev/dart-192.png'
      ..name = authorName ?? 'Dart Runner Bot';

    if (title != null) embed.title = title;
    if (description != null) embed.description = description;
    if (fields != null) embed.fields.addAll(fields);

    embed.color = DiscordColor.dartBlue;
    embed.timestamp = DateTime.now();

    componentMessageBuilder.embeds = <EmbedBuilder>[embed];

    return componentMessageBuilder;
  }
}
