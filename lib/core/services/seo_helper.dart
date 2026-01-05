import 'package:universal_html/html.dart' as html;

void setSeo({
  required final String title,
  final String? description,
}) {
  // TITLE
  html.document.title = title;

  // META DESCRIPTION
  if (description != null) {
    final html.MetaElement metaDescription = html.document.head!
            .querySelector('meta[name="description"]') as html.MetaElement? ??
        html.MetaElement()
      ..name = 'description';

    metaDescription.content = description;

    if (!html.document.head!.children.contains(metaDescription)) {
      html.document.head!.append(metaDescription);
    }
  }
}
