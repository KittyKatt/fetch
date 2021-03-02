#!/usr/bin/env bash

FETCH_VERSION="0.5"
FETCH_DATA_DIR="/usr/share/fetch"
FETCH_DATA_USER_DIR="${XDG_CONFIG_HOME:-$HOME}/.config/fetch"
FETCH_CONFIG_FILENAME="config"
LC_ALL=C
LANG=C
# https://github.com/KittyKatt/screenFetch/issues/549
if [[ "${OSTYPE}" =~ "linux" || "${OSTYPE}" == "gnu" ]]; then
	# issue seems to affect Ubuntu; add LSB directories if it appears on other distros too
	export GIO_EXTRA_MODULES="/usr/lib/x86_64-linux-gnu/gio/modules:/usr/lib/i686-linux-gnu/gio/modules:$GIO_EXTRA_MODULES"
fi

# Set shopt extglob for filename-like globbing in case statements. Check if exttglob was set before and store that as a variable.
shopt -q extglob; extglob_set=$?
((extglob_set)) && shopt -s extglob

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
# Taken from neofetch
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

fetchConfig () {
	if [ -f "${1}" ]; then
		while read -r line; do
			if [[ ${line} =~ ^\[[[:alnum:]]+\] ]]; then
				arrname="config_${line//[^[:alnum:]]/}"
				declare -gA "$arrname"
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
	color=$((${RANDOM} % 255))
	echo "${color}"
}

detect_kernel () {
    IFS=" " read -ra kernel <<< "$(uname -srm)"
    myKernel_name="${kernel[0]}"
    myKernel_version="${kernel[1]}"
    myKernel_machine="${kernel[2]}"

	# pulled from neofetch source
    if [ "${myKernel_name}" == "Darwin" ]; then
        # macOS can report incorrect versions unless this is 0.
        # https://github.com/dylanaraps/neofetch/issues/1607
        export SYSTEM_VERSION_COMPAT=0

        IFS=$'\n' read -d "" -ra sw_vers <<< "$(awk -F'<|>' '/key|string/ {print $3}' \
                            "/System/Library/CoreServices/SystemVersion.plist")"
        for ((i=0;i<${#sw_vers[@]};i+=2)) {
            case ${sw_vers[i]} in
                ProductName)          darwin_name=${sw_vers[i+1]} ;;
                ProductVersion)       osx_version=${sw_vers[i+1]} ;;
                ProductBuildVersion)  osx_build=${sw_vers[i+1]}   ;;
            esac
        }
    fi

	# shellcheck disable=SC2154
	case ${config_kernel[short]} in
		on)
			myKernel="${myKernel_version}"
			;;
		off)
			myKernel="${myKernel_name} ${myKernel_version}"
			;;
		auto)
			# shellcheck disable=SC2154
			if [[ ${config_global[short]} =~ 'on' ]]; then
				myKernel="${myKernel_version}"
			else
				myKernel="${myKernel_name} ${myKernel_version}"
			fi
			;;
	esac

	verboseOut "Finding kernel...found as '${myKernel}'."
}

detect_os () {
	case "${myKernel_name}" in
        Darwin)   myOS=${darwin_name} ;;
        SunOS)    myOS=Solaris ;;
        Haiku)    myOS=Haiku ;;
        MINIX)    myOS=MINIX ;;
        AIX)      myOS=AIX ;;
        IRIX*)    myOS=IRIX ;;
        FreeMiNT) myOS=FreeMiNT ;;
        Linux|GNU*)
            myOS=Linux
        ;;
        *BSD|DragonFly|Bitrig)
            myOS=BSD
        ;;
        CYGWIN*|MSYS*|MINGW*)
            myOS=Windows
        ;;
        *)
            errorOut "Unknown OS detected, please report this issue."
        ;;
    esac
	verboseOut "Finding OS...found as '${myOS}'."
}

