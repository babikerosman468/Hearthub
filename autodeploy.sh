
#!/bin/bash
# autodeploy.sh - Push all changes to GitHub and deploy to Vercel

echo "🚀 Starting auto-deploy..."

# Go to project folder
cd ~/Hearthub || exit

# Stage all changes
git add -A
echo "✅ All changes staged."

# Commit with timestamp
git commit -m "Auto-update $(date '+%Y-%m-%d %H:%M:%S')"
echo "✅ Commit done."

# Push to GitHub
git push origin main
echo "✅ Pushed to GitHub."

# Deploy to Vercel (production)
vercel --prod --confirm
echo "✅ Deployed to Vercel."

echo "🎉 Auto-deploy finished!"

