#!/usr/bin/env bash
# variables: script global
FETCH_VERSION="0.9"
#FETCH_DATA_DIR="/usr/share/fetch"
FETCH_DATA_USER_DIR="${XDG_CONFIG_HOME:-${HOME}}/.config/fetch"
FETCH_CONFIG_FILENAME="config"
LC_ALL=C
LANG=C
# https://github.com/KittyKatt/screenFetch/issues/549
if [[ "${OSTYPE}" =~ linux || "${OSTYPE}" == gnu ]]; then
	# issue seems to affect Ubuntu; add LSB directories if it appears on other distros too
	export GIO_EXTRA_MODULES="/usr/lib/x86_64-linux-gnu/gio/modules:/usr/lib/i686-linux-gnu/gio/modules:${GIO_EXTRA_MODULES}"
fi

# Set shopt extglob for filename-like globbing in case statements. Check if exttglob was set before and store that as a variable.
shopt -q extglob; extglob_set=$?
((extglob_set)) && shopt -s extglob

# functions: script output
verboseOut () {
	# shellcheck disable=SC2154
	if [[ ${config_global[verbose]} =~ "on" ]]; then
		printf '\033[1;31m:: \033[0m%s\n' "${1}"
	fi
}
errorOut () {
	printf '\033[1;37m[[ \033[1;31m! \033[1;37m]] \033[0m%s\n' "${1}"
	exit 1
}
stderrOut () {
	while IFS='' read -r line; do
		printf '\033[1;37m[[ \033[1;31m! \033[1;37m]] \033[0m%s\n' "${line}"
	done
}

# functions: text
strip_sequences() {
    strip="${1//$'\e['3[0-9]m}"
    strip="${strip//$'\e['[0-9]m}"
    strip="${strip//\\e\[[0-9]m}"
    strip="${strip//$'\e['38\;5\;[0-9]m}"
    strip="${strip//$'\e['38\;5\;[0-9][0-9]m}"
    strip="${strip//$'\e['38\;5\;[0-9][0-9][0-9]m}"

    printf '%s\n' "${strip}"
}
trim() {
    set -f
	# shellcheck disable=SC2086,SC2048
    set -- $*
    printf '%s\n' "${*//[[:space:]]/}"
    set +f
}

# functions: configuration
fetchConfig () {
	if [ -f "${1}" ]; then
		while read -r line; do
			if [[ ${line} =~ ^\[[[:alnum:]]+\] ]]; then
				arrname="config_${line//[^[:alnum:]]/}"
				declare -gA "${arrname}"
			elif [[ ${line} =~ ^([_[:alpha:]][_[:alnum:]]*)"="(.*) ]]; then
				# shellcheck disable=SC2086
				{
					_arr=${arrname}[${BASH_REMATCH[1]}]
					[ -z ${!_arr} ] && declare -g ${arrname}[${BASH_REMATCH[1]}]="${BASH_REMATCH[2]//\"}"
					unset _arr
				}
			fi
		done < "${1}"
	else
		errorOut "No configuration file specified"
	fi
}

# functions: color
# variables: color
reset='\e[0m'
colorize () {
	printf $'\033[0m\033[38;5;%sm' "$1"
}
getColor () {
	local tmp_color=""
	if [ -n "${1}" ]; then
		if [ "${BASH_VERSINFO[0]}" -ge '4' ]; then
			if [[ ${BASH_VERSINFO[0]} -eq '4' && ${BASH_VERSINFO[1]} -gt '1' ]] || [ "${BASH_VERSINFO[0]}" -gt '4' ]; then
				tmp_color=${1,,}
			else
				tmp_color="$(tr '[:upper:]' '[:lower:]' <<< "${1}")"
			fi
		else
			tmp_color="$(tr '[:upper:]' '[:lower:]' <<< "${1}")"
		fi

		case "${tmp_color}" in
			# Standards
			'black')					color_ret='\033[0m\033[30m';;
			'red')						color_ret='\033[0m\033[31m';;
			'green')					color_ret='\033[0m\033[32m';;
			'brown')					color_ret='\033[0m\033[33m';;
			'blue')						color_ret='\033[0m\033[34m';;
			'purple')					color_ret='\033[0m\033[35m';;
			'cyan')						color_ret='\033[0m\033[36m';;
			'yellow')					color_ret='\033[0m\033[1;33m';;
			'white')					color_ret='\033[0m\033[1;37m';;
			# Bolds
			'dark grey'|'dark gray')	color_ret='\033[0m\033[1;30m';;
			'light red')				color_ret='\033[0m\033[1;31m';;
			'light green')				color_ret='\033[0m\033[1;32m';;
			'light blue')				color_ret='\033[0m\033[1;34m';;
			'light purple')				color_ret='\033[0m\033[1;35m';;
			'light cyan')				color_ret='\033[0m\033[1;36m';;
			'light grey'|'light gray')	color_ret='\033[0m\033[37m';;
			# 256 Color Support
			(?([1])?([0-9])[0-9])		color_ret=$(colorize "${tmp_color}");;
			(?([2])?([0-4])[0-9])		color_ret=$(colorize "${tmp_color}");;
			(?([2])?([5])[0-6])			color_ret=$(colorize "${tmp_color}");;
			*)							errorOut "That color will not work"; exit 1;;
		esac

		[ -n "${color_ret}" ] && printf '%s' "${color_ret}"
	fi
}
_randcolor () {
	local color=
	color=$((RANDOM % 255))
	printf '%s' "${color}"
}

# functions: system detection
detect_kernel () {
    IFS=" " read -ra kernel <<< "$(uname -srm)"
    kernel_name="${kernel[0]}"
    kernel_version="${kernel[1]}"
    kernel_machine="${kernel[2]}"

	# pulled from neofetch source
    if [ "${kernel_name}" == "Darwin" ]; then
        # macOS can report incorrect versions unless this is 0.
        # https://github.com/dylanaraps/neofetch/issues/1607
        export SYSTEM_VERSION_COMPAT=0

        IFS=$'\n' read -d "" -ra sw_vers <<< "$(awk -F'<|>' '/key|string/ {print $3}' \
                            "/System/Library/CoreServices/SystemVersion.plist")"
        for ((i=0;i<${#sw_vers[@]};i+=2)); do
			case ${sw_vers[i]} in
				ProductName)			darwin_name=${sw_vers[i+1]} ;;
				ProductVersion)			osx_version=${sw_vers[i+1]} ;;
				#ProductBuildVersion)	osx_build=${sw_vers[i+1]}   ;;
				*)						: ;;
			esac
        done
    fi

	# shellcheck disable=SC2154
	case ${config_kernel[short]} in
		on)
			my_kernel="${kernel_version}"
			;;
		off)
			my_kernel="${kernel_name} ${kernel_version}"
			;;
		auto)
			# shellcheck disable=SC2154
			if [[ ${config_global[short]} =~ 'on' ]]; then
				my_kernel="${kernel_version}"
			else
				my_kernel="${kernel_name} ${kernel_version}"
			fi
			;;
		*) return ;;
	esac

	verboseOut "Finding kernel...found as '${my_kernel}'."
}

