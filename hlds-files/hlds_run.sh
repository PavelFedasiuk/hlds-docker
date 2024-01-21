#!/bin/sh

if [ -z "${HOME}" ]; then
    HOME=$(mktemp -d)
fi

mkdir -vp ${HOME}/.steam && ln -s /opt/hlds ${HOME}/.steam/sdk32

set -axe

CONFIG_FILE="/opt/hlds/startup.cfg"

if [ -r "${CONFIG_FILE}" ]; then
    # TODO: make config save/restore mechanism more solid
    set +e
    # shellcheck source=/dev/null
    source "${CONFIG_FILE}"
    set -e
fi

EXTRA_OPTIONS="$@"

EXECUTABLE="/opt/hlds/hlds_run"
GAME="${GAME:-cstrike}"
MAXPLAYERS="${MAXPLAYERS:-32}"
START_MAP="${START_MAP:-de_dust2}"
SERVER_NAME="${SERVER_NAME:-Counter-Strike 1.6 Server}"
START_MONEY="${START_MONEY:-800}"
BUY_TIME="${BUY_TIME:-0.25}"
FRIENDLY_FIRE="${FRIENDLY_FIRE:-1}"
BOT_QOUTA="${BOT_QOUTA:-15}" 
BOT_ADD="${BOR_ADD:-10}"
BOT_DIFFICULTY="${BOT_DIFFICULTY:-2}"

OPTIONS="-game ${GAME}\
 +maxplayers ${MAXPLAYERS}\
 +map ${START_MAP}\
 +hostname \"${SERVER_NAME}\"\
 +mp_startmoney ${START_MONEY}\
 +mp_friendlyfire ${FRIENDLY_FIRE}\
 +mp_buytime ${BUY_TIME}\
 +bot_qouta ${BOT_QOUTA}\
 +bot_add ${BOR_ADD}\
 +bot_difficulty ${BOT_DIFFICULTY}"

if [ -z "${RESTART_ON_FAIL}" ]; then
    OPTIONS="${OPTIONS} -norestart"
fi

if [ -n "${SERVER_PASSWORD}" ]; then
    OPTIONS="${OPTIONS} +sv_password ${SERVER_PASSWORD}"
fi

if [ -n "${RCON_PASSWORD}" ]; then
    OPTIONS="${OPTIONS} +rcon_password ${RCON_PASSWORD}"
fi

if [ -n "${ADMIN_STEAM}" ]; then
    echo "\"STEAM_${ADMIN_STEAM}\" \"\"  \"abcdefghijklmnopqrstu\" \"ce\"" >> "/opt/hlds/cstrike/addons/amxmodx/configs/users.ini"
fi

set > "${CONFIG_FILE}"

exec "${EXECUTABLE}" "${OPTIONS}" "${EXTRA_OPTIONS}"
