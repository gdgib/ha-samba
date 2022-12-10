#!/usr/bin/with-contenv bashio
# ==============================================================================
# Prepare the Samba service for running
# ==============================================================================
declare password
declare username
declare -a interfaces=()
export HOSTNAME

# Check Login data
if ! bashio::config.has_value 'username' || ! bashio::config.has_value 'password'; then
    bashio::exit.nok "Setting a username and password is required!"
fi

# Read hostname from API or setting default "hassio"
HOSTNAME=$(bashio::info.hostname)
if bashio::var.is_empty "${HOSTNAME}"; then
    bashio::log.warning "Can't read hostname, using default."
    HOSTNAME="hassio"
fi
bashio::log.info "Hostname: ${HOSTNAME}"

# Get supported interfaces
for interface in $(bashio::network.interfaces); do
    interfaces+=("${interface}")
done
if [ ${#interfaces[@]} -eq 0 ]; then
    bashio::exit.nok 'No supported interfaces found to bind on.'
fi
bashio::log.info "Interfaces: $(printf '%s ' "${interfaces[@]}")"

# Generate the root share
SAMBA_ROOT_SHARE=/usr/share/ha-samba/root
mkdir -pv "${SAMBA_ROOT_SHARE}"
ln -vf /addons "${SAMBA_ROOT_SHARE}/addons"
ln -vf /backup "${SAMBA_ROOT_SHARE}/backup"
ln -vf /config "${SAMBA_ROOT_SHARE}/config"
ln -vf /media  "${SAMBA_ROOT_SHARE}/media"
ln -vf /share  "${SAMBA_ROOT_SHARE}/share"
ln -vf /ssl    "${SAMBA_ROOT_SHARE}/ssl"

# Generate Samba configuration.
jq ".interfaces = $(jq -c -n '$ARGS.positional' --args -- "${interfaces[@]}")" /data/options.json \
    | tempio \
      -template /usr/share/tempio/smb.gtpl \
      -out /etc/samba/smb.conf

# Init user
username=$(bashio::config 'username')
password=$(bashio::config 'password')
addgroup "${username}"
adduser -D -H -G "${username}" -s /bin/false "${username}"
# shellcheck disable=SC1117
echo -e "${password}\n${password}" \
    | smbpasswd -a -s -c "/etc/samba/smb.conf" "${username}"
