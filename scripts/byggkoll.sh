#!/usr/bin/env bash
# Statiska kontroller för PWA:n. Avslutar med kod 1 om något FEL hittas.
cd "$(dirname "$0")/.." || exit 1

node - <<'JS'
const fs = require('fs');
const { execFileSync } = require('child_process');
let errors = 0, warnings = 0;
const fel = m => { console.log('FEL: ' + m); errors++; };
const varn = m => { console.log('VARNING: ' + m); warnings++; };

// 1. manifest.json är giltig JSON
let manifest = null;
try { manifest = JSON.parse(fs.readFileSync('manifest.json', 'utf8')); }
catch (e) { fel('manifest.json är inte giltig JSON: ' + e.message); }

// 2. sw.js har giltig syntax
try { execFileSync('node', ['--check', 'sw.js'], { stdio: 'pipe' }); }
catch (e) { fel('sw.js syntaxfel:\n' + e.stderr.toString()); }

// 3. JavaScript i index.html har giltig syntax
const html = fs.readFileSync('index.html', 'utf8');
const scripts = [...html.matchAll(/<script(?![^>]*\bsrc=)[^>]*>([\s\S]*?)<\/script>/g)];
scripts.forEach((m, i) => {
  try { new Function(m[1]); }
  catch (e) { fel(`index.html <script> nr ${i + 1}: ${e.message}`); }
});

// 4. Alla filer som sw.js cachar finns
const sw = fs.readFileSync('sw.js', 'utf8');
const assets = sw.match(/ASSETS\s*=\s*\[([^\]]*)\]/);
if (!assets) fel('hittar inte ASSETS-listan i sw.js');
else for (const [, p] of assets[1].matchAll(/'([^']+)'/g)) {
  const file = p === '/' ? 'index.html' : p.replace(/^\//, '');
  if (!fs.existsSync(file)) fel(`sw.js cachar ${p} men ${file} finns inte`);
}

// 5. Ikoner i manifestet finns
if (manifest) for (const icon of manifest.icons || []) {
  if (!fs.existsSync(icon.src)) fel(`manifest-ikon saknas: ${icon.src}`);
}

// 6. theme_color i manifestet matchar <meta name="theme-color">
const meta = html.match(/<meta name="theme-color" content="([^"]+)"/);
if (manifest && meta && manifest.theme_color.toLowerCase() !== meta[1].toLowerCase())
  varn(`theme_color i manifest.json (${manifest.theme_color}) skiljer sig från index.html (${meta[1]})`);

console.log(`\n${errors} fel, ${warnings} varningar`);
process.exit(errors ? 1 : 0);
JS
