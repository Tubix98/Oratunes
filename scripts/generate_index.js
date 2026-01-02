const fs = require('fs');
const crypto = require('crypto');
const path = require('path');

const songsDir = path.join(__dirname, '../songs');
const files = fs.readdirSync(songsDir).filter(f => f.endsWith('.md'));

const songs = files.map(file => {
  const content = fs.readFileSync(path.join(songsDir, file), 'utf8');
  const hash = crypto.createHash('md5').update(content).digest('hex');

  const titleMatch = content.match(/title:\s*(.+)/);
  const title = titleMatch ? titleMatch[1].trim() : file;

  return { file, hash, title };
});

const index = {
  version: 1,
  generatedAt: new Date().toISOString(),
  songs
};

fs.writeFileSync(
  path.join(songsDir, 'index.json'),
  JSON.stringify(index, null, 2)
);

console.log('index.json generato');
