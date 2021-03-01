#!/usr/bin/env bash

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

verbosity="1"
verboseOut () {
	if [[ "${verbosity}" -eq "1" ]]; then
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

    printf '%s\n' "$strip"
}
trim() {
    set -f
    set -- $*
    printf '%s\n' "${*//[[:space:]]/}"
    set +f
}

fetchConfig () {
	while read line; do
		if [[ $line =~ ^\[[[:alnum:]]+\] ]]; then
			arrname="config_${line//[^[:alnum:]]/}"
			declare -gA $arrname
		elif [[ $line =~ ^([_[:alpha:]][_[:alnum:]]*)"="(.*) ]]; then
			declare -g ${arrname}[${BASH_REMATCH[1]}]="${BASH_REMATCH[2]//\"}"
			#printf "\${${arrname}[${BASH_REMATCH[1]}]}  : %s\n" "${BASH_REMATCH[2]}"
		fi
	done < "${1}"
}

getColor () {
	local tmp_color=""
	if [[ -n "$1" ]]; then
		if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
			if [[ ${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -gt 1 ]] || [[ ${BASH_VERSINFO[0]} -gt 4 ]]; then
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
			(?([1])?([0-9])[0-9])		color_ret="$(colorize ${tmp_color})";;
			(?([2])?([0-4])[0-9])		color_ret="$(colorize ${tmp_color})";;
			(?([2])?([5])[0-6])			color_ret="$(colorize ${tmp_color})";;
			*)							errorOut "That color will not work"; exit 1;;
		esac

		[[ -n "${color_ret}" ]] && printf "${color_ret}"
	fi
}

detect_kernel () {
    IFS=" " read -ra kernel <<< "$(uname -srm)"
    myKernel_name="${kernel[0]}"
    myKernel_version="${kernel[1]}"
    myKernel_machine="${kernel[2]}"

	# pulled from neofetch source
    if [[ "$myKernel_name" == "Darwin" ]]; then
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
	verboseOut "Finding kernel...found as '${myKernel_name} ${myKernel_version} ${myKernel_machine}'"
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
	verboseOut "Finding OS...found as '${myOS}'"
}

