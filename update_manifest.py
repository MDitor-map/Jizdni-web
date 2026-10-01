#!/usr/bin/env python3
"""
Scan le dossier ./publish/ et régénère automatiquement manifest.json
à partir de tous les fichiers article-*.json trouvés.
"""

import json
import os
from datetime import datetime

PUBLISH_DIR = './publish'

def update_manifest():
    articles = []
    
    # Parcourir tous les fichiers article-*.json
    for filename in sorted(os.listdir(PUBLISH_DIR)):
        if filename.startswith('article-') and filename.endswith('.json'):
            filepath = os.path.join(PUBLISH_DIR, filename)
            with open(filepath, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            articles.append({
                "id": data.get("id", filename.replace('article-', '').replace('.json', '')),
                "title": data.get("title", "Sans titre"),
                "date": data.get("date", ""),
                "location": data.get("location", ""),
                "filename": filename
            })
    
    # Trier par date (plus récent en premier)
    articles.sort(key=lambda x: x.get("date", ""), reverse=True)
    
    manifest = {
        "articles": articles,
        "lastUpdated": datetime.now().isoformat()
    }
    
    manifest_path = os.path.join(PUBLISH_DIR, 'manifest.json')
    with open(manifest_path, 'w', encoding='utf-8') as f:
        json.dump(manifest, f, indent=2, ensure_ascii=False)
    
    print(f"✅ manifest.json mis à jour avec {len(articles)} article(s)")
    for a in articles:
        print(f"   - {a['title']} ({a['filename']})")

if __name__ == '__main__':
    update_manifest()
