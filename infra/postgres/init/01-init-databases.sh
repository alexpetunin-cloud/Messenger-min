#!/bin/bash
set -e

create_db_and_user() {
  local db_name="$1"
  local db_user="$2"
  local db_password="$3"

  echo "Creating database ${db_name} and user ${db_user}"

  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER ${db_user} WITH PASSWORD '${db_password}';
    CREATE DATABASE ${db_name} OWNER ${db_user};
    REVOKE CONNECT ON DATABASE ${db_name} FROM PUBLIC;
    GRANT CONNECT ON DATABASE ${db_name} TO ${db_user};
EOSQL
}

create_db_and_user "$AUTH_DB_NAME" "$AUTH_DB_USER" "$AUTH_DB_PASSWORD"
create_db_and_user "$USER_DB_NAME" "$USER_DB_USER" "$USER_DB_PASSWORD"
create_db_and_user "$CHAT_DB_NAME" "$CHAT_DB_USER" "$CHAT_DB_PASSWORD"
create_db_and_user "$MESSAGE_DB_NAME" "$MESSAGE_DB_USER" "$MESSAGE_DB_PASSWORD"