detect_os () {
	case "${kernel_name}" in
        Darwin)   my_os=${darwin_name} ;;
        SunOS)    my_os=Solaris ;;
        Haiku)    my_os=Haiku ;;
        MINIX)    my_os=MINIX ;;
        AIX)      my_os=AIX ;;
        IRIX*)    my_os=IRIX ;;
        FreeMiNT) my_os=FreeMiNT ;;
        Linux|GNU*)
            my_os=Linux
        ;;
        *BSD|DragonFly|Bitrig)
            my_os=BSD
        ;;
        CYGWIN*|MSYS*|MINGW*)
            my_os=Windows
        ;;
        *)
            errorOut "Unknown OS detected, please report this issue."
        ;;
    esac

	verboseOut "Finding OS...found as '${my_os}'."
}

detect_distro () {
	if [ -z "${my_distro}" ]; then
		local distro_detect=
		my_distro="Unknown"
		if [ "${my_os}" == "Linux" ] && [ "${my_distro}" == "Unknown" ]; then
			# LSB Release Check
			if type -p lsb_release >/dev/null 2>&1; then
				distro_detect="$(lsb_release -si)"
				distro_release="$(lsb_release -sr)"
				distro_codename="$(lsb_release -sc)"
				case ${distro_detect} in
					"archlinux"|"Arch Linux"|"arch"|"Arch"|"archarm")
						my_distro="Arch Linux"
						unset distro_release
						;;
					"ALDOS"|"Aldos")
						my_distro="ALDOS"
						;;
					"ArcoLinux")
						my_distro="ArcoLinux"
						unset distro_release
						;;
					"artixlinux"|"Artix Linux"|"artix"|"Artix"|"Artix release")
						my_distro="Artix"
						;;
					"blackPantherOS"|"blackPanther"|"blackpanther"|"blackpantheros")
						# shellcheck disable=SC2034,SC1091,SC2153
						{
							my_distro=$(source /etc/lsb-release; printf '%s' "${DISTRIB_ID}")
							distro_release=$(source /etc/lsb-release; printf '%s' "${DISTRIB_RELEASE}")
							distro_codename=$(source /etc/lsb-release; printf '%s' "${DISTRIB_CODENAME}")
						}
						;;
					"Chakra")
						my_distro="Chakra"
						unset distro_release
						;;
					"CentOSStream")
						my_distro="CentOS Stream"
						;;
					"BunsenLabs")
						# shellcheck disable=SC2034,SC1091,SC2153
						{
							my_distro=$(source /etc/lsb-release; printf '%s' "${DISTRIB_ID}")
							distro_release=$(source /etc/lsb-release; printf '%s' "${DISTRIB_RELEASE}")
							distro_codename=$(source /etc/lsb-release; printf '%s' "${DISTRIB_CODENAME}")
						}
						;;
					"Debian")
						my_distro="Debian"
						;;
					"Deepin")
						my_distro="Deepin"
						;;
					"elementary"|"elementary OS")
						my_distro="elementary OS"
						;;
					"EvolveOS")
						my_distro="Evolve OS"
						;;
					"Sulin")
						my_distro="Sulin"
						distro_release=$(awk -F'=' '/^ID_LIKE=/ {print $2}' /etc/os-release)
						distro_codename="Roolling donkey" # this is not wrong :D
						;;
					"KaOS"|"kaos")
						my_distro="KaOS"
						;;
					"frugalware")
						my_distro="Frugalware"
						unset distro_codename
						unset distro_release
						;;
					"Gentoo")
						my_distro="Gentoo"
						;;
					"Hyperbola GNU/Linux-libre"|"Hyperbola")
						my_distro="Hyperbola GNU/Linux-libre"
						unset distro_codename
						unset distro_release
						;;
					"Kali"|"Debian Kali Linux")
						my_distro="Kali Linux"
						if [[ "${distro_codename}" =~ "kali-rolling" ]]; then
							unset distro_codename
							unset distro_release
						fi
						;;
					"Lunar Linux"|"lunar")
						my_distro="Lunar Linux"
						;;
					"ManjaroLinux")
						my_distro="Manjaro"
						;;
					"neon"|"KDE neon")
						my_distro="KDE neon"
						unset distro_codename
						unset distro_release
						;;
					"Ol"|"ol"|"Oracle Linux")
						my_distro="Oracle Linux"
						[ -f /etc/oracle-release ] && distro_release="$(sed 's/Oracle Linux //' /etc/oracle-release)"
						;;
					"LinuxMint")
						my_distro="Mint"
						;;
					"openSUSE"|"openSUSE project"|"SUSE LINUX"|"SUSE"|*SUSELinuxEnterprise*)
						my_distro="openSUSE"
						;;
					"Parabola GNU/Linux-libre"|"Parabola")
						my_distro="Parabola GNU/Linux-libre"
						unset distro_codename
						unset distro_release
						;;
					"Parrot"|"Parrot Security")
						my_distro="Parrot Security"
						;;
					"PCLinuxOS")
						my_distro="PCLinuxOS"
						unset distro_codename
						unset distro_release
						;;
					"Peppermint")
						my_distro="Peppermint"
						unset distro_codename
						;;
					"rhel"|*RedHatEnterprise*)
						my_distro="Red Hat Enterprise Linux"
						;;
					"RosaDesktopFresh")
						my_distro="ROSA"
						distro_release=$(grep 'VERSION=' /etc/os-release | cut -d ' ' -f3 | cut -d "\"" -f1)
						distro_codename=$(grep 'PRETTY_NAME=' /etc/os-release | cut -d ' ' -f4,4)
						;;
					"SailfishOS")
						my_distro="SailfishOS"
						;;
					"Sparky"|"SparkyLinux")
						my_distro="SparkyLinux"
						;;
					"Ubuntu")
						my_distro="Ubuntu"
						;;
					"Void"|"VoidLinux")
						my_distro="Void Linux"
						unset distro_codename
						unset distro_release
						;;
					"Zorin")
						my_distro="Zorin OS"
						unset distro_codename
						;;
					*)
						my_distro="Unknown"
						;;
				esac
			fi

			# Existing File Check
			if [ "${my_distro}" == "Unknown" ]; then
				if [ -f "/etc/mcst_version" ]; then
					my_distro="OS Elbrus"
					distro_release="$(tail -n 1 /etc/mcst_version)"
					if [ -n "${distro_release}" ]; then
						distro_more="${distro_release}"
					fi
				fi
				if [ -n "$(uname -o 2>/dev/null)" ]; then
					os="$(uname -o)"
					case ${os} in
						"EndeavourOS") my_distro="EndeavourOS" ;;
						"GNU/Linux")
							if type -p crux >/dev/null 2>&1; then
								my_distro="CRUX"
								distro_more="$(crux | awk '{print $3}')"
							fi
							if type -p nixos-version >/dev/null 2>&1; then
								my_distro="NixOS"
								distro_more="$(nixos-version)"
							fi
							if type -p sorcery >/dev/null 2>&1; then
								my_distro="SMGL"
							fi
							if (type -p guix && type -p herd) >/dev/null 2>&1; then
								my_distro="Guix System"
							fi
						;;
						*) return ;;
					esac
				fi

				if [ "${my_distro}" == "Unknown" ]; then
					if [ -f /etc/os-release ]; then
						os_release="/etc/os-release";
					elif [ -f /usr/lib/os-release ]; then
						os_release="/usr/lib/os-release";
					fi
					if [ -n "${os_release}" ]; then
						# shellcheck disable=SC2248
						distrib_id="$(<${os_release})";
						for l in ${distrib_id}; do
							if [[ ${l} =~ ^ID= ]]; then
								distrib_id=${l//*=}
								distrib_id=${distrib_id//\"/}
								break 1
							fi
						done
						if [ -n "${distrib_id}" ]; then
							if [ "${BASH_VERSINFO[0]}" -ge 4 ]; then
								distrib_id=$(for i in ${distrib_id}; do printf '%s' "${i^} "; done)
								my_distro=${distrib_id% }
								unset distrib_id
							else
								distrib_id=$(for i in ${distrib_id}; do FIRST_LETTER=$(printf '%s' "${i:0:1}" | tr "[:lower:]" "[:upper:]"); printf '%s' "${FIRST_LETTER}${i:1} "; done)
								my_distro=${distrib_id% }
								unset distrib_id
							fi
						fi

						# Hotfixes
						[ "${my_distro}" == "Opensuse-tumbleweed" ] && my_distro="openSUSE" && distro_more="Tumbleweed"
						[ "${my_distro}" == "Opensuse-leap" ] && my_distro="openSUSE"
						[ "${my_distro}" == "void" ] && my_distro="Void Linux"
						[ "${my_distro}" == "evolveos" ] && my_distro="Evolve OS"
						[ "${my_distro}" == "Sulin" ] && my_distro="Sulin"
						[[ "${my_distro}" == "Arch" || "${my_distro}" == "Archarm" || "${my_distro}" == "archarm" ]] && my_distro="Arch Linux"
						[ "${my_distro}" == "elementary" ] && my_distro="elementary OS"
						[[ "${my_distro}" == "Fedora" && -d /etc/qubes-rpc ]] && my_distro="qubes" # Inner VM
						[[ "${my_distro}" == "Ol" || "${my_distro}" == "ol" ]] && my_distro="Oracle Linux"
						if [[ "${my_distro}" == "Oracle Linux" && -f /etc/oracle-release ]]; then
							distro_more="$(sed 's/Oracle Linux //' /etc/oracle-release)"
						fi
						# Upstream problem, SL and so EL is using rhel ID in os-release
						if [ "${my_distro}" == "rhel" ] || [ "${my_distro}" == "Rhel" ]; then
							my_distro="Red Hat Enterprise Linux"
							if grep -q 'Scientific' /etc/os-release; then
								my_distro="Scientific Linux"
							elif grep -q 'EuroLinux' /etc/os-release; then
								my_distro="EuroLinux"
							fi
						fi	

						[ "${my_distro}" == "Neon" ] && my_distro="KDE neon"
						[[ "${my_distro}" == "SLED" || "${my_distro}" == "sled" || "${my_distro}" == "SLES" || "${my_distro}" == "sles" ]] && my_distro="SUSE Linux Enterprise"
						if [ "${my_distro}" == "SUSE Linux Enterprise" ] && [ -f /etc/os-release ]; then
							distro_more="$(awk -F'=' '/^VERSION_ID=/ {print $2}' /etc/os-release | tr -d '"')"
						fi
						if [ "${my_distro}" == "Debian" ] && [ -f /usr/bin/pveversion ]; then
							my_distro="Proxmox VE"
							unset distro_codename
							distro_release="$(/usr/bin/pveversion | grep -oP 'pve-manager\/\K\d+\.\d+')"
						fi
					fi
				fi

				if [[ "${my_distro}" == "Unknown" && "${OSTYPE}" =~ "linux" && -f /etc/lsb-release ]]; then
					LSB_RELEASE=$(</etc/lsb-release)
					my_distro=$(printf '%s' "${LSB_RELEASE}" | awk 'BEGIN {
						distro = "Unknown"
					}
					{
						if ($0 ~ /[Uu][Bb][Uu][Nn][Tt][Uu]/) {
							distro = "Ubuntu"
							exit
						}
						else if ($0 ~ /[Mm][Ii][Nn][Tt]/ && $0 ~ /[Dd][Ee][Bb][Ii][Aa][Nn]/) {
							distro = "LMDE"
							exit
						}
						else if ($0 ~ /[Mm][Ii][Nn][Tt]/) {
							distro = "Mint"
							exit
						}
					} END {
						print distro
					}')
				fi

				if [ "${my_distro}" == "Unknown" ] && [[ "${OSTYPE}" =~ "linux" || "${OSTYPE}" == "gnu" ]]; then
					for di in arch chakra evolveos exherbo fedora \
						frugalware gentoo kogaion mageia obarun oracle pardus \
						pclinuxos redhat rosa SuSe; do
						# shellcheck disable=SC2248
						if [ -f /etc/${di}-release ]; then
							my_distro=${di}
							break
						fi
					done
					if [ "${my_distro}" == "oracle" ]; then
						distro_more="$(sed 's/Oracle Linux //' /etc/oracle-release)"
					elif [ "${my_distro}" == "SuSe" ]; then
						my_distro="openSUSE"
						if [ -f /etc/os-release ]; then
							if grep -q -i 'SUSE Linux Enterprise' /etc/os-release ; then
								my_distro="SUSE Linux Enterprise"
								distro_more=$(awk -F'=' '/^VERSION_ID=/ {print $2}' /etc/os-release | tr -d '"')
							fi
						fi
						if [[ "${distro_more}" =~ "Tumbleweed" ]]; then
							distro_more="Tumbleweed"
						fi
					elif [ "${my_distro}" == "redhat" ]; then
						grep -q -i 'CentOS' /etc/redhat-release && my_distro="CentOS"
						grep -q -i 'Scientific' /etc/redhat-release && my_distro="Scientific Linux"
						grep -q -i 'EuroLinux' /etc/redhat-release && my_distro="EuroLinux"
						grep -q -i 'PCLinuxOS' /etc/redhat-release && my_distro="PCLinuxOS"
					fi
				fi

				if [ "${my_distro}" == "Unknown" ]; then
					if [[ "${OSTYPE}" =~ "linux" || "${OSTYPE}" == "gnu" ]]; then
						if [ -f /etc/debian_version ]; then
							if [ -f /etc/issue ]; then
								if grep -q -i 'gNewSense' /etc/issue ; then
									my_distro="gNewSense"
								elif grep -q -i 'KDE neon' /etc/issue ; then
									my_distro="KDE neon"
									distro_more="$(cut -d ' ' -f3 /etc/issue)"
								else
									my_distro="Debian"
								fi
							fi
							if grep -q -i 'Kali' /etc/debian_version ; then
								my_distro="Kali Linux"
							fi
						elif [ -f /etc/NIXOS ]; then my_distro="NixOS"
						elif [ -f /etc/dragora-version ]; then
							my_distro="Dragora"
							distro_more="$(cut -d, -f1 /etc/dragora-version)"
						elif [ -f /etc/slackware-version ]; then my_distro="Slackware"
						elif [ -f /usr/share/doc/tc/release.txt ]; then
							my_distro="TinyCore"
							distro_more="$(cat /usr/share/doc/tc/release.txt)"
						elif [ -f /etc/sabayon-edition ]; then my_distro="Sabayon"
						fi
					fi
				fi

				if [ "${my_distro}" == "Unknown" ] && [[ "${OSTYPE}" =~ "linux" || "${OSTYPE}" == "gnu" ]]; then
					if [ -f /etc/issue ]; then
						my_distro=$(awk 'BEGIN {
							distro = "Unknown"
						}
						{
							if ($0 ~ /"Hyperbola GNU\/Linux-libre"/) {
								distro = "Hyperbola GNU/Linux-libre"
								exit
							}
							else if ($0 ~ /"Obarun"/) {
								distro = "Obarun"
								exit
							}
							else if ($0 ~ /"Parabola GNU\/Linux-libre"/) {
								distro = "Parabola GNU/Linux-libre"
								exit
							}
							else if ($0 ~ /"Solus"/) {
								distro = "Solus"
								exit
							}
							else if ($0 ~ /"ALDOS"/) {
								distro = "ALDOS"
								exit
							}
						} END {
							print distro
						}' /etc/issue)
					fi
				fi

				if [ "${my_distro}" == "Unknown" ] && [[ "${OSTYPE}" =~ "linux" || "${OSTYPE}" == "gnu" ]]; then
					if [ -f /etc/system-release ]; then
						if grep -q -i 'Scientific Linux' /etc/system-release; then
							my_distro="Scientific Linux"
						elif grep -q -i 'Oracle Linux' /etc/system-release; then
							my_distro="Oracle Linux"
						fi
					elif [ -f /etc/lsb-release ]; then
						if grep -q -i 'CHROMEOS_RELEASE_NAME' /etc/lsb-release; then
							my_distro="$(awk -F'=' '/^CHROMEOS_RELEASE_NAME=/ {print $2}' /etc/lsb-release)"
							distro_more="$(awk -F'=' '/^CHROMEOS_RELEASE_VERSION=/ {print $2}' /etc/lsb-release)"
						fi
					fi
				fi
			fi
		elif [ "${my_os}" == "Windows" ]; then
			my_distro=$(wmic os get Caption)
			my_distro=${my_distro/Caption}
			my_distro=$(trim "${my_distro/Microsoft }")
			my_distro=${my_distro%%+([[:space:]])}
			[[ ${my_distro} =~ [[:space:]](.*) ]] && my_distro=${BASH_REMATCH[1]}
		elif [[ "${my_os}" =~ [Mm]ac ]]; then
			case ${osx_version} in
				10.4*)  my_distro="Mac OS X Tiger" ;;
				10.5*)  my_distro="Mac OS X Leopard" ;;
				10.6*)  my_distro="Mac OS X Snow Leopard" ;;
				10.7*)  my_distro="Mac OS X Lion" ;;
				10.8*)  my_distro="OS X Mountain Lion" ;;
				10.9*)  my_distro="OS X Mavericks" ;;
				10.10*) my_distro="OS X Yosemite" ;;
				10.11*) my_distro="OS X El Capitan" ;;
				10.12*) my_distro="macOS Sierra" ;;
				10.13*) my_distro="macOS High Sierra" ;;
				10.14*) my_distro="macOS Mojave" ;;
				10.15*) my_distro="macOS Catalina" ;;
				10.16*) my_distro="macOS Big Sur" ;;
				11.0*)  my_distro="macOS Big Sur" ;;
				*)      my_distro="macOS" ;;
			esac
		fi
	fi

	case ${my_distro,,} in
		aldos) my_distro="ALDOS";;
		alpine) my_distro="Alpine Linux" ;;
		amzn|amazon|amazon*linux) my_distro="Amazon Linux" ;;
		arch*linux*old) my_distro="Arch Linux - Old" ;;
		arch|arch*linux) my_distro="Arch Linux" ;;
		arch32) my_distro="Arch Linux 32" ;;
		arcolinux|arcolinux*) my_distro="ArcoLinux" ;;
		artix|artix*linux) my_distro="Artix Linux" ;;
		blackpantheros|black*panther*) my_distro="blackPanther OS" ;;
		bunsenlabs) my_distro="BunsenLabs" ;;
		centos) my_distro="CentOS" ;;
		centos*stream) my_distro="CentOS Stream" ;;
		chakra) my_distro="Chakra" ;;
		chrome*|chromium*) my_distro="Chrome OS" ;;
		crux) my_distro="CRUX" ;;
		debian) 
			my_distro="Debian"
			. lib/Linux/Debian/debian/extra.sh
			;;
		devuan) my_distro="Devuan" ;;
		deepin) my_distro="Deepin" ;;
		dragonflybsd) my_distro="DragonFlyBSD" ;;
		dragora) my_distro="Dragora" ;;
		drauger*) my_distro="DraugerOS" ;;
		elementary|'elementary os') my_distro="elementary OS";;
		eurolinux) my_distro="EuroLinux" ;;
		evolveos) my_distro="Evolve OS" ;;
		sulin) my_distro="Sulin" ;;
		exherbo|exherbo*linux) my_distro="Exherbo" ;;
		fedora)
			my_distro="Fedora"
			. lib/Linux/Fedora/fedora/extra.sh
			. lib/Linux/Fedora/fedora/ascii.sh
			;;
		freebsd) my_distro="FreeBSD" ;;
		freebsd*old) my_distro="FreeBSD - Old" ;;
		frugalware) my_distro="Frugalware" ;;
		funtoo) my_distro="Funtoo" ;;
		gentoo)
			my_distro="Gentoo"
			. lib/Linux/Gentoo/gentoo/extra.sh
			;;
		gnewsense) my_distro="gNewSense" ;;
		guix*system) my_distro="Guix System" ;;
		haiku) my_distro="Haiku" ;;
		hyperbolagnu|hyperbolagnu/linux-libre|'hyperbola gnu/linux-libre'|hyperbola) my_distro="Hyperbola GNU/Linux-libre" ;;
		kali*linux) my_distro="Kali Linux" ;;
		kaos) my_distro="KaOS";;
		kde*neon|neon)
			my_distro="KDE neon"
			. lib/Linux/Ubuntu/kdeneon/extra.sh
			;;
		kogaion) my_distro="Kogaion" ;;
		lmde) my_distro="LMDE" ;;
		lunar|lunar*linux) my_distro="Lunar Linux";;
		manjaro) my_distro="Manjaro" ;;
		mageia) my_distro="Mageia" ;;
		mer) my_distro="Mer" ;;
		mint|linux*mint)
			my_distro="Mint"
			. lib/Linux/Ubuntu/mint/extra.sh
			;;
		netbsd) my_distro="NetBSD" ;;
		netrunner) my_distro="Netrunner" ;;
		nix|nix*os) my_distro="NixOS" ;;
		obarun) my_distro="Obarun" ;;
		ol|oracle*linux) my_distro="Oracle Linux" ;;
		openbsd) my_distro="OpenBSD" ;;
		*suse*) 
			my_distro="openSUSE"
			. lib/Linux/SUSE/suse/extra.sh
			;;
		os*elbrus) my_distro="OS Elbrus" ;;
		parabolagnu|parabolagnu/linux-libre|'parabola gnu/linux-libre'|parabola) my_distro="Parabola GNU/Linux-libre" ;;
		parrot|parrot*security) my_distro="Parrot Security" ;;
		pclinuxos|pclos) my_distro="PCLinuxOS" ;;
		peppermint) my_distro="Peppermint" ;;
		proxmox|proxmox*ve) my_distro="Proxmox VE" ;;
		pureos) my_distro="PureOS" ;;
		qubes) my_distro="Qubes OS" ;;
		raspbian) my_distro="Raspbian" ;;
		red*hat*|rhel) my_distro="Red Hat Enterprise Linux" ;;
		rosa) my_distro="ROSA" ;;
		sabayon) my_distro="Sabayon" ;;
		sailfish|sailfish*os)
			my_distro="SailfishOS"
			. lib/Linux/Independent/sailfish/extra.sh
			;;
		scientific*) my_distro="Scientific Linux" ;;
		siduction) my_distro="Siduction" ;;
		smgl|source*mage|source*mage*gnu*linux) my_distro="Source Mage GNU/Linux" ;;
		solus) my_distro="Solus" ;;
		sparky|sparky*linux) my_distro="SparkyLinux" ;;
		steam|steam*os) my_distro="SteamOS" ;;
		tinycore|tinycore*linux) my_distro="TinyCore" ;;
		trisquel) my_distro="Trisquel";;
		ubuntu) 
			my_distro="Ubuntu"
			. lib/Linux/Ubuntu/ubuntu/extra.sh
			. lib/Linux/Ubuntu/ubuntu/ascii.sh
			;;
		void*linux) my_distro="Void Linux" ;;
		zorin*) my_distro="Zorin OS" ;;
		endeavour*) my_distro="EndeavourOS" ;;
		*"windows"*)
			. lib/Windows/ascii.sh
			;;
		*"macos"*)
			. lib/macOS/ascii.sh
			;;
		*"mac os x"*)
			. lib/macOS/ascii.sh
			;;
		*) my_distro="Unknown" ;;
	esac

	# shellcheck disable=SC2154
	case ${config_distro[short]} in
		on)
			:
			;;
		version)
			[ -n "${distro_release}" ] && my_distro+=" ${distro_release}"
			;;
		codename)
			[ -n "${distro_codename}" ] && my_distro+=" ${distro_codename}"
			;;

		full)
			[ -n "${distro_release}" ] && my_distro+=" ${distro_release}"
			[ -n "${distro_codename}" ] && my_distro+=" ${distro_codename}"
			;;
		auto|*)
			# shellcheck disable=SC2154
			if [[ ${config_global[short]} =~ 'on' ]]; then
				:
			else
				[ -n "${distro_release}" ] && my_distro+=" ${distro_release}"
				[ -n "${distro_codename}" ] && my_distro+=" ${distro_codename}"
			fi
			;;
	esac

	[[ ${config_distro[os_arch]} =~ 'on' ]] && my_distro+=" ${kernel_machine}"

	verboseOut "Finding distribution...found as '${my_distro}'."
}

