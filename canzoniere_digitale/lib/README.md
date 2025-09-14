# Struttura della cartella `lib/`

Questa cartella contiene tutta la logica principale dell’app Flutter.  
La suddivisione segue l’architettura **Clean Architecture / Feature First**, quindi separando **core** (funzionalità condivise) e **features** (moduli indipendenti).

---

## 📂 `lib/`
Contiene il file `main.dart` e l’entry point dell’applicazione.

- **main.dart** → punto di avvio dell’app, inizializza i widget principali e avvia il `MaterialApp`.

---

## 📂 `core/`
Contiene classi e funzioni **riutilizzabili in più parti dell’app**.

### 📂 `core/utils/`
Utility e helper generici:
- **file_loader.dart** → gestisce il caricamento dei file `.chordpro` dal filesystem.
- **chord_transposer.dart** → contiene la logica per **trasporre gli accordi** (supporto note latine).
  
### 📂 `core/widgets/`
Widget generici e riutilizzabili:
- **custom_lyrics_line.dart** → renderizza una singola riga di testo con eventuali accordi.
- **lyrics_renderer_wrapper.dart** → wrapper per mostrare un intero testo con accordi, pronto all’uso.
- **search_bar.dart** → widget di ricerca riutilizzabile (in varie pagine dell’app).

---

## 📂 `features/`
Contiene le **feature verticali** dell’app.  
Ogni feature segue la suddivisione **data → domain → presentation**.

---

### 📂 `features/song/`
Tutto ciò che riguarda la gestione dei **canti**.

#### 📂 `data/`
Gestione dei dati (fonti, repository, modelli DTO):
- **song_datasource.dart** → gestisce l’accesso ai file sorgente dei canti.
- **song_model.dart** → rappresentazione di un canto in memoria (titolo, accordi, sezioni…).
- **song_repository.dart** → coordina il caricamento dei canti e fornisce metodi pronti all’uso al dominio.

#### 📂 `domain/`
Contiene la logica di business pura:
- **chord_model.dart** → modello di un singolo accordo (tonalità, bemolle/diesis, ecc.).
- **parse_chordpro.dart** → parser che interpreta i file `.chordpro` e li trasforma in `Song`.
- **song_service.dart** → logica applicativa di alto livello, ad esempio trasposizione e gestione accordi.

#### 📂 `presentation/`
Contiene gli elementi dell’interfaccia utente legati ai canti:
- **song_list_page.dart** → pagina che mostra la lista di tutti i canti (con barra di ricerca).
- **song_view_page.dart** → pagina di dettaglio di un canto (testo + accordi, pulsanti per trasposizione, visibilità accordi, ecc.).
- **song_view_model.dart** → classe (ancora in evoluzione) pensata per contenere lo **stato reattivo** della `SongViewPage`. Potrebbe essere usata se si adotta `Provider` o `Riverpod` per gestire meglio stato come trasposizione, visibilità accordi, ecc.

---

## 🔮 Possibili estensioni future
- Aggiungere altre `features/` per preferiti, playlist, eventi liturgici ecc.
- Migliorare la gestione dello stato (`song_view_model` + `Provider/Riverpod`).
- Aggiungere supporto per scroll automatico parametrizzabile.
- Migliorare l’accessibilità (scalabilità testo, temi, dark mode).
