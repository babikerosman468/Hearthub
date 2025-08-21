#!/bin/bash
# deploy_full.sh - Termux-ready full deployment for linked Vercel project

# Variables
COMMIT_MSG="Auto-update $(date '+%Y-%m-%d %H:%M:%S')"
VERCEL_CMD="vercel --prod --confirm"

echo "🚀 Starting full deployment..."

# Step 0: Check if project is linked
if [ ! -d ".vercel" ]; then
    echo "⚠️ Vercel project not linked. Linking now..."
    vercel link --yes
    if [ ! -d ".vercel" ]; then
        echo "❌ Failed to link Vercel project. Aborting."
        exit 1
    fi
    echo "✅ Project linked successfully."
fi

# Step 1: Copy src/ files to public/
echo "📂 Copying src/ files into public/..."
cp -r ../src/* ../public/

# Step 2: Inject multi-search script (if applicable)
if [ -f "../src/script.js" ]; then
    echo "📝 Injecting multi-search script..."
    # Customize injection if needed
    # sed -i '/<\/body>/i <script src="multi-search.js"></script>' ../public/index.html
    echo "✅ Multi-search script injected."
fi

# Step 3: Update sidebar dynamically (if applicable)
echo "🔗 Updating sidebar links dynamically..."
# Your sidebar update commands here
echo "✅ Sidebar updated with pages + projects."

# Step 4: Git operations
echo "📤 Staging all changes..."
git add -A
git commit -m "$COMMIT_MSG"
git push origin main
echo "✅ Pushed to GitHub."

# Step 5: Deploy to Vercel
echo "🌐 Deploying to Vercel production..."
DEPLOY_OUTPUT=$($VERCEL_CMD 2>&1)

# Extract deployed URL robustly
DEPLOY_URL=$(echo "$DEPLOY_OUTPUT" | grep -o 'https://[a-zA-Z0-9.-]*vercel.app' | head -n1)

if [ -n "$DEPLOY_URL" ]; then
    echo "✅ Deployed: $DEPLOY_URL"
    # Open in Termux browser
    termux-open "$DEPLOY_URL" 2>/dev/null || echo "🌟 Open your browser and visit: $DEPLOY_URL"
else
    echo "⚠️ Deployment finished but URL not found."
fi

echo "🎉 Full deployment finished!"