detect_userinfo () {
	# shellcheck disable=SC2154
	if [[ "${config_userinfo[display_user]}" =~ "on" ]]; then
		my_user=${USER}
		if [ -z "${USER}" ]; then
			my_user=$(whoami)
		fi
		my_userinfo="${my_user}"
	fi

	# shellcheck disable=SC2154
	if [[ "${config_userinfo[display_hostname]}" =~ "on" ]]; then
		my_host="${HOSTNAME}"
		if [ "${my_distro}" == "Mac OS X" ] || [ "${my_distro}" == "macOS" ]; then
			my_host=${my_host/.local}
		fi
		if [ -n "${my_userinfo}" ]; then my_userinfo="${my_userinfo}@${my_host}"
		else my_userinfo="${my_host}"; fi
	fi

	verboseOut "Finding user info...found as '${my_userinfo}'."
}

detect_uptime () {
	# get seconds up since boot
	case ${my_os} in
		"Mac OS X"|"macOS"|BSD)
			boot=$(sysctl -n kern.boottime)
			[[ ${boot} =~ [0-9]+ ]] && boot=${BASH_REMATCH[0]}
			now=$(date +%s)
			_seconds=$((now-boot))
			;;
		Linux|Windows|[G|g][N|n][U|u])
			if [ -f /proc/uptime ]; then
				_seconds=$(</proc/uptime)
				_seconds=${_seconds//.*}
			else
				boot=$(date -d"$(uptime -s)" +%s)
				now=$(date +%s)
				_seconds=$((now - boot))
			fi
			;;
		Haiku)
			_seconds=$(($(system_time) / 1000000))
			;;
		*) return ;;
	esac

	# math!
	_mins="$((_seconds/ 60 % 60)) minutes"
	_hours="$((_seconds / 3600 % 24)) hours"
	_days="$((_seconds / 86400)) days"

	# get rid of plurals
	((${_mins/ *} == 1)) && _mins=${_mins/s}
	((${_hours/ *} == 1)) && _hours=${_hours/s}
	((${_days/ *} == 1)) && _days=${_days/s}

	# don't output if field is empty
    ((${_mins/ *} == 0)) && unset _mins
    ((${_hours/ *} == 0)) && unset _hours
    ((${_days/ *} == 0)) && unset _days

	# build the uptime line
    my_uptime=${_days:+${_days}, }${_hours:+${_hours}, }${_mins}
    my_uptime=${my_uptime%', '}
    my_uptime=${my_uptime:-${_seconds} seconds}

	# shorthand
	# shellcheck disable=SC2154
	case ${config_uptime[short]} in
		on)
			my_uptime=${my_uptime/ minutes/ mins}
			my_uptime=${my_uptime/ minute/ min}
			my_uptime=${my_uptime/ seconds/ secs}
			;;
		tiny)
			my_uptime=${my_uptime/ days/d}
			my_uptime=${my_uptime/ day/d}
			my_uptime=${my_uptime/ hours/h}
			my_uptime=${my_uptime/ hour/h}
			my_uptime=${my_uptime/ minutes/m}
			my_uptime=${my_uptime/ minute/m}
			my_uptime=${my_uptime/ seconds/s}
			my_uptime=${my_uptime//,}
			;;
		off)
			:
			;;
		auto|*)
			# shellcheck disable=SC2154
			if [[ "${config_global[short]}" =~ 'on' ]]; then
				my_uptime=${my_uptime/ minutes/ mins}
				my_uptime=${my_uptime/ minute/ min}
				my_uptime=${my_uptime/ seconds/ secs}
			fi
			;;
	esac

	verboseOut "Finding current uptime...found as '${my_uptime}'."
}

