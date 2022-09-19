#!/bin/bash -e

REPO="$1"
shift

# This assumes an ssh repo
# mkdir -p /root/.ssh;

# if [[ -e /root/ssh ]]; then
#     ln -sf /root/ssh/id_rsa /root/.ssh/id_rsa
# fi

# REPO_URI="$(echo "$REPO" | cut -d@ -f2 | cut -d: -f1)"
# SUFFIX="$(echo "$REPO" | cut -d: -f2)"

# ssh-keyscan -t rsa "$REPO_URI" >> /root/.ssh/known_hosts

git clone "$REPO" cloned
cd "cloned/$SUBDIR"

COMMIT_HASH=$(git rev-parse HEAD)
TARGET_DIR="${TARGET}/${COMMIT_HASH}"

exec "$@"
