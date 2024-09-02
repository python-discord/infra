#!/bin/bash

# Read the entire email into a variable
EMAIL=$(cat)

# Extract the sender's email address
SENDER=$(echo "$EMAIL" | maddr -a -h from -)

# Extract the Message-ID of the original email
MESSAGE_ID=$(echo "$EMAIL" | mhdr -h message-id -)

# Extract the original Subject and prefix it with "Re: " if necessary
ORIGINAL_SUBJECT=$(echo "$EMAIL" | mhdr -h subject -)

# Construct the reply subject
REPLY_SUBJECT="Re: $ORIGINAL_SUBJECT"

# Extract the To address
TO_ADDRESS=$(echo "$EMAIL" | maddr -a -h to -)

# Generate the fortune output
if [[ "$TO_ADDRESS" =~ "fortune+cowsay" ]]; then
  FORTUNE_OUTPUT=$(/usr/games/fortune | /usr/games/cowsay)
else
    FORTUNE_OUTPUT=$(/usr/games/fortune)
fi

# Send a reply with the proper headers
(
  echo "Subject: $REPLY_SUBJECT"
  echo "From: Fortunes by Python Discord <fortune@int.pydis.wtf>"
  echo "To: $SENDER"
  echo "In-Reply-To: $MESSAGE_ID"
  echo "References: $MESSAGE_ID"
  echo
  echo "Here's your fortune:"
  echo
  echo "$FORTUNE_OUTPUT"
) | /usr/sbin/sendmail -t
