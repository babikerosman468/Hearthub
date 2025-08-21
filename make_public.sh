#!/bin/bash
# make_public.sh
# Move project files into public/ and redeploy with Vercel

set -e

# Create public/ if not exists
mkdir -p public

# Move web files into public/
mv -f *.html public/ 2>/dev/null || true
mv -f *.css public/ 2>/dev/null || true
mv -f *.js public/ 2>/dev/null || true
mv -f *.jpg *.jpeg *.png *.gif public/ 2>/dev/null || true

echo "✅ Files moved into public/"

# Deploy with Vercel
vercel --prod --yes

echo "🌍 Deployment complete!"