# Distro Detection - Begin
detect_distro () {
	if [[ -z "${distro}" ]]; then
		local distro_detect=""
		distro="Unknown"
		if [[ "${myOS}" == "Linux" && "${distro}" == "Unknown" ]]; then
			# LSB Release Check
			if type -p lsb_release >/dev/null 2>&1; then
				distro_detect="$(lsb_release -si)"
				distro_release="$(lsb_release -sr)"
				distro_codename="$(lsb_release -sc)"
				case "${distro_detect}" in
					"archlinux"|"Arch Linux"|"arch"|"Arch"|"archarm")
						distro="Arch Linux"
						distro_release="n/a"
						if [ -f /etc/os-release ]; then
							os_release="/etc/os-release";
						elif [ -f /usr/lib/os-release ]; then
							os_release="/usr/lib/os-release";
						fi
						;;
					"ALDOS"|"Aldos")
						distro="ALDOS"
						;;
					"ArcoLinux")
						distro="ArcoLinux"
						distro_release="n/a"
						;;
					"artixlinux"|"Artix Linux"|"artix"|"Artix"|"Artix release")
						distro="Artix"
						;;
					"blackPantherOS"|"blackPanther"|"blackpanther"|"blackpantheros")
						distro=$(source /etc/lsb-release; echo "$DISTRIB_ID")
						distro_release=$(source /etc/lsb-release; echo "$DISTRIB_RELEASE")
						distro_codename=$(source /etc/lsb-release; echo "$DISTRIB_CODENAME")
						;;
					"Chakra")
						distro="Chakra"
						distro_release=""
						;;
					"CentOSStream")
						distro="CentOS Stream"
						;;
					"BunsenLabs")
						distro=$(source /etc/lsb-release; echo "$DISTRIB_ID")
						distro_release=$(source /etc/lsb-release; echo "$DISTRIB_RELEASE")
						distro_codename=$(source /etc/lsb-release; echo "$DISTRIB_CODENAME")
						;;
					"Debian")
						if [[ -f /etc/siduction-version ]]; then
							distro="Siduction"
							distro_release="(Debian Sid)"
							distro_codename=""
						elif [[ -f /usr/bin/pveversion ]]; then
							distro="Proxmox VE"
							distro_codename="n/a"
							distro_release="$(/usr/bin/pveversion | grep -oP 'pve-manager\/\K\d+\.\d+')"
						elif [[ -f /etc/os-release ]]; then
							if grep -q -i 'Raspbian' /etc/os-release ; then
								distro="Raspbian"
								distro_release=$(awk -F'=' '/^PRETTY_NAME=/ {print $2}' /etc/os-release)
							elif grep -q -i 'BlankOn' /etc/os-release ; then
								distro='BlankOn'
								distro_release=$(awk -F'=' '/^PRETTY_NAME=/ {print $2}' /etc/os-release)
							else
								distro="Debian"
							fi
						else
							distro="Debian"
						fi
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
						distro_codename=null
						distro_release=null
						;;
					"Gentoo")
						if [[ "$(lsb_release -sd)" =~ "Funtoo" ]]; then
							distro="Funtoo"
						else
							distro="Gentoo"
						fi
						#detecting release stable/testing/experimental
						if [[ -f /etc/portage/make.conf ]]; then
							source /etc/portage/make.conf
						elif [[ -d /etc/portage/make.conf ]]; then
							source /etc/portage/make.conf/*
						fi
						case $ACCEPT_KEYWORDS in
							[a-z]*) distro_release=stable       ;;
							~*)     distro_release=testing      ;;
							'**')   distro_release=experimental ;; #experimental usually includes git-versions.
						esac
						;;
					"Hyperbola GNU/Linux-libre"|"Hyperbola")
						distro="Hyperbola GNU/Linux-libre"
						distro_codename="n/a"
						distro_release="n/a"
						;;
					"Kali"|"Debian Kali Linux")
						distro="Kali Linux"
						if [[ "${distro_codename}" =~ "kali-rolling" ]]; then
							distro_codename="n/a"
							distro_release="n/a"
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
						distro_codename="n/a"
						distro_release="n/a"
						if [[ -f /etc/issue ]]; then
							if grep -q '^KDE neon' /etc/issue ; then
								distro_release="$(grep '^KDE neon' /etc/issue | cut -d ' ' -f3)"
							fi
						fi
						;;
					"Ol"|"ol"|"Oracle Linux")
						distro="Oracle Linux"
						[ -f /etc/oracle-release ] && distro_release="$(sed 's/Oracle Linux //' /etc/oracle-release)"
						;;
					"LinuxMint")
						distro="Mint"
						if [[ "${distro_codename}" == "debian" ]]; then
							distro="LMDE"
							distro_codename="n/a"
							distro_release="n/a"
						#adding support for LMDE 3	
						elif [[ $(lsb_release -sd) =~ "LMDE" ]]; then
							distro="LMDE"	
						fi
						;;
					"openSUSE"|"openSUSE project"|"SUSE LINUX"|"SUSE"|*SUSELinuxEnterprise*)
						distro="openSUSE"
						if [ -f /etc/os-release ]; then
							if grep -q -i 'SUSE Linux Enterprise' /etc/os-release ; then
								distro="SUSE Linux Enterprise"
								distro_codename="n/a"
								distro_release=$(awk -F'=' '/^VERSION_ID=/ {print $2}' /etc/os-release | tr -d '"')
							fi
						fi
						if [[ "${distro_codename}" == "Tumbleweed" ]]; then
							distro_release="n/a"
						fi
						;;
					"Parabola GNU/Linux-libre"|"Parabola")
						distro="Parabola GNU/Linux-libre"
						distro_codename="n/a"
						distro_release="n/a"
						;;
					"Parrot"|"Parrot Security")
						distro="Parrot Security"
						;;
					"PCLinuxOS")
						distro="PCLinuxOS"
						distro_codename="n/a"
						distro_release="n/a"
						;;
					"Peppermint")
						distro="Peppermint"
						distro_codename=null
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
						if [[ -f /etc/os-release ]]; then
							distro_codename="$(grep 'VERSION=' /etc/os-release | cut -d '(' -f2 | cut -d ')' -f1)"
							distro_release="$(awk -F'=' '/^VERSION=/ {print $2}' /etc/os-release)"
						fi
						;;
					"Sparky"|"SparkyLinux")
						distro="SparkyLinux"
						;;
					"Ubuntu")
						distro="Ubuntu"
						;;
					"Void"|"VoidLinux")
						distro="Void Linux"
						distro_codename=""
						distro_release=""
						;;
					"Zorin")
						distro="Zorin OS"
						distro_codename=""
						;;
				esac
			fi

			# Existing File Check
			if [ "$distro" == "Unknown" ]; then
				if [[ -e "/etc/mcst_version" ]]; then
					distro="OS Elbrus"
					distro_release="$(tail -n 1 /etc/mcst_version)"
					if [[ -n ${distro_release} ]]; then
						distro_more="$distro_release"
					fi
				fi
				if [ "$(uname -o 2>/dev/null)" ]; then
					myOS="$(uname -o)"
					case "$os" in
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
				if [[ "${distro}" == "Unknown" ]]; then
					if [ -f /etc/os-release ]; then
						os_release="/etc/os-release";
					elif [ -f /usr/lib/os-release ]; then
						os_release="/usr/lib/os-release";
					fi
					if [[ -n ${os_release} ]]; then
						distrib_id=$(<${os_release});
						for l in $distrib_id; do
							if [[ ${l} =~ ^ID= ]]; then
								distrib_id=${l//*=}
								distrib_id=${distrib_id//\"/}
								break 1
							fi
						done
						if [[ -n ${distrib_id} ]]; then
							if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
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
						[[ "${distro}" == "Opensuse-tumbleweed" ]] && distro="openSUSE" && distro_more="Tumbleweed"
						[[ "${distro}" == "Opensuse-leap" ]] && distro="openSUSE"
						[[ "${distro}" == "void" ]] && distro="Void Linux"
						[[ "${distro}" == "evolveos" ]] && distro="Evolve OS"
						[[ "${distro}" == "Sulin" ]] && distro="Sulin"
						[[ "${distro}" == "Arch" || "${distro}" == "Archarm" || "${distro}" == "archarm" ]] && distro="Arch Linux"
						[[ "${distro}" == "elementary" ]] && distro="elementary OS"
						[[ "${distro}" == "Fedora" && -d /etc/qubes-rpc ]] && distro="qubes" # Inner VM
						[[ "${distro}" == "Ol" || "${distro}" == "ol" ]] && distro="Oracle Linux"
						if [[ "${distro}" == "Oracle Linux" && -f /etc/oracle-release ]]; then
							distro_more="$(sed 's/Oracle Linux //' /etc/oracle-release)"
						fi
						# Upstream problem, SL and so EL is using rhel ID in os-release
						if [[ "${distro}" == "rhel" ]] || [[ "${distro}" == "Rhel" ]]; then
							distro="Red Hat Enterprise Linux"
							if grep -q 'Scientific' /etc/os-release; then
								distro="Scientific Linux"
							elif grep -q 'EuroLinux' /etc/os-release; then
								distro="EuroLinux"
							fi
						fi	

						[[ "${distro}" == "Neon" ]] && distro="KDE neon"
						[[ "${distro}" == "SLED" || "${distro}" == "sled" || "${distro}" == "SLES" || "${distro}" == "sles" ]] && distro="SUSE Linux Enterprise"
						if [[ "${distro}" == "SUSE Linux Enterprise" && -f /etc/os-release ]]; then
							distro_more="$(awk -F'=' '/^VERSION_ID=/ {print $2}' /etc/os-release | tr -d '"')"
						fi
						if [[ "${distro}" == "Debian" && -f /usr/bin/pveversion ]]; then
							distro="Proxmox VE"
							distro_codename="n/a"
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

				if [[ "${distro}" == "Unknown" ]] && [[ "${OSTYPE}" =~ "linux" || "${OSTYPE}" == "gnu" ]]; then
					for di in arch chakra evolveos exherbo fedora \
								frugalware gentoo kogaion mageia obarun oracle \
								pardus pclinuxos redhat rosa SuSe; do
						if [ -f /etc/$di-release ]; then
							distro=$di
							break
						fi
					done
					if [[ "${distro}" == "oracle" ]]; then
						distro_more="$(sed 's/Oracle Linux //' /etc/oracle-release)"
					elif [[ "${distro}" == "SuSe" ]]; then
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
					elif [[ "${distro}" == "redhat" ]]; then
						grep -q -i 'CentOS' /etc/redhat-release && distro="CentOS"
						grep -q -i 'Scientific' /etc/redhat-release && distro="Scientific Linux"
						grep -q -i 'EuroLinux' /etc/redhat-release && distro="EuroLinux"
						grep -q -i 'PCLinuxOS' /etc/redhat-release && distro="PCLinuxOS"
					fi
				fi

				if [[ "${distro}" == "Unknown" ]]; then
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

				if [[ "${distro}" == "Unknown" ]] && [[ "${OSTYPE}" =~ "linux" || "${OSTYPE}" == "gnu" ]]; then
					if [[ -f /etc/issue ]]; then
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

				if [[ "${distro}" == "Unknown" ]] && [[ "${OSTYPE}" =~ "linux" || "${OSTYPE}" == "gnu" ]]; then
					if [[ -f /etc/system-release ]]; then
						if grep -q -i 'Scientific Linux' /etc/system-release; then
							distro="Scientific Linux"
						elif grep -q -i 'Oracle Linux' /etc/system-release; then
							distro="Oracle Linux"
						fi
					elif [[ -f /etc/lsb-release ]]; then
						if grep -q -i 'CHROMEOS_RELEASE_NAME' /etc/lsb-release; then
							distro="$(awk -F'=' '/^CHROMEOS_RELEASE_NAME=/ {print $2}' /etc/lsb-release)"
							distro_more="$(awk -F'=' '/^CHROMEOS_RELEASE_VERSION=/ {print $2}' /etc/lsb-release)"
						fi
					fi
				fi
			fi
		elif [[ "${myOS}" == "Windows" ]]; then
			distro=$(wmic os get Caption)
			distro=${distro/Caption}
			distro=$(trim ${distro/Microsoft })
			[[ $distro =~ [[:space:]](.*) ]] && distro=${BASH_REMATCH[1]}
			if grep -q -i 'Microsoft' /proc/version 2>/dev/null || \
				grep -q -i 'Microsoft' /proc/sys/kernel/osrelease 2>/dev/null
			then
				wsl="(on the Windows Subsystem for Linux)"
			fi
		elif [[ "${myOS}" =~ "[Mm]ac" ]]; then
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
			debian) distro="Debian" ;;
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
			gentoo) distro="Gentoo" ;;
			gnewsense) distro="gNewSense" ;;
			guix*system) distro="Guix System" ;;
			haiku) distro="Haiku" ;;
			hyperbolagnu|hyperbolagnu/linux-libre|'hyperbola gnu/linux-libre'|hyperbola) distro="Hyperbola GNU/Linux-libre" ;;
			kali*linux) distro="Kali Linux" ;;
			kaos) distro="KaOS";;
			kde*neon|neon) distro="KDE neon" ;;
			kogaion) distro="Kogaion" ;;
			lmde) distro="LMDE" ;;
			lunar|lunar*linux) distro="Lunar Linux";;
			mac*os*x|os*x) distro="Mac OS X" ;;
			macos) distro="macOS" ;;
			manjaro) distro="Manjaro" ;;
			mageia) distro="Mageia" ;;
			mer) distro="Mer" ;;
			mint|linux*mint) distro="Mint" ;;
			netbsd) distro="NetBSD" ;;
			netrunner) distro="Netrunner" ;;
			nix|nix*os) distro="NixOS" ;;
			obarun) distro="Obarun" ;;
			ol|oracle*linux) distro="Oracle Linux" ;;
			openbsd) distro="OpenBSD" ;;
			opensuse) distro="openSUSE" ;;
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
			sailfish|sailfish*os) distro="SailfishOS" ;;
			scientific*) distro="Scientific Linux" ;;
			siduction) distro="Siduction" ;;
			smgl|source*mage|source*mage*gnu*linux) distro="Source Mage GNU/Linux" ;;
			solus) distro="Solus" ;;
			sparky|sparky*linux) distro="SparkyLinux" ;;
			steam|steam*os) distro="SteamOS" ;;
			suse*linux*enterprise) distro="SUSE Linux Enterprise" ;;
			tinycore|tinycore*linux) distro="TinyCore" ;;
			trisquel) distro="Trisquel";;
			ubuntu) . lib/Linux/Ubuntu/ubuntu/extra.sh; distro="Ubuntu";;
			void*linux) distro="Void Linux" ;;
			zorin*) distro="Zorin OS" ;;
			endeavour*) distro="EndeavourOS" ;;
		esac

		case ${config_distro[short]} in
			on)
				distro="${distro}"
				;;
			full)
				[[ -n ${distro_release} ]] && distro="${distro} ${distro_release}"
				[[ -n ${distro_release} ]] && distro="${distro} ${distro_codename}"
				;;
			version)
				[[ -n ${distro_release} ]] && distro="${distro} ${distro_release}"
				;;
			codename)
				[[ -n ${distro_codename} ]] && distro="${distro} ${distro_codename}"
				;;
			auto)
				if [[ ${config_global[short]} == 'on' ]]; then
					distro="${distro}"
				else
					[[ -n ${distro_release} ]] && distro="${distro} ${distro_release}"
					[[ -n ${distro_release} ]] && distro="${distro} ${distro_codename}"
				fi
				;;
		esac
	fi

	verboseOut "Finding distribution...found as '${distro}'"
}

# Host and User detection - Begin
detect_userinfo () {
	if [[ "${config_userinfo[display_user]}" =~ "on" ]]; then
		myUser=${USER}
		if [[ -z "$USER" ]]; then
			myUser=$(whoami)
		fi
		myUserInfo="${myUser}"
	fi

	if [[ "${config_userinfo[display_hostname]}" =~ "on" ]]; then
		myHost="${HOSTNAME}"
		if [[ "${distro}" == "Mac OS X" || "${distro}" == "macOS" ]]; then
			myHost=${myHost/.local}
		fi
		if [[ -n ${myUserInfo} ]]; then myUserInfo="${myUserInfo}@${myHost}"
		else myUserInfo="${myHost}"; fi
	fi
	verboseOut "Finding user info...found as '${myUserInfo}'"
}

detect_uptime () {
	# get seconds up since boot
	case $myOS in
		"Mac OS X"|"macOS"|BSD)
			boot=$(sysctl -n kern.boottime)
			[[ ${boot} =~ [0-9]+ ]] && boot=${BASH_REMATCH[0]}
			now=$(date +%s)
			_seconds=$((now-boot))
			;;
		Linux|Windows|[G|g][N|n][U|u])
			if [[ -f /proc/uptime ]]; then
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
			if [ ${config_global[short]} == 'on' ]; then
				myUptime=${myUptime/ minutes/ mins}
				myUptime=${myUptime/ minute/ min}
				myUptime=${myUptime/ seconds/ secs}
			fi
			;;
	esac

	verboseOut "Finding current uptime...found as '${myUptime}'"
}

# Execution flag detection
case $1 in
	--help) displayHelp; exit 0;;
	--version) displayVersion; exit 0;;
esac
while getopts ":hD:F:" flags; do
	case $flags in
		h) displayHelp; exit 0 ;;
		D) distro="${OPTARG}" ;;
		F) FETCH_CONFIG="${OPTARG}" ;;
		:) errorOut "Error: You're missing an argument somewhere. Exiting."; exit 1 ;;
		?) errorOut "Error: Invalid flag somewhere. Exiting."; exit 1 ;;
		*) errorOut "Error"; exit 1 ;;
	esac
done

[[ -z $FETCH_CONFIG ]] && FETCH_CONFIG="${FETCH_DATA_USER_DIR}/${FETCH_CONFIG_FILENAME}"
fetchConfig "${FETCH_CONFIG}"

detect_kernel
detect_os
for i in userinfo distro uptime; do
	_arr="config_${i}[display]"
	if [[ "${!_arr}" =~ "on" ]]; then eval detect_${i}; fi
done
echo "fetch! You are ${myUserInfo}!"
echo "fetch! You're on ${distro}."
echo "fetch! You're using ${myKernel_name}."
echo "fetch! You've been up for ${myUptime}."

((extglob_set)) && shopt -u extglob
