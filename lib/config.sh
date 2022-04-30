# shellcheck shell=bash
# shellcheck disable=SC2154
fetchConfig() {
  if [ -f "${1}" ]; then
    while read -r line; do
      if [[ ${line} =~ ^\[[[:alnum:]]+\] ]]; then
        arrname="config_${line//[^[:alnum:]]/}"
        declare -gA "${arrname}"
      elif [[ ${line} =~ ^([_[:alpha:]][_[:alnum:]]*)"="(.*) ]]; then
        # shellcheck disable=SC2086
        {
          _arr=${arrname}[${BASH_REMATCH[1]}]
          [ -z ${!_arr} ] && declare -g ${arrname}[${BASH_REMATCH[1]}]="${BASH_REMATCH[2]//\"/}"
          unset _arr
        }
      fi
    done < "${1}"
  else
    errorOut "No user configuration found, looking for sample config..."
    if [ -f "${FETCH_DATA_DIR:-/usr/share/fetch}/sample.config.conf" ]; then
      errorOut "Found sample configuration at ${FETCH_DATA_DIR:-/usr/share/fetch}/sample.config.conf. Copying to default path..."
      cp "${FETCH_DATA_DIR:-/usr/share/fetch}/sample.config.conf" "${FETCH_DATA_USER_DIR}/${FETCH_CONFIG_FILENAME}"
      if [ -f "${FETCH_DATA_USER_DIR}/${FETCH_CONFIG_FILENAME}" ]; then
        errorOut "Copied configuration file to ${FETCH_DATA_USER_DIR}/${FETCH_CONFIG_FILENAME}"
        errorOut "Please run fetch again."
        exit 0
      else
        errorOut "Failed to copy configuration. Please open a bug report at ${FETCH_SRC_LOCATION}"
        exit 1
      fi
    else
      errorOut "Could not find sample configuration file...did you install fetch correctly?"
      errorOut" Please consult ${FETCH_SRC_LOCATION} or your package manager for installation instructions."
      exit 1
    fi

  fi
}
