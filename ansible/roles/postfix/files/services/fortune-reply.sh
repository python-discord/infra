#!/bin/bash

# Read the entire email into a variable
EMAIL=$(cat)

# Extract the sender's email address
SENDER=$(echo "$EMAIL" | grep -i "^From:" | head -n 1 | sed -E 's/.*<([^>]+)>.*/\1/;t;s/^From:[[:space:]]*//')

# Filter for invalid emails or attempted spoofs that were injected into the From header
if ! echo "$SENDER" | grep -qE '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'; then
    echo "Attempted spoof detected, quitting."
    exit 1
fi

# Extract the Message-ID of the original email
MESSAGE_ID=$(echo "$EMAIL" | grep -i "^Message-ID:" | head -n 1 | awk '{print $2}')

# Extract the original Subject and prefix it with "Re: " if necessary
ORIGINAL_SUBJECT=$(echo "$EMAIL" | grep -i "^Subject:" | head -n 1 | sed -E 's/Subject: (Re: )?(.+)/\2/')

# Construct the reply subject
REPLY_SUBJECT="Re: $ORIGINAL_SUBJECT"

# Extract the To address
TO_ADDRESS=$(echo "$EMAIL" | grep -i "^To:" | sed -E 's/To: (.*)/\1/')

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
