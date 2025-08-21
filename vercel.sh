
#!/bin/bash
# vercel_update.sh - Termux-ready update + deploy + verify + open live pages in Chrome

echo ">>> Checking required files..."
FILES=("index.html" "dashboard.html" "vision_mission.html" "contact.html")
for f in "${FILES[@]}"; do
  if [ ! -f "$f" ]; then
    echo "⚠️ File missing: $f"
  fi
done

echo ">>> Updating index.html links to dashboard.html..."
sed -i 's/href="copy.html"/href="dashboard.html"/g' index.html

echo ">>> Committing changes to GitHub..."
git add .
git commit -m "Update: ensure dashboard.html and links"
git push origin main

echo ">>> Deploying to Vercel..."
vercel --prod --confirm

# Verification
SITE_URL="https://hearthub-65y6dzdwe-babikerosmans-projects.vercel.app"
PAGES=("index.html" "dashboard.html" "vision_mission.html" "contact.html")

echo ">>> Verifying deployed pages..."
for page in "${PAGES[@]}"; do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL/$page")
  if [ "$STATUS" -eq 200 ]; then
    echo "✅ $page is live!"
  elif [ "$STATUS" -eq 401 ] || [ "$STATUS" -eq 403 ]; then
    echo "⚠️ $page is private or access is restricted (HTTP $STATUS)."
  else
    echo "❌ $page returned HTTP $STATUS"
  fi
done

# Open homepage and dashboard in Chrome
echo ">>> Opening homepage and dashboard in Chrome..."
termux-open "$SITE_URL/index.html"
termux-open "$SITE_URL/dashboard.html"

echo ">>> Deployment, verification, and opening complete!"

