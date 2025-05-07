# BashLab
# 📁 IAM Automation with Bash

This project automates the creation of Linux users and groups using a Bash script. It's part of a lab exercise for learning how to manage users, groups, permissions, and basic email notifications on a Linux system.

---

## 🧠 What This Project Does

This Bash script:
1. Reads a list of users from a file (`users.txt`).
2. Creates user groups if they don't exist.
3. Adds users to the system with:
   - Full name
   - Group membership
   - Home directory
   - Temporary password
4. Forces the user to change their password on first login.
5. Secures the user's home directory (permissions set to `700`).
6. Logs all actions to a file (`iam_setup.log`).
7. Sends a notification email (using Postfix and Gmail) when a user is created.

---

## 🛠 Files Included

| File | Purpose |
|------|---------|
| `users.txt` | Contains the list of users to be created. |
| `iam_setup.sh` | The Bash script that automates IAM tasks. |
| `iam_setup.log` | A log file showing what the script did. |
| `screenshots/` | Screenshots showing script output and email notifications (for submission). |

---

## 📥 users.txt Format

This file is a CSV (comma-separated) list of users:

```txt
username,fullname,group
jdoe,John Doe,engineering
asmith,Alice Smith,engineering
mjones,Mike Jones,design
```

> First line is the header. The script will skip it.

---

## ▶️ How to Run It

### 1. Make Sure You're Root
You must run this script with `sudo` because it manages system users.

```bash
sudo ./iam_setup.sh
```

---

## 📨 Email Notification Setup (Optional/Advanced)

To send an email when each user is created:

1. Install Postfix:
   ```bash
   sudo apt update
   sudo apt install mailutils postfix
   ```

2. Choose **"Internet with smarthost"** during configuration.

3. Create a Gmail App Password via:
   - Go to your [Google Account → Security → App passwords](https://myaccount.google.com/apppasswords)
   - Generate a new app password for "Mail"
   - Copy it for later

4. Create `/etc/postfix/sasl_passwd`:
   ```bash
   sudo nano /etc/postfix/sasl_passwd
   ```
   Add this line:
   ```
   [smtp.gmail.com]:587 your_email@gmail.com:your_app_password
   ```

5. Secure and apply it:
   ```bash
   sudo postmap /etc/postfix/sasl_passwd
   sudo chmod 600 /etc/postfix/sasl_passwd*
   sudo systemctl restart postfix
   ```

Test with:
```bash
echo "This is a test" | mail -s "Test Email" your_email@gmail.com
```

---

## 📋 Sample Output

Check the log with:

```bash
cat iam_setup.log
```

It should look like this:
```
---- IAM Setup Script Started at Wed May 07 20:44:41 GMT 2025 ----
Processing jdoe...
Group 'engineering' already exists.
User 'jdoe' already exists. Skipping...
...
```

---

## 💡 Notes

- The script checks if a user or group already exists to avoid duplication.
- If you want to test from scratch, delete users first:
  ```bash
  sudo userdel -r jdoe
  ```

---

## 📸 Submission Instructions

1. Take screenshots of:
   - Terminal output after running the script
   - Log file content
   - Email notifications
2. Save them in a folder called `screenshots/`.
3. Push your project to GitHub:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin YOUR_GITHUB_LINK
   git push -u origin main
   ```

---

## ✅ Checklist

- [x] `users.txt` file
- [x] `iam_setup.sh` Bash script
- [x] `iam_setup.log` file
- [x] Email notifications (optional)
- [x] GitHub repository with screenshots
