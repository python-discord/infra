#!/usr/bin/env sh
#
# Ansible Managed

USER="$1"

(
  echo "Subject: Welcome to PyDis Mail"
  echo "From: PyDis DevOps Team <devops@pydis.wtf>"
  echo "To: $USER@pydis.wtf"
  echo
  echo "Hi $USER!"
  echo
  echo "Welcome to the Python Discord mailserver."
  echo
  echo "If you are seeing this, you have connected successfully over IMAP and"
  echo "are ready to receive new mail destined for your address."
  echo
  echo "If you require any help with your mailbox then don't hesitate to ask"
  echo "in the #dev-oops channel on Discord, or take a look at some of our"
  echo "team documentation at https://docs.pydis.wtf/."
  echo
  echo "If you have any immediate questions, feel free to reply to this email"
  echo "and a member of the DevOps team will get back to you!"
  echo
  echo "Thanks for flying with us!"
  echo
  echo "- PyDis DevOps Team"
) | /usr/sbin/sendmail -t