# Distro Detection - Begin
detect_distro () {
	if [ -z "${distro}" ]; then
		local distro_detect=
		distro="Unknown"
		if [ "${myOS}" == "Linux" ] && [ "${distro}" == "Unknown" ]; then
			# LSB Release Check
			if type -p lsb_release >/dev/null 2>&1; then
				distro_detect="$(lsb_release -si)"
				distro_release="$(lsb_release -sr)"
				distro_codename="$(lsb_release -sc)"
				case ${distro_detect} in
					"archlinux"|"Arch Linux"|"arch"|"Arch"|"archarm")
						distro="Arch Linux"
						unset distro_release
						;;
					"ALDOS"|"Aldos")
						distro="ALDOS"
						;;
					"ArcoLinux")
						distro="ArcoLinux"
						unset distro_release
						;;
					"artixlinux"|"Artix Linux"|"artix"|"Artix"|"Artix release")
						distro="Artix"
						;;
					"blackPantherOS"|"blackPanther"|"blackpanther"|"blackpantheros")
						distro=$(source /etc/lsb-release; echo "${DISTRIB_ID}")
						distro_release=$(source /etc/lsb-release; echo "${DISTRIB_RELEASE}")
						distro_codename=$(source /etc/lsb-release; echo "${DISTRIB_CODENAME}")
						;;
					"Chakra")
						distro="Chakra"
						unset distro_release
						;;
					"CentOSStream")
						distro="CentOS Stream"
						;;
					"BunsenLabs")
						distro=$(source /etc/lsb-release; echo "${DISTRIB_ID}")
						distro_release=$(source /etc/lsb-release; echo "${DISTRIB_RELEASE}")
						distro_codename=$(source /etc/lsb-release; echo "${DISTRIB_CODENAME}")
						;;
					"Debian")
						distro="Debian"
						;;
					"Deepin")
						distro="Deepin"
						;;
					"elementary"|"elementary OS")
						distro="elementary OS"
						;;
					"EvolveOS")
						distro="Evolve OS"
						;;
					"Sulin")
						distro="Sulin"
						distro_release=$(awk -F'=' '/^ID_LIKE=/ {print $2}' /etc/os-release)
						distro_codename="Roolling donkey" # this is not wrong :D
						;;
					"KaOS"|"kaos")
						distro="KaOS"
						;;
					"frugalware")
						distro="Frugalware"
						unset distro_codename
						unset distro_release
						;;
					"Gentoo")
						distro="Gentoo"
						;;
					"Hyperbola GNU/Linux-libre"|"Hyperbola")
						distro="Hyperbola GNU/Linux-libre"
						unset distro_codename
						unset distro_release
						;;
					"Kali"|"Debian Kali Linux")
						distro="Kali Linux"
						if [[ "${distro_codename}" =~ "kali-rolling" ]]; then
							unset distro_codename
							unset distro_release
						fi
						;;
					"Lunar Linux"|"lunar")
						distro="Lunar Linux"
						;;
					"ManjaroLinux")
						distro="Manjaro"
						;;
					"neon"|"KDE neon")
						distro="KDE neon"
						unset distro_codename
						unset distro_release
						;;
					"Ol"|"ol"|"Oracle Linux")
						distro="Oracle Linux"
						[ -f /etc/oracle-release ] && distro_release="$(sed 's/Oracle Linux //' /etc/oracle-release)"
						;;
					"LinuxMint")
						distro="Mint"
						;;
					"openSUSE"|"openSUSE project"|"SUSE LINUX"|"SUSE"|*SUSELinuxEnterprise*)
						distro="openSUSE"
						;;
					"Parabola GNU/Linux-libre"|"Parabola")
						distro="Parabola GNU/Linux-libre"
						unset distro_codename
						unset distro_release
						;;
					"Parrot"|"Parrot Security")
						distro="Parrot Security"
						;;
					"PCLinuxOS")
						distro="PCLinuxOS"
						unset distro_codename
						unset distro_release
						;;
					"Peppermint")
						distro="Peppermint"
						unset distro_codename
						;;
					"rhel"|*RedHatEnterprise*)
						distro="Red Hat Enterprise Linux"
						;;
					"RosaDesktopFresh")
						distro="ROSA"
						distro_release=$(grep 'VERSION=' /etc/os-release | cut -d ' ' -f3 | cut -d "\"" -f1)
						distro_codename=$(grep 'PRETTY_NAME=' /etc/os-release | cut -d ' ' -f4,4)
						;;
					"SailfishOS")
						distro="SailfishOS"
						;;
					"Sparky"|"SparkyLinux")
						distro="SparkyLinux"
						;;
					"Ubuntu")
						distro="Ubuntu"
						;;
					"Void"|"VoidLinux")
						distro="Void Linux"
						unset distro_codename
						unset distro_release
						;;
					"Zorin")
						distro="Zorin OS"
						unset distro_codename
						;;
				esac
			fi

			# Existing File Check
			if [ "${distro}" == "Unknown" ]; then
				if [ -e "/etc/mcst_version" ]; then
					distro="OS Elbrus"
					distro_release="$(tail -n 1 /etc/mcst_version)"
					if [ -n "${distro_release}" ]; then
						distro_more="${distro_release}"
					fi
				fi
				if [ "$(uname -o 2>/dev/null)" ]; then
					os="$(uname -o)"
					case ${os} in
						"EndeavourOS")
							distro="EndeavourOS"
							fake_distro="${distro}"
						;;
						"GNU/Linux")
							if type -p crux >/dev/null 2>&1; then
								distro="CRUX"
								distro_more="$(crux | awk '{print $3}')"
							fi
							if type -p nixos-version >/dev/null 2>&1; then
								distro="NixOS"
								distro_more="$(nixos-version)"
							fi
							if type -p sorcery >/dev/null 2>&1; then
								distro="SMGL"
							fi
							if (type -p guix && type -p herd) >/dev/null 2>&1; then
								distro="Guix System"
							fi
						;;
					esac
				fi
				if [ "${distro}" == "Unknown" ]; then
					if [ -f /etc/os-release ]; then
						os_release="/etc/os-release";
					elif [ -f /usr/lib/os-release ]; then
						os_release="/usr/lib/os-release";
					fi
					if [ -n "${os_release}" ]; then
						distrib_id=$(<${os_release});
						for l in ${distrib_id}; do
							if [[ ${l} =~ ^ID= ]]; then
								distrib_id=${l//*=}
								distrib_id=${distrib_id//\"/}
								break 1
							fi
						done
						if [ -n "${distrib_id}" ]; then
							if [ "${BASH_VERSINFO[0]}" -ge 4 ]; then
								distrib_id=$(for i in ${distrib_id}; do echo -n "${i^} "; done)
								distro=${distrib_id% }
								unset distrib_id
							else
								distrib_id=$(for i in ${distrib_id}; do FIRST_LETTER=$(echo -n "${i:0:1}" | tr "[:lower:]" "[:upper:]"); echo -n "${FIRST_LETTER}${i:1} "; done)
								distro=${distrib_id% }
								unset distrib_id
							fi
						fi

						# Hotfixes
						[ "${distro}" == "Opensuse-tumbleweed" ] && distro="openSUSE" && distro_more="Tumbleweed"
						[ "${distro}" == "Opensuse-leap" ] && distro="openSUSE"
						[ "${distro}" == "void" ] && distro="Void Linux"
						[ "${distro}" == "evolveos" ] && distro="Evolve OS"
						[ "${distro}" == "Sulin" ] && distro="Sulin"
						[[ "${distro}" == "Arch" || "${distro}" == "Archarm" || "${distro}" == "archarm" ]] && distro="Arch Linux"
						[ "${distro}" == "elementary" ] && distro="elementary OS"
						[[ "${distro}" == "Fedora" && -d /etc/qubes-rpc ]] && distro="qubes" # Inner VM
						[[ "${distro}" == "Ol" || "${distro}" == "ol" ]] && distro="Oracle Linux"
						if [[ "${distro}" == "Oracle Linux" && -f /etc/oracle-release ]]; then
							distro_more="$(sed 's/Oracle Linux //' /etc/oracle-release)"
						fi
						# Upstream problem, SL and so EL is using rhel ID in os-release
						if [ "${distro}" == "rhel" ] || [ "${distro}" == "Rhel" ]; then
							distro="Red Hat Enterprise Linux"
							if grep -q 'Scientific' /etc/os-release; then
								distro="Scientific Linux"
							elif grep -q 'EuroLinux' /etc/os-release; then
								distro="EuroLinux"
							fi
						fi	

						[ "${distro}" == "Neon" ] && distro="KDE neon"
						[[ "${distro}" == "SLED" || "${distro}" == "sled" || "${distro}" == "SLES" || "${distro}" == "sles" ]] && distro="SUSE Linux Enterprise"
						if [ "${distro}" == "SUSE Linux Enterprise" ] && [ -f /etc/os-release ]; then
							distro_more="$(awk -F'=' '/^VERSION_ID=/ {print $2}' /etc/os-release | tr -d '"')"
						fi
						if [ "${distro}" == "Debian" ] && [ -f /usr/bin/pveversion ]; then
							distro="Proxmox VE"
							unset distro_codename
							distro_release="$(/usr/bin/pveversion | grep -oP 'pve-manager\/\K\d+\.\d+')"
						fi
					fi
				fi

				if [[ "${distro}" == "Unknown" && "${OSTYPE}" =~ "linux" && -f /etc/lsb-release ]]; then
					LSB_RELEASE=$(</etc/lsb-release)
					distro=$(echo "${LSB_RELEASE}" | awk 'BEGIN {
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

				if [ "${distro}" == "Unknown" ] && [[ "${OSTYPE}" =~ "linux" || "${OSTYPE}" == "gnu" ]]; then
					for di in arch chakra evolveos exherbo fedora \
								frugalware gentoo kogaion mageia obarun oracle \
								pardus pclinuxos redhat rosa SuSe; do
						if [ -f /etc/${di}-release ]; then
							distro=${di}
							break
						fi
					done
					if [ "${distro}" == "oracle" ]; then
						distro_more="$(sed 's/Oracle Linux //' /etc/oracle-release)"
					elif [ "${distro}" == "SuSe" ]; then
						distro="openSUSE"
						if [ -f /etc/os-release ]; then
							if grep -q -i 'SUSE Linux Enterprise' /etc/os-release ; then
								distro="SUSE Linux Enterprise"
								distro_more=$(awk -F'=' '/^VERSION_ID=/ {print $2}' /etc/os-release | tr -d '"')
							fi
						fi
						if [[ "${distro_more}" =~ "Tumbleweed" ]]; then
							distro_more="Tumbleweed"
						fi
					elif [ "${distro}" == "redhat" ]; then
						grep -q -i 'CentOS' /etc/redhat-release && distro="CentOS"
						grep -q -i 'Scientific' /etc/redhat-release && distro="Scientific Linux"
						grep -q -i 'EuroLinux' /etc/redhat-release && distro="EuroLinux"
						grep -q -i 'PCLinuxOS' /etc/redhat-release && distro="PCLinuxOS"
					fi
				fi

				if [ "${distro}" == "Unknown" ]; then
					if [[ "${OSTYPE}" =~ "linux" || "${OSTYPE}" == "gnu" ]]; then
						if [ -f /etc/debian_version ]; then
							if [ -f /etc/issue ]; then
								if grep -q -i 'gNewSense' /etc/issue ; then
									distro="gNewSense"
								elif grep -q -i 'KDE neon' /etc/issue ; then
									distro="KDE neon"
									distro_more="$(cut -d ' ' -f3 /etc/issue)"
								else
									distro="Debian"
								fi
							fi
							if grep -q -i 'Kali' /etc/debian_version ; then
								distro="Kali Linux"
							fi
						elif [ -f /etc/NIXOS ]; then distro="NixOS"
						elif [ -f /etc/dragora-version ]; then
							distro="Dragora"
							distro_more="$(cut -d, -f1 /etc/dragora-version)"
						elif [ -f /etc/slackware-version ]; then distro="Slackware"
						elif [ -f /usr/share/doc/tc/release.txt ]; then
							distro="TinyCore"
							distro_more="$(cat /usr/share/doc/tc/release.txt)"
						elif [ -f /etc/sabayon-edition ]; then distro="Sabayon"
						fi
					fi
				fi

				if [ "${distro}" == "Unknown" ] && [[ "${OSTYPE}" =~ "linux" || "${OSTYPE}" == "gnu" ]]; then
					if [ -f /etc/issue ]; then
						distro=$(awk 'BEGIN {
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

				if [ "${distro}" == "Unknown" ] && [[ "${OSTYPE}" =~ "linux" || "${OSTYPE}" == "gnu" ]]; then
					if [ -f /etc/system-release ]; then
						if grep -q -i 'Scientific Linux' /etc/system-release; then
							distro="Scientific Linux"
						elif grep -q -i 'Oracle Linux' /etc/system-release; then
							distro="Oracle Linux"
						fi
					elif [ -f /etc/lsb-release ]; then
						if grep -q -i 'CHROMEOS_RELEASE_NAME' /etc/lsb-release; then
							distro="$(awk -F'=' '/^CHROMEOS_RELEASE_NAME=/ {print $2}' /etc/lsb-release)"
							distro_more="$(awk -F'=' '/^CHROMEOS_RELEASE_VERSION=/ {print $2}' /etc/lsb-release)"
						fi
					fi
				fi
			fi
		elif [ "${myOS}" == "Windows" ]; then
			distro=$(wmic os get Caption)
			distro=${distro/Caption}
			distro=$(trim "${distro/Microsoft }")
			[[ $distro =~ [[:space:]](.*) ]] && distro=${BASH_REMATCH[1]}
			distro=${distro%%+([[:space:]])}
		elif [[ "${myOS}" =~ [Mm]ac ]]; then
			case $osx_version in
				10.4*)  distro="Mac OS X Tiger" ;;
				10.5*)  distro="Mac OS X Leopard" ;;
				10.6*)  distro="Mac OS X Snow Leopard" ;;
				10.7*)  distro="Mac OS X Lion" ;;
				10.8*)  distro="OS X Mountain Lion" ;;
				10.9*)  distro="OS X Mavericks" ;;
				10.10*) distro="OS X Yosemite" ;;
				10.11*) distro="OS X El Capitan" ;;
				10.12*) distro="macOS Sierra" ;;
				10.13*) distro="macOS High Sierra" ;;
				10.14*) distro="macOS Mojave" ;;
				10.15*) distro="macOS Catalina" ;;
				10.16*) distro="macOS Big Sur" ;;
				11.0*)  distro="macOS Big Sur" ;;
				*)      distro="macOS" ;;
			esac
		fi

		case ${distro,,} in
			aldos) distro="ALDOS";;
			alpine) distro="Alpine Linux" ;;
			amzn|amazon|amazon*linux) distro="Amazon Linux" ;;
			arch*linux*old) distro="Arch Linux - Old" ;;
			arch|arch*linux) distro="Arch Linux" ;;
			arch32) distro="Arch Linux 32" ;;
			arcolinux|arcolinux*) distro="ArcoLinux" ;;
			artix|artix*linux) distro="Artix Linux" ;;
			blackpantheros|black*panther*) distro="blackPanther OS" ;;
			bunsenlabs) distro="BunsenLabs" ;;
			centos) distro="CentOS" ;;
			centos*stream) distro="CentOS Stream" ;;
			chakra) distro="Chakra" ;;
			chrome*|chromium*) distro="Chrome OS" ;;
			crux) distro="CRUX" ;;
			debian) 
				distro="Debian"
				. lib/Linux/Debian/debian/extra.sh
				;;
			devuan) distro="Devuan" ;;
			deepin) distro="Deepin" ;;
			dragonflybsd) distro="DragonFlyBSD" ;;
			dragora) distro="Dragora" ;;
			drauger*) distro="DraugerOS" ;;
			elementary|'elementary os') distro="elementary OS";;
			eurolinux) distro="EuroLinux" ;;
			evolveos) distro="Evolve OS" ;;
			sulin) distro="Sulin" ;;
			exherbo|exherbo*linux) distro="Exherbo" ;;
			fedora) distro="Fedora" ;;
			freebsd) distro="FreeBSD" ;;
			freebsd*old) distro="FreeBSD - Old" ;;
			frugalware) distro="Frugalware" ;;
			funtoo) distro="Funtoo" ;;
			gentoo)
				distro="Gentoo"
				. lib/Linux/Gentoo/gentoo/extra.sh
				;;
			gnewsense) distro="gNewSense" ;;
			guix*system) distro="Guix System" ;;
			haiku) distro="Haiku" ;;
			hyperbolagnu|hyperbolagnu/linux-libre|'hyperbola gnu/linux-libre'|hyperbola) distro="Hyperbola GNU/Linux-libre" ;;
			kali*linux) distro="Kali Linux" ;;
			kaos) distro="KaOS";;
			kde*neon|neon)
				distro="KDE neon"
				. lib/Linux/Ubuntu/kdeneon/extra.sh
				;;
			kogaion) distro="Kogaion" ;;
			lmde) distro="LMDE" ;;
			lunar|lunar*linux) distro="Lunar Linux";;
			manjaro) distro="Manjaro" ;;
			mageia) distro="Mageia" ;;
			mer) distro="Mer" ;;
			mint|linux*mint)
				distro="Mint"
				. lib/Linux/Ubuntu/mint/extra.sh
				;;
			netbsd) distro="NetBSD" ;;
			netrunner) distro="Netrunner" ;;
			nix|nix*os) distro="NixOS" ;;
			obarun) distro="Obarun" ;;
			ol|oracle*linux) distro="Oracle Linux" ;;
			openbsd) distro="OpenBSD" ;;
			*suse*) 
				distro="openSUSE"
				. lib/Linux/SUSE/suse/extra.sh
				;;
			os*elbrus) distro="OS Elbrus" ;;
			parabolagnu|parabolagnu/linux-libre|'parabola gnu/linux-libre'|parabola) distro="Parabola GNU/Linux-libre" ;;
			parrot|parrot*security) distro="Parrot Security" ;;
			pclinuxos|pclos) distro="PCLinuxOS" ;;
			peppermint) distro="Peppermint" ;;
			proxmox|proxmox*ve) distro="Proxmox VE" ;;
			pureos) distro="PureOS" ;;
			qubes) distro="Qubes OS" ;;
			raspbian) distro="Raspbian" ;;
			red*hat*|rhel) distro="Red Hat Enterprise Linux" ;;
			rosa) distro="ROSA" ;;
			sabayon) distro="Sabayon" ;;
			sailfish|sailfish*os)
				distro="SailfishOS"
				. lib/Linux/Independent/sailfish/extra.sh
				;;
			scientific*) distro="Scientific Linux" ;;
			siduction) distro="Siduction" ;;
			smgl|source*mage|source*mage*gnu*linux) distro="Source Mage GNU/Linux" ;;
			solus) distro="Solus" ;;
			sparky|sparky*linux) distro="SparkyLinux" ;;
			steam|steam*os) distro="SteamOS" ;;
			tinycore|tinycore*linux) distro="TinyCore" ;;
			trisquel) distro="Trisquel";;
			ubuntu) 
				distro="Ubuntu"
				. lib/Linux/Ubuntu/ubuntu/extra.sh
				;;
			void*linux) distro="Void Linux" ;;
			zorin*) distro="Zorin OS" ;;
			endeavour*) distro="EndeavourOS" ;;
		esac

		# shellcheck disable=SC2154
		case ${config_distro[short]} in
			on)
				:
				;;
			full)
				[ -n "${distro_release}" ] && distro="${distro} ${distro_release}"
				[ -n "${distro_release}" ] && distro="${distro} ${distro_codename}"
				;;
			version)
				[ -n "${distro_release}" ] && distro="${distro} ${distro_release}"
				;;
			codename)
				[ -n "${distro_codename}" ] && distro="${distro} ${distro_codename}"
				;;
			auto)
				# shellcheck disable=SC2154
				if [[ ${config_global[short]} =~ 'on' ]]; then
					:
				else
					[ -n "${distro_release}" ] && distro="${distro} ${distro_release}"
					[ -n "${distro_release}" ] && distro="${distro} ${distro_codename}"
				fi
				;;
		esac

		[[ ${config_distro[os_arch]} =~ 'on' ]] && distro="${distro} ${myKernel_machine}"
	fi

	verboseOut "Finding distribution...found as '${distro}'."
}

