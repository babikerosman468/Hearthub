#!/bin/bash
# deploy_full.sh - Full deploy of Hearthub with nested projects support

echo "🚀 Starting full deployment..."

cd ~/Hearthub || exit

# -------------------------------
# 1️⃣ Copy src/ files into public/
# -------------------------------
echo "📂 Copying src/ files into public/..."
cp -r src/* public/ 2>/dev/null || echo "⚠️ src/ already merged or missing"

# Rename copy.html → dashboard.html if exists
if [ -f "public/copy.html" ]; then
    mv public/copy.html public/dashboard.html
    echo "✅ Renamed copy.html → dashboard.html"
fi

# -------------------------------
# 2️⃣ Inject multiple search filter into dashboard
# -------------------------------
DASH=public/dashboard.html
if [ -f "$DASH" ]; then
    echo "📝 Injecting multi-search script..."
    if ! grep -q "function multiSearch" "$DASH"; then
        cat <<'EOF' >> "$DASH"
<script>
function multiSearch() {
    console.log("Multi-search enabled");
}
</script>
EOF
        echo "✅ Multi-search script injected."
    fi
fi

# -------------------------------
# 3️⃣ Generate sidebar with pages + projects
# -------------------------------
echo "🔗 Updating sidebar links dynamically..."
SIDEBAR="<h2>🌍 Heart Hub</h2>\n"

# Add all HTML pages in public/, except dashboard.html
for PAGE in public/*.html; do
    BASENAME=$(basename "$PAGE")
    [[ "$BASENAME" == "dashboard.html" ]] && continue
    DISPLAY="$(tr '[:lower:]' '[:upper:]' <<< ${BASENAME:0:1})${BASENAME:1}"
    SIDEBAR+="<a class=\"nav-item\" href=\"$BASENAME\">$DISPLAY</a>\n"
done

# Function to recursively add projects and subfolders
add_projects_recursive() {
    local DIR=$1
    local REL_PATH=$2
    for ITEM in "$DIR"/*; do
        [[ -e "$ITEM" ]] || continue
        local NAME=$(basename "$ITEM")
        if [ -d "$ITEM" ]; then
            SIDEBAR+="<details class=\"nav-item\"><summary>$NAME</summary>\n"
            add_projects_recursive "$ITEM" "$REL_PATH/$NAME"
            SIDEBAR+="</details>\n"
        elif [[ "$ITEM" == *.html ]]; then
            SIDEBAR+="<a class=\"nav-subitem\" href=\"$REL_PATH/$NAME\">$NAME</a>\n"
        fi
    done
}

# Add projects folder
if [ -d "projects" ]; then
    add_projects_recursive "projects" "projects"
fi

# Replace sidebar between markers
if ! grep -q "<!-- Sidebar start -->" "$DASH"; then
    sed -i '1i <!-- Sidebar start -->' "$DASH"
    sed -i '$a <!-- Sidebar end -->' "$DASH"
fi

sed -i "/<!-- Sidebar start -->/,/<!-- Sidebar end -->/c <!-- Sidebar start -->\n$SIDEBAR<!-- Sidebar end -->" "$DASH"
echo "✅ Sidebar updated with pages + projects."

# -------------------------------
# 4️⃣ GitHub push
# -------------------------------
echo "📤 Staging all changes..."
git add -A
git commit -m "Auto-update $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null || echo "ℹ️ Nothing to commit"
git push origin main
echo "✅ Pushed to GitHub."

# -------------------------------
# 5️⃣ Deploy to Vercel
# -------------------------------
echo "🌐 Deploying to Vercel production..."
DEPLOY_URL=$(vercel --prod --confirm --json | jq -r '.[0].url')
echo "✅ Deployed: https://$DEPLOY_URL"

# -------------------------------
# 6️⃣ Open live pages
# -------------------------------
echo "🌟 Opening index and dashboard pages..."
termux-open "https://$DEPLOY_URL/index.html"
termux-open "https://$DEPLOY_URL/dashboard.html"

echo "🎉 Full deployment with nested projects finished!"

