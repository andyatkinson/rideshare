#!/bin/bash

# Dependencies:
# - tmux (detach "ctrl-b" and re-attach e.g. "tmux attach -t db_reindex")
# - export DATABASE_URL (must be set) to be set to DB connection string URL
# - reindex_batch.sql to have the reindex commands
# - monitor progress: https://github.com/andyatkinson/pg_scripts/blob/main/concurrent_index_build_progress.sql
# - run monitor SQL above repeatly, every 1s: "psql> \watch 1"

# Configuration
SESSION_NAME="db_reindex"
SQL_FILE="reindex_batch.sql"

# Create new tmux session and detach from it
tmux new-session -d -s $SESSION_NAME

# Send the psql command to the tmux session and execute it
tmux send-keys -t $SESSION_NAME "psql -d $DATABASE_URL -f $SQL_FILE" C-m

# List the sessions
tmux ls

# Reattach later on
echo
echo "Reindexing is now taking place inside session '$SESSION_NAME' and you're detached from it"
echo
echo "To re-attach, find the session name w/ 'tmux ls'. Hint: 'tmux attach -t $SESSION_NAME'"
echo
echo "To monitor concurrent index build progress: https://github.com/andyatkinson/pg_scripts/blob/main/concurrent_index_build_progress.sql"
echo
