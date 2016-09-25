#!/bin/sh

# Pull in the passed in arguments
source $1


# Default 'state' to 'present'
if [ -z "$state" ]; then
  state=present
fi


# See if $value was base64 encoded, and decode it if so
if [ ! -z "$b64_encoded" -a "$b64_encoded" == "True" ]; then
  value=$(echo "$value" | openssl enc -base64 -d)
fi


function present() {
  nvram_value=$(nvram get $name)

  if [ "$nvram_value" == "$value" ]; then
    # They're the same, nothing to do
    printf '{"changed": false}'
    exit
  fi

  # They didn't match, so make them match
  nvram_mod_out=$(nvram set "$name"="$value" ; nvram commit)
  nvram_value=$(nvram get $name)

  if [ "$nvram_value" == "$value" ]; then
    printf '{"changed": true}'
    exit
  else
    printf '{"changed": false, "failed": true, "msg": "Unable to change nvram"}'
    exit
  fi
}


function absent() {
  nvram_value=$(nvram get $name)

  if [ "$nvram_value" == "" ]; then
    # The value is already not present, nothing to do
    printf '{"changed": false, "msg": "%s already absent"}' "$name"
    exit
  fi

  # The value was found, so we need to wipe it out
  nvram_mod_out=$(nvram unset "$name" ; nvram commit)
  nvram_value=$(nvram get $name)

  if [ "$nvram_value" == "" ]; then
    printf '{"changed": true, "msg": "%s is now absent"}' "$name"
    exit
  else
    printf '{"changed": false, "failed": true, "msg": "Unable to change nvram"}'
    exit
  fi
}


if [ "$state" == "present" ] ; then
  present
fi

if [ "$state" == "absent" ] ; then
  absent
fi

printf '{"changed": false, "failed": true, "msg": "NOT IMPLEMENTED YET!!!"}'
exit
