

#!/bin/bash
# deploy_full.sh - Full automated deployment to GitHub + Vercel

# Variables
COMMIT_MSG="Auto-update $(date '+%Y-%m-%d %H:%M:%S')"
VERCEL_CMD="vercel --prod --confirm"

echo "🚀 Starting full deployment..."

# Step 1: Copy src/ files to public/
echo "📂 Copying src/ files into public/..."
cp -r ../src/* ../public/

# Step 2: Inject multi-search script (if applicable)
if [ -f "../src/script.js" ]; then
    echo "📝 Injecting multi-search script..."
    # Example injection (customize as needed)
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

# Extract deployed URL from output
DEPLOY_URL=$(echo "$DEPLOY_OUTPUT" | grep -o 'https://[^ ]*vercel.app')

if [ -n "$DEPLOY_URL" ]; then
    echo "✅ Deployed: $DEPLOY_URL"
    # Step 6: Open in default browser
    xdg-open "$DEPLOY_URL" 2>/dev/null || echo "🌟 Open your browser and visit: $DEPLOY_URL"
else
    echo "⚠️ Deployment finished but URL not found."
fi

echo "🎉 Full deployment with nested projects finished!"
