# App Canzoniere Digitale

Applicazione per la gestione del canzoniere parrocchiale, sviluppata per sostituire il file Word esistente con una soluzione moderna, veloce e multi-piattaforma (iPad/Android).

## Obiettivo

L'obiettivo è creare uno strumento digitale per musicisti e animatori liturgici che semplifichi la ricerca, la visualizzazione e l'utilizzo dei canti durante le celebrazioni e le prove.

## Funzionalità Principali

- **Organizzazione Flessibile:** Canti suddivisi per sezioni (Liturgici, Oratorio, ecc.) e tag tematici (Ingresso, Natale, Offertorio...).
- **Ricerca Veloce:** Trova i canti per titolo o testo.
- **Trasposizione Accordi:** Alza o abbassa la tonalità di qualsiasi canto in tempo reale.
- **Visualizzazione Pulita:** Possibilità di nascondere gli accordi per una lettura solo testo.
- **Multi-Piattaforma:** Sviluppato con Flutter per funzionare nativamente su iOS e Android.

## Struttura del Progetto

- **`/lib`**: Contiene tutto il codice sorgente dell'applicazione Flutter.
- **`/assets/songs`**: **Questa è la cartella più importante per la gestione dei canti.** Ogni canto è un singolo file `.cho`, nominato in modo descrittivo (es. `abbracciami.cho`).

### Come Aggiungere un Nuovo Canto

1.  Crea un nuovo file di testo nella cartella `/assets/songs`.
2.  Nomina il file in formato `titolo_canzone.cho` (tutto minuscolo, senza spazi).
3.  Formatta il contenuto del file secondo la struttura ChordPro definita.
4.  Fai un `commit` e un `push` per caricare le modifiche su GitHub.
