#!/bin/bash

psql --set dbname="${PULP_DB_NAME:-pulp}" \
     --set username="${PULP_DB_USER:-pulp}" \
     --set password="${PULP_DB_PASSWORD}" \
<<EOF
  CREATE ROLE :"username" WITH LOGIN PASSWORD :'password';
  CREATE DATABASE :"dbname" OWNER :"username";
EOF
