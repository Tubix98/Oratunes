const fs = require('fs');
const crypto = require('crypto');
const path = require('path');

const songsDir = path.join(__dirname, '../songs');

// prende solo i file .md
const files = fs.readdirSync(songsDir).filter(f => f.endsWith('.md'));

const songs = files.map(file => {
  const fullPath = path.join(songsDir, file);
  const content = fs.readFileSync(fullPath, 'utf8');

  // hash del contenuto (per aggiornamenti futuri)
  const hash = crypto
    .createHash('md5')
    .update(content)
    .digest('hex');

  // id = nome file senza estensione
  const id = path.basename(file, '.md');

  // prova a leggere il titolo dal markdown (es: "title: Gloria")
  const titleMatch = content.match(/title:\s*(.+)/i);
  const title = titleMatch ? titleMatch[1].trim() : id;

  return {
    id,
    title,
    hash
  };
});

const index = {
  version: 1,
  generatedAt: new Date().toISOString(),
  songs
};

fs.writeFileSync(
  path.join(songsDir, 'index.json'),
  JSON.stringify(index, null, 2),
  'utf8'
);

console.log('index.json generato correttamente');
