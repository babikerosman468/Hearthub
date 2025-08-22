
#!/bin/bash
# vercel_clean.sh - Delete all Vercel projects under your account

echo "🔎 Fetching list of your Vercel projects..."

# Fetch projects JSON
projects=$(vercel projects ls --json 2>/dev/null)

# Check if we got any projects
if [[ -z "$projects" || "$projects" == "[]" ]]; then
    echo "✅ No projects found. Nothing to delete."
    exit 0
fi

# Extract project names safely
names=$(echo "$projects" | jq -r '.[].name' 2>/dev/null)

if [[ -z "$names" ]]; then
    echo "✅ No projects found. Nothing to delete."
    exit 0
fi

# Loop and delete each project
for name in $names; do
    echo "🗑️  Deleting project: $name ..."
    vercel projects rm "$name" --yes >/dev/null 2>&1
done

echo "🎉 All projects deleted successfully!"

