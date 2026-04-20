#!/usr/bin/env bash
set -euo pipefail

python3 - <<'PY'
import sys
sys.path.insert(0, 'scripts')
import repo_meta

rows = []
for entry in repo_meta.load_registry('agents'):
    meta = repo_meta.load_agent_meta(entry['name'])
    rows.append({
        'name': entry['name'],
        'enabled': 'enabled' if entry['enabled'] else 'disabled',
        'path': entry['path'],
        'image': f"{meta['image_repository']}:{meta['image_tag']}",
    })

headers = ['NAME', 'STATUS', 'DEFAULT_IMAGE', 'PATH']
widths = {
    'NAME': max(len(headers[0]), *(len(r['name']) for r in rows)) if rows else len(headers[0]),
    'STATUS': max(len(headers[1]), *(len(r['enabled']) for r in rows)) if rows else len(headers[1]),
    'DEFAULT_IMAGE': max(len(headers[2]), *(len(r['image']) for r in rows)) if rows else len(headers[2]),
    'PATH': max(len(headers[3]), *(len(r['path']) for r in rows)) if rows else len(headers[3]),
}

print(
    f"{headers[0]:<{widths['NAME']}}  {headers[1]:<{widths['STATUS']}}  {headers[2]:<{widths['DEFAULT_IMAGE']}}  {headers[3]:<{widths['PATH']}}"
)
for row in rows:
    print(
        f"{row['name']:<{widths['NAME']}}  {row['enabled']:<{widths['STATUS']}}  {row['image']:<{widths['DEFAULT_IMAGE']}}  {row['path']:<{widths['PATH']}}"
    )
PY
