# Replace postgres/postgres with "owner" or "app" credentials
# Use the password created at provision time
export DATABASE_URL_PRIMARY="postgres://postgres:postgres@localhost:54321/rideshare_development"

export DATABASE_URL_REPLICA="postgres://postgres:postgres@localhost:54322/rideshare_development"