# Host and User detection - Begin
detect_userinfo () {
	# shellcheck disable=SC2154
	if [[ "${config_userinfo[display_user]}" =~ "on" ]]; then
		myUser=${USER}
		if [ -z "$USER" ]; then
			myUser=$(whoami)
		fi
		myUserInfo="${myUser}"
	fi

	# shellcheck disable=SC2154
	if [[ "${config_userinfo[display_hostname]}" =~ "on" ]]; then
		myHost="${HOSTNAME}"
		if [ "${distro}" == "Mac OS X" ] || [ "${distro}" == "macOS" ]; then
			myHost=${myHost/.local}
		fi
		if [ -n "${myUserInfo}" ]; then myUserInfo="${myUserInfo}@${myHost}"
		else myUserInfo="${myHost}"; fi
	fi
	verboseOut "Finding user info...found as '${myUserInfo}'."
}

detect_uptime () {
	# get seconds up since boot
	case ${myOS} in
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
    myUptime=${_days:+$_days, }${_hours:+$_hours, }$_mins
    myUptime=${myUptime%', '}
    myUptime=${myUptime:-$_seconds seconds}

	# shorthand
	# shellcheck disable=SC2154
	case ${config_uptime[short]} in
		on)
			myUptime=${myUptime/ minutes/ mins}
			myUptime=${myUptime/ minute/ min}
			myUptime=${myUptime/ seconds/ secs}
			;;
		tiny)
			myUptime=${myUptime/ days/d}
			myUptime=${myUptime/ day/d}
			myUptime=${myUptime/ hours/h}
			myUptime=${myUptime/ hour/h}
			myUptime=${myUptime/ minutes/m}
			myUptime=${myUptime/ minute/m}
			myUptime=${myUptime/ seconds/s}
			myUptime=${myUptime//,}
			;;
		off)
			:
			;;
		auto)
			# shellcheck disable=SC2154
			if [[ "${config_global[short]}" =~ 'on' ]]; then
				myUptime=${myUptime/ minutes/ mins}
				myUptime=${myUptime/ minute/ min}
				myUptime=${myUptime/ seconds/ secs}
			fi
			;;
	esac

	verboseOut "Finding current uptime...found as '${myUptime}'."
}

