
#!/bin/bash
# test_site.sh - Open Hearthub live site and dashboard

# Live site URL
SITE_URL="https://hearthub.vercel.app"
DASHBOARD_URL="https://hearthub.vercel.app/dashboard.html"

echo "Opening Hearthub live site..."
termux-open "$SITE_URL"

echo "Opening Dashboard page..."
termux-open "$DASHBOARD_URL"

echo "Done. Check your browser or Termux viewer."

