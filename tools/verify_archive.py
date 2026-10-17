"""Verify archived payload without changing files or contacting a printer."""
from pathlib import Path
import hashlib
import json
import zipfile

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
        if path.suffix in {'.3mf', '.zip'}:
            with zipfile.ZipFile(path) as archive:
                if archive.testzip() is not None:
                    errors.append(f'Corrupt archive: {item["path"]}')
        if path.suffix == '.json':
            json.loads(path.read_text(encoding='utf-8-sig'))
    if errors:
        raise SystemExit('\n'.join(errors))
    print(f'OK: {len(catalog["artifacts"])} artifacts; checksums, ZIPs and JSON verified.')

if __name__ == '__main__':
    main()