detect_packages () {
	# most of this is pulled from neofetch with small edits to line up with
	# previous screenfetch functionality

    # to adjust the number of pkgs per pkg manager
    pkgs_h=0

    # _has: Check if package manager installed.
    # _dir: Count files or dirs in a glob.
    # _pac: If packages > 0, log package manager name.
    # _tot: Count lines in command output.
    _has() { type -p "${1}" >/dev/null && manager=${1}; }
    _dir() { ((my_packages+=$#)); _pac "$(($#-pkgs_h))"; }
    _pac() { ((${1} > 0)) && { managers+=("${1} (${manager})"); manager_string+="${manager}, "; }; }
    _tot() {
		IFS=$'\n' read -d "" -ra pkgs <<< "$("$@" 2>/dev/null)";
		((my_packages+=${#pkgs[@]}));
		_pac "$((${#pkgs[@]}-pkgs_h))";
    }

    # Redefine _tot() for Bedrock Linux.
    [[ -f /bedrock/etc/bedrock-release && ${PATH} == */bedrock/cross/* ]] && {
        _tot() {
            IFS=$'\n' read -d "" -ra pkgs <<< "$(for s in $(brl list); do strat -r "${s}" "${@}"; done)"
            ((my_packages+="${#pkgs[@]}"))
			_pac "$((${#pkgs[@]}-pkgs_h))";
        }
        br_prefix="/bedrock/strata/*"
    }

	# get total packages based on OS value
	case ${my_os} in
		Linux|BSD|Solaris)
			# simple commands
			_has kiss			&& _tot kiss 1
			_has cpt-list		&& _tot cpt-list
			_has pacman-key		&& _tot pacman -Qq --color never
			_has apt			&& _tot dpkg-query -W 	# dpkg-query is much faster than apt
			_has rpm			&& _tot rpm -qa
			_has xbps-query		&& _tot xbps-query -list
			_has apk			&& _tot apk info
			_has opkg			&& _tot opkg list-installed
			_has pacman-g2		&& _tot pacman-g2 -q
			_has lvu			&& _tot lvu installed
			_has tce-status		&& _tot tce-status -lvu
			_has pkg_info		&& _tot pkg_info
			_has tazpkg			&& pkgs_h=6 _tot tazpkg list && ((my_packages-=6))
			_has sorcery		&& _tot gaze installed
			_has alps			&& _tot alps showinstalled
			_has butch			&& _tot butch list
			_has swupd			&& _tot swupd bundle-list --quiet
			_has pisi			&& _tot pisi list-installed
			_has inary			&& _tot inary li

			# 'mine' conflicts with minesweeper games.
            [[ -f /etc/SDE-VERSION ]] && _has mine && _tot mine -q

			# file/dir count
			# $br_prefix is apparently fixed and won't change based on user input
			# shellcheck disable=SC2086
			{
				shopt -s nullglob
				_has brew		&& _dir "$(brew --cellar)"/*
				_has emerge		&& _dir ${br_prefix}/var/db/pkg/*/*/
				_has Compile	&& _dir ${br_prefix}/Programs/*/
				_has eopkg		&& _dir ${br_prefix}/var/lib/eopkg/package/*
				_has crew		&& _dir ${br_prefix}/usr/local/etc/crew/meta/*.filelist
				_has pkgtool	&& _dir ${br_prefix}/var/log/packages/*
				_has scratch	&& _dir ${br_prefix}/var/lib/scratchpkg/index/*/.pkginfo
				_has kagami		&& _dir ${br_prefix}/var/lib/kagami/pkgs/*
				_has cave		&& _dir ${br_prefix}/var/db/paludis/repositories/cross-installed/*/data/*/ \
										${br_prefix}/var/db/paludis/repositories/installed/data/*/
				shopt -u nullglob
			}

			# Complex commands
            _has kpm-pkg 		&& ((my_packages+=$(kpm  --get-selections | grep -cv deinstall$)))
			_has guix 			&& {
                manager=guix-system && _tot guix package -p "/run/current-system/profile" -I
                manager=guix-user   && _tot guix package -I
            }
            _has nix-store 		&& {
                nix-user-pkgs() {
                    nix-store -qR ~/.nix-profile
                    nix-store -qR /etc/profiles/per-user/"${USER}"
                }
                manager=nix-system	&& _tot nix-store -qR /run/current-system/sw
                manager=nix-user	&& _tot nix-user-pkgs
                manager=nix-default && _tot nix-store -qR /nix/var/nix/profiles/default
            }

            # pkginfo is also the name of a python package manager which is painfully slow.
            # TODO: Fix this somehow. (neofetch)
            _has pkginfo && _tot pkginfo -i

			# BSD-like package detection
            case ${kernel_name} in
                FreeBSD|DragonFly) _has pkg && _tot pkg info ;;
                *)
                    _has pkg && _dir /var/db/pkg/*
                    ((my_packages == 0)) && _has pkg && _tot pkg list
                ;;
            esac

			# list these last as they accompany regular package managers.
            _has flatpak && _tot flatpak list
            _has spm     && _tot spm list -i
            _has puyo    && _dir ~/.puyo/installed

            # Snap hangs if the command is run without the daemon running.
            # Only run snap if the daemon is also running.
            _has snap && pgrep -x snapd >/dev/null && \
				pkgs_h=1 _tot snap list && ((my_packages-=1))

            # This is the only standard location for appimages.
            # See: https://github.com/AppImage/AppImageKit/wiki
            manager=appimage && _has appimaged && _dir ~/.local/bin/*.appimage
			;;
		"Mac OS X"|"macOS")
            _has port  && pkgs_h=1 _tot port installed && ((my_packages-=1))
            _has brew  && _dir /usr/local/Cellar/*
            _has nix-store && {
                nix-user-pkgs() {
                    nix-store -qR ~/.nix-profile
                    nix-store -qR /etc/profiles/per-user/"${USER}"
                }
                manager=nix-system && _tot nix-store -qR /run/current-system/sw
                manager=nix-user   && _tot nix-store -qR nix-user-pkgs
            }
			;;
        Windows)
            case ${kernel_name} in
                CYGWIN*)	_has cygcheck && _tot cygcheck -cd ;;
                MSYS*)		_has pacman   && _tot pacman -Qq --color never ;;
				*)			: ;;
            esac

            # Scoop environment throws errors if `tot scoop list` is used
            _has scoop && pkgs_h=1 _dir ~/scoop/apps/* && ((my_packages-=1))

			# Count chocolatey packages.
			_has choco && _dir /c/ProgramData/chocolatey/lib/*
            [ -d /cygdrive/c/ProgramData/chocolatey/lib ] && \
				manager=choco _dir /cygdrive/c/ProgramData/chocolatey/lib/*
			;;
        Haiku)
            _has pkgman && _dir /boot/system/package-links/*
            my_packages=${my_packages/pkgman/depot}
			;;
		*) return ;;
	esac

	if ((my_packages == 0)); then
		unset my_packages
	else
		# shellcheck disable=SC2154
		case ${config_packages[managers]} in
			off)
				:
				;;
			split)
				printf -v my_packages '%s, ' "${managers[@]}"
				my_packages=${my_packages%,*}
				;;
			on|*)
				my_packages+=" (${manager_string%,*})"
				;;
		esac
		# replace pacman-key with pacman
		my_packages=${my_packages/pacman-key/pacman}
	fi

	verboseOut "Finding current package count...found as '${my_packages}'."
}

detect_shell () {
	# get configuration on whether full shell path should be displayed
	# shellcheck disable=SC2154
	case ${config_shell[path]} in
		on) shell_type="${SHELL}" ;;
		off|*) shell_type="${SHELL##*/}" ;;
	esac

	# if version_info is off, then return what we have now
	# shellcheck disable=SC2154
	[ "${config_shell[version]}" != "on" ] && my_shell="${shell_type}" && return

	# Possible Windows problem
	[ "${my_os}" == "Windows" ] && shell_name="${shell_type//\.exe/}"

	# get shell versions
	my_shell="${shell_name:=${shell_type}} "
	case ${shell_name:=${SHELL##*/}} in
		bash)
			[[ -n ${BASH_VERSION} ]] || BASH_VERSION=$("${SHELL}" -c "printf %s \"\$BASH_VERSION\"")
			my_shell+="${BASH_VERSION/-*}"
			;;
		sh|ash|dash|es) ;;
		*ksh)
			my_shell+=$("${SHELL}" -c "printf %s \"\$KSH_VERSION\"")
			my_shell=${my_shell/ * KSH}
			my_shell=${my_shell/version}
			;;
		osh)
			# shellcheck disable=SC2154
			{
				if [[ -n ${OIL_VERSION} ]]; then
					my_shell+=${OIL_VERSION}
				else
					my_shell+=$("${SHELL}" -c "printf %s \"\$OIL_VERSION\"")
				fi
			}
			;;
		tcsh)
			my_shell+=$("${SHELL}" -c "printf %s \$tcsh")
			;;
		yash)
			my_shell+=$("${SHELL}" --version 2>&1)
			my_shell=${my_shell/ ${shell_name}}
			my_shell=${my_shell/ Yet another shell}
			my_shell=${my_shell/Copyright*}
			;;
		fish)
			[[ -n "${FISH_VERSION}" ]] || FISH_VERSION=$("${SHELL}" -c "printf %s \"\$FISH_VERSION\"")
			my_shell+="${FISH_VERSION}"
			;;
		*)
			my_shell+=$("${SHELL}" --version 2>&1)
			my_shell=${my_shell/ ${shell_name}}
			;;
	esac

    # remove unwanted
    my_shell=${my_shell/, version}
    my_shell=${my_shell/xonsh\//xonsh }
    my_shell=${my_shell/options*}
    my_shell=${my_shell/\(*\)}

	verboseOut "Finding current shell...found as '${my_shell}'."
}

