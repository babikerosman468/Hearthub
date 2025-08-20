#!/data/data/com.termux/files/usr/bin/bash

# ======================
# CONFIGURATION
# ======================
FTP_USER="FTP_USERNAME"
FTP_PASS="FTP_PASSWORD"
FTP_HOST="ftp.yourdomain.com"
PROJECT_DIR="$HOME/Hearthub"
LOG_FILE="$HOME/deploy_hearthub.log"
SITE_URL="https://yourdomain.com"   # Change to your actual domain

# Function: timestamp
timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# Ask user
echo "Choose deployment type:"
echo "1) Full upload (zip & extract)"
echo "2) Fast upload (only changed files)"
read -p "Enter choice [1-2]: " choice

# FULL UPLOAD
if [ "$choice" = "1" ]; then
    echo "$(timestamp) - Starting FULL upload..." | tee -a "$LOG_FILE"
    cd "$PROJECT_DIR" || exit
    zip -r hearthub.zip * >> "$LOG_FILE" 2>&1
    lftp -u "$FTP_USER","$FTP_PASS" "$FTP_HOST" <<EOF >> "$LOG_FILE" 2>&1
cd public_html
put hearthub.zip
unzip -o hearthub.zip
rm hearthub.zip
bye
EOF
    echo "$(timestamp) - FULL upload completed." | tee -a "$LOG_FILE"

# FAST UPLOAD
elif [ "$choice" = "2" ]; then
    echo "$(timestamp) - Starting FAST upload..." | tee -a "$LOG_FILE"
    cd "$PROJECT_DIR" || exit
    lftp -u "$FTP_USER","$FTP_PASS" "$FTP_HOST" <<EOF >> "$LOG_FILE" 2>&1
mirror -R \
--exclude-glob .git/ \
--exclude-glob *.sh \
--exclude-glob README.md \
--exclude-glob licence \
. public_html
bye
EOF
    echo "$(timestamp) - FAST upload completed." | tee -a "$LOG_FILE"

# INVALID CHOICE
else
    echo "$(timestamp) - Invalid choice entered." | tee -a "$LOG_FILE"
    echo "Invalid choice. Exiting."
    exit 1
fi

# ======================
# OPEN SITE IN BROWSER
# ======================
if command -v termux-open-url >/dev/null 2>&1; then
    termux-open-url "$SITE_URL"
else
    echo "Your site is live at: $SITE_URL"
fi

