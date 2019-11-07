#!/bin/bash

psql --set dbname="${GALAXY_DB_NAME:-galaxy}" \
     --set username="${GALAXY_DB_USER:-galaxy}" \
     --set password="${GALAXY_DB_PASSWORD}" \
<<EOF
  CREATE ROLE :"username" WITH LOGIN PASSWORD :'password';
  CREATE DATABASE :"dbname" OWNER :"username";
EOF
