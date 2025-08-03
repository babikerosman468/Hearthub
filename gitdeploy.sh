
#!/data/data/com.termux/files/usr/bin/bash

# -----------------------------------------------
# gitdeploy.sh — Status → Pull → Commit → Push
# Usage: ./gitdeploy.sh "Your commit message"
# -----------------------------------------------

echo "📌 Checking status..."
git status

echo "🔄 Pulling latest changes..."
git pull origin main

if [ -z "$1" ]; then
  msg="Update"
else
  msg="$1"
fi

echo "📂 Staging all files..."
git add -A

echo "📝 Committing with message: \"$msg\""
git commit -m "$msg"

echo "🚀 Pushing to origin/main..."
git push origin main

echo "✅ Deploy complete!"


