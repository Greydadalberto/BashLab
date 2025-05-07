#!/bin/bash

# Variables
INPUT_FILE="users.txt"
LOG_FILE="iam_setup.log"
TEMP_PASSWORD="ChangeMe123"
EMAIL="derrick.alberto-darku@amalitechtraining.org"

# Step 1: Check for root privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root." >&2
  exit 1
fi

# Step 2: Start log
echo "---- IAM Setup Script Started at $(date) ----" > "$LOG_FILE"

# Step 3: Read input file, skip header
tail -n +2 "$INPUT_FILE" | while IFS=',' read -r username fullname group; do
  echo "Processing $username..." | tee -a "$LOG_FILE"

  # Step 4: Create group if it doesn't exist
  if ! getent group "$group" > /dev/null; then
    groupadd "$group"
    echo "$(date): Group '$group' created." >> "$LOG_FILE"
  else
    echo "$(date): Group '$group' already exists." >> "$LOG_FILE"
  fi

  # Step 5: Create user if not exists
  if ! id "$username" &>/dev/null; then
    useradd -m -c "$fullname" -g "$group" "$username"
    echo "$username:$TEMP_PASSWORD" | chpasswd
    chage -d 0 "$username"
    chmod 700 /home/"$username"
    echo "$(date): User '$username' created and added to group '$group'." >> "$LOG_FILE"

    # Step 6: Email notification
    echo "Hello $fullname,

Your user account ($username) has been created on the system.
Your temporary password is: $TEMP_PASSWORD
Please change it upon first login.

Regards,
SysAdmin Team" | mail -s "Account Created for $fullname" "$EMAIL"

    echo "$(date): Email sent to $fullname ($EMAIL)." >> "$LOG_FILE"

  else
    echo "$(date): User '$username' already exists. Skipping..." >> "$LOG_FILE"
  fi

done

# Step 7: Complete log
echo "---- IAM Setup Script Completed at $(date) ----" >> "$LOG_FILE"