detect_cpu () {
	case ${my_os} in
		"Mac OS X"|"macOS")
			my_cpu="$(sysctl -n machdep.cpu.brand_string)"
			_cores=$(sysctl -n hw.logicalcpu_max)
			;;
		"Linux" | "Windows" )
			_file="/proc/cpuinfo"
			case ${kernel_machine} in
                "frv" | "hppa" | "m68k" | "openrisc" | "or"* | "powerpc" | "ppc"* | "sparc"*)
                    my_cpu="$(awk -F':' '/^cpu\t|^CPU/ {printf $2; exit}' "${_file}")"
					;;
                "s390"*)
                    my_cpu="$(awk -F'=' '/machine/ {print $4; exit}' "${_file}")"
					;;	
                "ia64" | "m32r")
                    my_cpu="$(awk -F':' '/model/ {print $2; exit}' "${_file}")"
                    [[ -z "${my_cpu}" ]] && my_cpu="$(awk -F':' '/family/ {printf $2; exit}' "${_file}")"
					;;
                *)
                    my_cpu="$(awk -F '\\s*: | @' \
                            '/model name|Hardware|Processor|^cpu model|chip type|^cpu type/ {
                            cpu=$2; if ($1 == "Hardware") exit } END { print cpu }' "${_file}")"
							;;
            esac

			_speed_dir="/sys/devices/system/cpu/cpu0/cpufreq"

			# Select the right temperature file.
			[[ -d /sys/class/hwmon && -n "$(ls -A /sys/class/hwmon)" ]] && \
				for temp_dir in /sys/class/hwmon/*; do
					if [ -n "${temp_dir}" ]; then
						[[ "$(< "${temp_dir}/name")" =~ (cpu_thermal|coretemp|fam15h_power|k10temp) ]] && {
							temp_dirs=("${temp_dir}"/temp*_input)
							temp_dir=${temp_dirs[0]}
							break
						}
					fi
				done

			# Get CPU speed.
			if [ -d "${_speed_dir}" ]; then
				# Fallback to bios_limit if $speed_type fails.
				_speed="$(< "${_speed_dir}/bios_limit")" ||\
				_speed="$(< "${_speed_dir}/scaling_max_freq")" ||\
				_speed="$(< "${_speed_dir}/cpuinfo_max_freq")"
				_speed="$((_speed / 1000))"
			else
				_speed="$(awk -F ': |\\.' '/cpu MHz|^clock/ {printf $2; exit}' "${_file}")"
				_speed="${_speed/MHz}"
			fi

			# Get CPU temp.
			[ -f "${temp_dir}" ] && _deg="$(($(< "${temp_dir}") * 100 / 10000))"

			# Get CPU cores.
			_cores="$(grep -c "^processor" "${_file}")"
			;;
		*) return ;;
	esac

    # Remove un-needed patterns from cpu output.
    my_cpu="${my_cpu//(TM)}"
    my_cpu="${my_cpu//(tm)}"
    my_cpu="${my_cpu//(R)}"
    my_cpu="${my_cpu//(r)}"
	my_cpu="${my_cpu//?([+[:space:]])CPU}"
    my_cpu="${my_cpu//Processor}"
    my_cpu="${my_cpu//Dual-Core}"
    my_cpu="${my_cpu//Quad-Core}"
    my_cpu="${my_cpu//Six-Core}"
    my_cpu="${my_cpu//Eight-Core}"
    my_cpu="${my_cpu//[1-9][0-9]-Core}"
    my_cpu="${my_cpu//[0-9]-Core}"
    my_cpu="${my_cpu//, * Compute Cores}"
    my_cpu="${my_cpu//Core / }"
    my_cpu="${my_cpu//(\"AuthenticAMD\"*)}"
    my_cpu="${my_cpu//with Radeon * Graphics}"
	my_cpu="${my_cpu// with Radeon * Gfx}"
    my_cpu="${my_cpu//, altivec supported}"
    my_cpu="${my_cpu//FPU*}"
    my_cpu="${my_cpu//Chip Revision*}"
    my_cpu="${my_cpu//Technologies, Inc}"
    my_cpu="${my_cpu//Core2/Core 2}"

    # Trim spaces from core and speed output
    _cores="${_cores//[[:space:]]}"
    _speed="${_speed//[[:space:]]}"

    # Remove CPU brand from the output.
	# shellcheck disable=SC2154
    if [ "${config_cpu[brand]}" == "off" ]; then
        my_cpu="${my_cpu/AMD }"
        my_cpu="${my_cpu/Intel }"
        my_cpu="${my_cpu/Core? Duo }"
        my_cpu="${my_cpu/Qualcomm }"
    fi

    # Add CPU cores to the output.
	# shellcheck disable=SC2154
    [[ "${config_cpu[cores]}" != "off" && -n "${_cores}" ]] && \
        case ${my_os} in
            "Mac OS X"|"macOS") my_cpu="${my_cpu/@/(${_cores}) @}" ;;
            *)                  my_cpu="${my_cpu} (${_cores})" ;;
        esac

    # Add CPU speed to the output.
	# shellcheck disable=SC2154
    if [[ "${config_cpu[speed]}" != "off" && -n "${_speed}" ]]; then
        if (( _speed < 1000 )); then
            my_cpu="${my_cpu} @ ${_speed}MHz"
        else
            _speed="${_speed:0:1}.${_speed:1}"
            my_cpu="${my_cpu} @ ${_speed}GHz"
        fi
    fi

    # Add CPU temp to the output.
	# shellcheck disable=SC2154
	{
		if [[ "${config_cpu[temp]}" != "off" && -n "${_deg}" ]]; then
			_deg="${_deg//.}"

			# Convert to Fahrenheit if enabled
			[[ "${config_cpu[temp]}" == "F" ]] && _deg="$((_deg * 90 / 50 + 320))"

			# Format the output
			_deg="[${_deg/${_deg: -1}}.${_deg: -1}°${config_cpu[temp]:-C}]"
			my_cpu="${my_cpu} ${_deg}"
		fi
	}

	verboseOut "Finding CPU...found as '${my_cpu}'."
}

# functions: output
info () {
	local _info="${1}"
	local _info_disp="my_${_info}"
	
	if [ -n "${!_info_disp}" ]; then
		_info_subtitle="config_${_info}[subtitle]"
		if [ -n "${!_info_subtitle}" ]; then
			# shellcheck disable=SC2154
			printf '%b\n' "${!_info_subtitle}${config_text[info_separator]} ${!_info_disp}"
		else
			printf '%b\n' "${!_info_disp}"
		fi
	else
		:
	fi
}

format_ascii () {
	local _logo="${1}"

	# Calculate: (max detected logo width - length of current line)
	_tmp="${_logo//\$\{??\}}"
	_tmp=${_tmp//\\\\/\\}
	_tmp=${_tmp//█/ }
	if ((${#_tmp}<ascii_len)); then
		logo_padding=$((ascii_len - ${#_tmp}))
	else
		logo_padding=0
	fi

	# Expand color variables
	_logo="${_logo//\$\{c1\}/$c1}"
    _logo="${_logo//\$\{c2\}/$c2}"
    _logo="${_logo//\$\{c3\}/$c3}"
    _logo="${_logo//\$\{c4\}/$c4}"
    _logo="${_logo//\$\{c5\}/$c5}"
    _logo="${_logo//\$\{c6\}/$c6}"

	((text_padding=logo_padding+gap))
	printf "%b \e[%sC" "${_logo}" "${text_padding}"
}

print_ascii () {
    while IFS=$'\n' read -r line; do
        line=${line//\\\\/\\}
        line=${line//█/ }
        ((++lines,${#line}>ascii_len)) && ascii_len="${#line}"
    done <<< "${asciiLogo//\$\{??\}}"

	n=0
	# shellcheck disable=SC2154
	read -r -a _display <<< "${config_global[info]}"
	while IFS=$'\n' read -r line; do
		# shellcheck disable=SC2154
		gap=${config_ascii[gap]}

		# call format_ascii to prepare for info display
		line=$(format_ascii "${line}")

		# Display logo and info
		if [ ${n} -lt "${startline}" ]; then
			printf '%b\n' "${line}${reset}"
		elif [ ${n} -ge "${startline}" ]; then
			if ((${#_display}>0)); then
				_info_display="my_${_display[0]}"
				until [ -n "${!_info_display}" ]; do
					((${#_display}<=0)) && break
					_display=("${_display[@]:1}")
					_info_display="my_${_display[0]}"
				done
				_info_display=$(info "${_display[0]}")
				if [ -n "${_info_display}" ]; then
					printf '%b\n' "${line}${reset}${_info_display}"
				else
					continue
				fi
				_display=("${_display[@]:1}")
			else
				printf '%b\n' "${line}${reset}"
			fi
		fi

		# Cleanup
		((n++))
		unset _tmp
		unset _padding
	done <<< "${asciiLogo}"

	unset n
	unset i
}

usage() {
	printf "Help!\n"
}

versioninfo () {
	printf 'fetch %s\n' "${FETCH_VERSION}"
}

# Catch configuration flag
[[ "$*" != *--config* ]] && fetchConfig "${FETCH_DATA_USER_DIR}/${FETCH_CONFIG_FILENAME}"

# Execution flag detection
case ${1} in
	--help) usage; exit 0;;
	--version) versioninfo; exit 0;;
	--config)
		FETCH_CONFIG="${2}"
		fetchConfig "${FETCH_CONFIG}"
		shift 2
		;;
	*) : ;;
esac

while getopts ":hvVD:" flags; do
	case ${flags} in
		h) usage; exit 0 ;;
		V) versioninfo; exit 0 ;;
		v) declare config_global[verbose]="on" ;;
		D) my_distro="${OPTARG}" ;;
		:) errorOut "Error: You're missing an argument somewhere. Exiting."; exit 1 ;;
		?) errorOut "Error: Invalid flag somewhere. Exiting."; exit 1 ;;
		*) errorOut "Error"; exit 1 ;;
	esac
done

detect_kernel
detect_os

for i in ${config_global[info]}; do
	eval "detect_${i}"
done

print_ascii

((extglob_set)) && shopt -u extglob
