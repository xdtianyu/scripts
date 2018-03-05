#!/bin/bash

function deploy_challenge {
    local DOMAIN="${1}" TOKEN_FILENAME="${2}" TOKEN_VALUE="${3}"
    echo "$DOMAIN" "$TOKEN_FILENAME" "$TOKEN_VALUE"
    ./cloudflare.sh "$CONFIG" "$DOMAIN" "$TOKEN_VALUE"
    sleep 15
}

function clean_challenge {
    local DOMAIN="${1}" TOKEN_FILENAME="${2}" TOKEN_VALUE="${3}"
}

function deploy_cert {
    local DOMAIN="${1}" KEYFILE="${2}" CERTFILE="${3}" CHAINFILE="${4}"
}

function unchanged_cert {
    local DOMAIN="${1}" KEYFILE="${2}" CERTFILE="${3}" FULLCHAINFILE="${4}" CHAINFILE="${5}"
}

function invalid_challenge {
    local DOMAIN="${1}" RESPONSE="${2}"
}

function request_failure {
    local STATUSCODE="${1}" REASON="${2}" REQTYPE="${3}" HEADERS="${4}"
}

function generate_csr {
    local DOMAIN="${1}" CERTDIR="${2}" ALTNAMES="${3}"
}

function startup_hook {
    :
}

function exit_hook {
    :
}

HANDLER="$1"; shift
if [[ "${HANDLER}" =~ ^(deploy_challenge|clean_challenge|deploy_cert|unchanged_cert|invalid_challenge|request_failure|generate_csr|startup_hook|exit_hook)$ ]]; then
    "$HANDLER" "$@"
fi

