#!/bin/bash
set -e

# AES Deploy Script
# Stub - customize per project

echo "🚀 Deployment not configured."
echo "Customize scripts/deploy.sh for your infrastructure:"
echo "  - Heroku: git push heroku main"
echo "  - AWS: eb deploy or aws s3 sync"
echo "  - Vercel: vercel --prod"
echo "  - Docker: docker build && docker push"
echo ""
echo "Or set DEPLOY_COMMAND environment variable:"
echo "  export DEPLOY_COMMAND='vercel --prod' && make deploy"

if [ -n "$DEPLOY_COMMAND" ]; then
  echo "Running: $DEPLOY_COMMAND"
  eval $DEPLOY_COMMAND
fi
