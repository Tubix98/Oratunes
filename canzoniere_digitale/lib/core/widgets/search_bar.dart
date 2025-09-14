import 'package:flutter/material.dart';

/// Un widget riutilizzabile per la ricerca.
/// Lo puoi inserire in qualsiasi pagina, passandogli una callback
/// che riceve il testo aggiornato.
/// Puoi personalizzare il testo di suggerimento (hintText).
///
/// Cosa si può aggiungere:
/// - Supporto per ricerca avanzata (filtri, categorie).
/// - Integrazione con un debounce per evitare chiamate troppo frequenti.
/// - Stile personalizzato (colore, dimensione, icona).

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  const SearchBarWidget({
    super.key,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: hintText,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.search),
        ),
        onChanged: (value) {
          onChanged(value.toLowerCase());
        },
      ),
    );
  }
}
