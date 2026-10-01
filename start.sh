#!/bin/bash

# Script de démarrage du serveur Python pour Jízdní Magazine

echo " Démarrage du serveur Jízdní..."
echo "📁 Répertoire: $(pwd)"

# Vérifier si Python 3 est installé
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

# Mettre à jour le manifest automatiquement si le script existe
if [ -f "update_manifest.py" ]; then
    echo "🔄 Mise à jour du manifest..."
    python3 update_manifest.py
    echo ""
fi

PORT=8000
URL="http://localhost:${PORT}"

echo "🌐 Serveur accessible sur: ${URL}"
echo "  Pour arrêter: Ctrl+C"
echo ""

# Fonction pour ouvrir le navigateur selon l'OS
open_browser() {
    case "$OSTYPE" in
        linux-gnu*)
            if command -v xdg-open &> /dev/null; then
                xdg-open "$URL"
            else
                echo "⚠️  xdg-open non trouvé, impossible d'ouvrir le navigateur automatiquement"
            fi
            ;;
        darwin*)
            open "$URL"
            ;;
        msys*|mingw*|cygwin*)
            start "$URL"
            ;;
        *)
            echo "⚠️  Système non reconnu, impossible d'ouvrir le navigateur automatiquement"
            ;;
    esac
}

# Lancer le serveur en arrière-plan pour ouvrir le navigateur
python3 -m http.server $PORT &
SERVER_PID=$!

# Attendre un peu que le serveur démarre
sleep 1

# Ouvrir le navigateur
open_browser

echo "✅ Serveur lancé (PID: $SERVER_PID)"
echo ""

# Ramener le serveur au premier plan
wait $SERVER_PID
