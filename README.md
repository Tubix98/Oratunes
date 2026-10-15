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
la gestione dei canti.** Ogni canto è un singolo file `.md`, nominato in modo descrittivo (es. `abbracciami.md`).

### Come Aggiungere un Nuovo Canto

1.  Crea un nuovo file di testo nella cartella `/songs`.
2.  Nomina il file in formato `titolo_canzone.md` (tutto minuscolo, senza spazi).
3.  Formatta il contenuto del file secondo la struttura MD definita.
4.  Esegui il comando da /Oratunes: node ./scripts/generate_index.js
5.  Fai un `commit` e un `push` per caricare le modifiche su GitHub.

# 🎵 Formato canzoni – Markdown Oratunes

Oratunes utilizza un formato Markdown proprietario e semplificato per la scrittura e la gestione dei canti.
Questo formato è lo standard ufficiale dell’app ed è progettato per essere leggibile, coerente e
100% compatibile con il parser interno.

Ogni canto deve essere salvato in un singolo file con estensione `.md`.

## Struttura generale

Ogni file è composto da due parti:
1. Front matter YAML (obbligatorio)
2. Corpo del canto (Markdown semplificato)

## Front matter (obbligatorio)

Ogni file deve iniziare con un blocco YAML delimitato da `---`.
I metadati devono comparire solo in questa sezione e mai nel corpo del canto.

Campi supportati:
- title: titolo del canto
- section: sezione o categoria
- author: autore
- key: tonalità
- tags: lista di tag

Struttura:

---
title: Titolo del canto
section: Sezione
author: Autore
key: TONALITÀ
tags: [tag1, tag2]
---

## Corpo del canto

Il corpo del canto è scritto in Markdown semplificato con regole rigide.

### Separazione delle parti

Le righe vuote non sono ammesse.
Ogni separazione logica tra parti del canto (strofe, ritornelli, intro, ponte, finale)
deve essere fatta esclusivamente usando la riga:

***

Questo separatore rappresenta una “riga vuota logica”.

### Commenti e indicazioni musicali

Le indicazioni strutturali o musicali (Intro, Ponte, Finale, ecc.)
devono essere scritte in corsivo, utilizzando un solo asterisco all’inizio e alla fine della riga.

Esempi tipici:
*Intro*
*Ponte (x2)*
*Finale*

### Testo e accordi

Gli accordi devono essere scritti inline, racchiusi tra parentesi quadre `[ ]`.

Il testo del canto deve rimanere inalterato rispetto alla fonte originale.
La posizione degli accordi non deve mai essere modificata.

Sono ammesse:
- righe di testo con accordi inline
- righe composte esclusivamente da accordi

### Ritornello

Ogni riga del ritornello deve essere racchiusa tra doppio asterisco `** **`.

## Sintassi vietata

Non è ammessa alcuna sintassi del formato ChordPro.

Sono vietati, tra gli altri:
- `{}`  
- `{c:}`  
- `{soc}`, `{eoc}`  
- qualsiasi direttiva ChordPro

È inoltre vietato qualsiasi Markdown non esplicitamente previsto da questo standard.

## Regole fondamentali

- Non usare righe vuote
- Usare `***` come unico separatore
- Non modificare mai il testo
- Non spostare mai gli accordi
- Non usare sintassi ChordPro
- Non usare Markdown aggiuntivo