# Package Count - Begin
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
    _dir() { ((myPackages+=$#)); _pac "$(($#-pkgs_h))"; }
    _pac() { ((${1} > 0)) && { managers+=("${1} (${manager})"); manager_string+="${manager}, "; }; }
    _tot() {
		IFS=$'\n' read -d "" -ra pkgs <<< "$("$@" 2>/dev/null)";
		((myPackages+=${#pkgs[@]}));
		_pac "$((${#pkgs[@]}-pkgs_h))";
    }

    # Redefine _tot() for Bedrock Linux.
    [[ -f /bedrock/etc/bedrock-release && $PATH == */bedrock/cross/* ]] && {
        _tot() {
            IFS=$'\n' read -d "" -ra pkgs <<< "$(for s in $(brl list); do strat -r "$s" "$@"; done)"
            ((myPackages+="${#pkgs[@]}"))
			_pac "$((${#pkgs[@]}-pkgs_h))";
        }
        br_prefix="/bedrock/strata/*"
    }

	# get total packages based on OS value
	case $myOS in
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
			_has tazpkg			&& pkgs_h=6 _tot tazpkg list && ((myPackages-=6))
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
            _has kpm-pkg 		&& ((myPackages+=$(kpm  --get-selections | grep -cv deinstall$)))
			_has guix 			&& {
                manager=guix-system && _tot guix package -p "/run/current-system/profile" -I
                manager=guix-user   && _tot guix package -I
            }
            _has nix-store 		&& {
                nix-user-pkgs() {
                    nix-store -qR ~/.nix-profile
                    nix-store -qR /etc/profiles/per-user/"$USER"
                }
                manager=nix-system	&& _tot nix-store -qR /run/current-system/sw
                manager=nix-user	&& _tot nix-user-pkgs
                manager=nix-default && _tot nix-store -qR /nix/var/nix/profiles/default
            }

            # pkginfo is also the name of a python package manager which is painfully slow.
            # TODO: Fix this somehow. (neofetch)
            _has pkginfo && _tot pkginfo -i

			# BSD-like package detection
            case ${myKernel_name} in
                FreeBSD|DragonFly) _has pkg && _tot pkg info ;;
                *)
                    _has pkg && _dir /var/db/pkg/*
                    ((myPackages == 0)) && _has pkg && _tot pkg list
                ;;
            esac

			# list these last as they accompany regular package managers.
            _has flatpak && _tot flatpak list
            _has spm     && _tot spm list -i
            _has puyo    && _dir ~/.puyo/installed

            # Snap hangs if the command is run without the daemon running.
            # Only run snap if the daemon is also running.
            _has snap && pgrep -x snapd >/dev/null && \
				pkgs_h=1 _tot snap list && ((myPackages-=1))

            # This is the only standard location for appimages.
            # See: https://github.com/AppImage/AppImageKit/wiki
            manager=appimage && _has appimaged && _dir ~/.local/bin/*.appimage
			;;
		"Mac OS X"|"macOS")
            _has port  && pkgs_h=1 _tot port installed && ((myPackages-=1))
            _has brew  && _dir /usr/local/Cellar/*
            _has nix-store && {
                nix-user-pkgs() {
                    nix-store -qR ~/.nix-profile
                    nix-store -qR /etc/profiles/per-user/"$USER"
                }
                manager=nix-system && _tot nix-store -qR /run/current-system/sw
                manager=nix-user   && _tot nix-store -qR nix-user-pkgs
            }
			;;
        Windows)
            case ${myKernel_name} in
                CYGWIN*) _has cygcheck && _tot cygcheck -cd ;;
                MSYS*)   _has pacman   && _tot pacman -Qq --color never ;;
            esac

            # Scoop environment throws errors if `tot scoop list` is used
            _has scoop && pkgs_h=1 _dir ~/scoop/apps/* && ((myPackages-=1))

			# Count chocolatey packages.
			_has choco && _dir /c/ProgramData/chocolatey/lib/*
            [ -d /cygdrive/c/ProgramData/chocolatey/lib ] && \
				manager=choco _dir /cygdrive/c/ProgramData/chocolatey/lib/*
			;;
        Haiku)
            _has pkgman && _dir /boot/system/package-links/*
            myPackages=${myPackages/pkgman/depot}
			;;
	esac

	if ((myPackages == 0)); then
		unset myPackages
	else
		# shellcheck disable=SC2154
		case ${config_packages[managers]} in
			off)
				:
				;;
			split)
				printf -v myPackages '%s, ' "${managers[@]}"
				myPackages=${myPackages%,*}
				;;
			on)
				myPackages+=" (${manager_string%,*})"
				;;
		esac
		# replace pacman-key with pacman
		myPackages=${myPackages/pacman-key/pacman}
	fi

	verboseOut "Finding current package count...found as '${myPackages}'."
}

detect_shell () {
	# get configuration on whether full shell path should be displayed
	# shellcheck disable=SC2154
	case ${config_shell[path]} in
		on) shell_type="${SHELL}" ;;
		off) shell_type="${SHELL##*/}" ;;
	esac

	# if version_info is off, then return what we have now
	# shellcheck disable=SC2154
	[ "${config_shell[version]}" != "on" ] && myShell="${shell_type}" && return

	# get shell versions
	myShell="${shell_type} "
	case ${shell_name:=${SHELL##*/}} in
		bash)
			[[ ${BASH_VERSION} ]] || BASH_VERSION=$("${SHELL}" -c "printf %s \"\$BASH_VERSION\"")
			myShell+="${BASH_VERSION/-*}"
			;;
		sh|ash|dash|es) ;;
		*ksh)
			myShell+=$("${SHELL}" -c "printf %s \"\$KSH_VERSION\"")
			myShell=${myShell/ * KSH}
			myShell=${myShell/version}
			;;
		osh)
			if [[ ${OIL_VERSION} ]]; then
				myShell+=${OIL_VERSION}
			else
				myShell+=$("${SHELL}" -c "printf %s \"\$OIL_VERSION\"")
			fi
			;;
		tcsh)
			myShell+=$("${SHELL}" -c "printf %s \$tcsh")
			;;
		yash)
			myShell+=$("${SHELL}" --version 2>&1)
			myShell=${myShell/ ${shell_name}}
			myShell=${myShell/ Yet another shell}
			myShell=${myShell/Copyright*}
			;;
		fish)
			[[ "${FISH_VERSION}" ]] || FISH_VERSION=$("${SHELL}" -c "printf %s \"\$FISH_VERSION\"")
			myShell+="${FISH_VERSION}"
			;;
		*)
			myShell+=$("${SHELL}" --version 2>&1)
			myShell=${myShell/ ${shell_name}}
			;;
	esac

    # remove unwanted
    myShell=${myShell/, version}
    myShell=${myShell/xonsh\//xonsh }
    myShell=${myShell/options*}
    myShell=${myShell/\(*\)}

	verboseOut "Finding current shell...found as '${myShell}'."
}

detect_cpu () {
	case ${myOS} in
		"Mac OS X"|"macOS")
			myCPU="$(sysctl -n machdep.cpu.brand_string)"
			_cores=$(sysctl -n hw.logicalcpu_max)
			;;
		"Linux" | "Windows" )
			_file="/proc/cpuinfo"
			case ${myKernel_machine} in
                "frv" | "hppa" | "m68k" | "openrisc" | "or"* | "powerpc" | "ppc"* | "sparc"*)
                    myCPU="$(awk -F':' '/^cpu\t|^CPU/ {printf $2; exit}' "${_file}")"
					;;
                "s390"*)
                    myCPU="$(awk -F'=' '/machine/ {print $4; exit}' "${_file}")"
					;;	
                "ia64" | "m32r")
                    myCPU="$(awk -F':' '/model/ {print $2; exit}' "${_file}")"
                    [[ -z "$myCPU" ]] && myCPU="$(awk -F':' '/family/ {printf $2; exit}' "${_file}")"
					;;
                *)
                    myCPU="$(awk -F '\\s*: | @' \
                            '/model name|Hardware|Processor|^cpu model|chip type|^cpu type/ {
                            cpu=$2; if ($1 == "Hardware") exit } END { print cpu }' "${_file}")"
							;;
            esac

			_speed_dir="/sys/devices/system/cpu/cpu0/cpufreq"

			# Select the right temperature file.
			[[ -d /sys/class/hwmon/* ]] && \
				for temp_dir in /sys/class/hwmon/*; do
					[[ "$(< "${temp_dir}/name")" =~ (cpu_thermal|coretemp|fam15h_power|k10temp) ]] && {
						temp_dirs=("$temp_dir"/temp*_input)
						temp_dir=${temp_dirs[0]}
						break
					}
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
	esac

    # Remove un-needed patterns from cpu output.
    myCPU="${myCPU//(TM)}"
    myCPU="${myCPU//(tm)}"
    myCPU="${myCPU//(R)}"
    myCPU="${myCPU//(r)}"
	myCPU="${myCPU//?([+[:space:]])CPU}"
    myCPU="${myCPU//Processor}"
    myCPU="${myCPU//Dual-Core}"
    myCPU="${myCPU//Quad-Core}"
    myCPU="${myCPU//Six-Core}"
    myCPU="${myCPU//Eight-Core}"
    myCPU="${myCPU//[1-9][0-9]-Core}"
    myCPU="${myCPU//[0-9]-Core}"
    myCPU="${myCPU//, * Compute Cores}"
    myCPU="${myCPU//Core / }"
    myCPU="${myCPU//(\"AuthenticAMD\"*)}"
    myCPU="${myCPU//with Radeon * Graphics}"
    myCPU="${myCPU//, altivec supported}"
    myCPU="${myCPU//FPU*}"
    myCPU="${myCPU//Chip Revision*}"
    myCPU="${myCPU//Technologies, Inc}"
    myCPU="${myCPU//Core2/Core 2}"

    # Trim spaces from core and speed output
    _cores="${_cores//[[:space:]]}"
    _speed="${_speed//[[:space:]]}"

    # Remove CPU brand from the output.
    if [ "${config_cpu[brand]}" == "off" ]; then
        myCPU="${myCPU/AMD }"
        myCPU="${myCPU/Intel }"
        myCPU="${myCPU/Core? Duo }"
        myCPU="${myCPU/Qualcomm }"
    fi

    # Add CPU cores to the output.
    [[ "${config_cpu[cores]}" != "off" && "${_cores}" ]] && \
        case ${myOS} in
            "Mac OS X"|"macOS") myCPU="${myCPU/@/(${_cores}) @}" ;;
            *)                  myCPU="${myCPU} (${_cores})" ;;
        esac

    # Add CPU speed to the output.
    if [[ "${config_cpu[speed]}" != "off" && "${_speed}" ]]; then
        if (( _speed < 1000 )); then
            myCPU="${myCPU} @ ${_speed}MHz"
        else
            _speed="${_speed:0:1}.${_speed:1}"
            myCPU="${myCPU} @ ${_speed}GHz"
        fi
    fi

    # Add CPU temp to the output.
    if [[ "${config_cpu[temp]}" != "off" && "${_deg}" ]]; then
        _deg="${_deg//.}"

        # Convert to Fahrenheit if enabled
        [[ "${config_cpu[temp]}" == "F" ]] && _deg="$((_deg * 90 / 50 + 320))"

        # Format the output
        _deg="[${_deg/${_deg: -1}}.${_deg: -1}°${config_cpu[temp]:-C}]"
        myCPU="${myCPU} ${_deg}"
    fi

	verboseOut "Finding CPU...found as '${myCPU}'."
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
esac

while getopts ":hvVD:" flags; do
	case ${flags} in
		h) usage; exit 0 ;;
		V) versioninfo; exit 0 ;;
		v) declare config_global[verbose]="on" ;;
		D) distro="${OPTARG}" ;;
		:) errorOut "Error: You're missing an argument somewhere. Exiting."; exit 1 ;;
		?) errorOut "Error: Invalid flag somewhere. Exiting."; exit 1 ;;
		*) errorOut "Error"; exit 1 ;;
	esac
done

detect_kernel
detect_os
for i in userinfo distro uptime packages shell cpu; do
	_arr="config_${i}[display]"
	if [[ "${!_arr}" =~ "on" ]]; then eval detect_${i}; fi
done
echo "fetch! You are ${myUserInfo}!"
echo "fetch! You're on ${distro}."
echo "fetch! You're using ${myKernel} on ${myOS}."
echo "fetch! You've been up for ${myUptime}."
echo "fetch! Your current package count is: ${myPackages}."
echo "fetch! You're using ${myShell}."
echo "fetch! You're running on ${myCPU}."

((extglob_set)) && shopt -u extglob
