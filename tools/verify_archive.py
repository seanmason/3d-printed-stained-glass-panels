"""Verify archived payload without changing files or contacting a printer."""
from pathlib import Path
import hashlib
import json
import zipfile
import re
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parents[1]

def main():
    catalog = json.loads((ROOT / 'catalog.json').read_text(encoding='utf-8'))
    errors = []
    for item in catalog['artifacts']:
        path = ROOT / item['path']
        if not path.is_file():
            errors.append(f'Missing: {item["path"]}')
            continue
        if hashlib.sha256(path.read_bytes()).hexdigest() != item['sha256']:
            errors.append(f'Checksum differs: {item["path"]}')
        if path.stat().st_size != item['bytes']:
            errors.append(f'Size differs: {item["path"]}')
        if item.get('source'):
            source = ROOT / item['source']
            if not source.is_file() or source.read_bytes() != path.read_bytes():
                errors.append(f'Published copy differs from source: {item["path"]}')
        if path.suffix in {'.3mf', '.zip'}:
            with zipfile.ZipFile(path) as archive:
                if archive.testzip() is not None:
                    errors.append(f'Corrupt archive: {item["path"]}')
        if path.suffix == '.json':
            json.loads(path.read_text(encoding='utf-8-sig'))
    for path in ROOT.rglob('*.md'):
        if '.git' in path.parts:
            continue
        for link in re.findall(r'\]\(([^)]+)\)', path.read_text(encoding='utf-8-sig')):
            if re.match(r'^[a-zA-Z]+:', link) or link.startswith('#'):
                continue
            target = unquote(link.split('#')[0].strip('<>'))
            if target and not (path.parent / target).exists():
                errors.append(f'Broken link in {path.relative_to(ROOT)}: {link}')
    if errors:
        raise SystemExit('\n'.join(errors))
    print(f'OK: {len(catalog["artifacts"])} artifacts; checksums, sizes, published copies, ZIPs, JSON and Markdown links verified.')

if __name__ == '__main__':
    main()
