
#!/bin/bash
# vercel_update.sh - Termux-ready update + redeploy to Vercel

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
# Make sure you have Vercel CLI installed: npm i -g vercel
vercel --prod --confirm

echo ">>> Deployment complete! Check your live site."

