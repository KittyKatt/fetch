# shellcheck shell=bash
# shellcheck disable=SC2154
detect_distro() {
  [[ "${my_distro}" ]] && return

  local distro_detect=
  my_distro="Unknown"
  if [ "${my_os}" == "Linux" ] && [ "${my_distro}" == "Unknown" ]; then
    # LSB Release Check
    if type -p lsb_release > /dev/null 2>&1; then
      distro_detect="$(lsb_release -si)"
      distro_release="$(lsb_release -sr)"
      distro_codename="$(lsb_release -sc)"
      case ${distro_detect} in
        "archlinux" | "Arch Linux" | "arch" | "Arch" | "archarm")
          my_distro="Arch Linux"
          unset distro_release
          ;;
        "ALDOS" | "Aldos")
          my_distro="ALDOS"
          ;;
        "ArcoLinux")
          my_distro="ArcoLinux"
          unset distro_release
          ;;
        "artixlinux" | "Artix Linux" | "artix" | "Artix" | "Artix release")
          my_distro="Artix"
          ;;
        "blackPantherOS" | "blackPanther" | "blackpanther" | "blackpantheros")
          # shellcheck disable=SC2034,SC1091,SC2153
          {
            my_distro=$(
              source /etc/lsb-release
              printf '%s' "${DISTRIB_ID}"
            )
            distro_release=$(
              source /etc/lsb-release
              printf '%s' "${DISTRIB_RELEASE}"
            )
            distro_codename=$(
              source /etc/lsb-release
              printf '%s' "${DISTRIB_CODENAME}"
            )
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
            my_distro=$(
              source /etc/lsb-release
              printf '%s' "${DISTRIB_ID}"
            )
            distro_release=$(
              source /etc/lsb-release
              printf '%s' "${DISTRIB_RELEASE}"
            )
            distro_codename=$(
              source /etc/lsb-release
              printf '%s' "${DISTRIB_CODENAME}"
            )
          }
          ;;
        "Debian")
          my_distro="Debian"
          ;;
        "Deepin")
          my_distro="Deepin"
          ;;
        "elementary" | "elementary OS")
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
        "KaOS" | "kaos")
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
        "Hyperbola GNU/Linux-libre" | "Hyperbola")
          my_distro="Hyperbola GNU/Linux-libre"
          unset distro_codename
          unset distro_release
          ;;
        "Kali" | "Debian Kali Linux")
          my_distro="Kali Linux"
          if [[ ${distro_codename} =~ "kali-rolling" ]]; then
            unset distro_codename
            unset distro_release
          fi
          ;;
        "Lunar Linux" | "lunar")
          my_distro="Lunar Linux"
          ;;
        "ManjaroLinux")
          my_distro="Manjaro"
          ;;
        "neon" | "KDE neon")
          my_distro="KDE neon"
          unset distro_codename
          unset distro_release
          ;;
        "Ol" | "ol" | "Oracle Linux")
          my_distro="Oracle Linux"
          [ -f /etc/oracle-release ] && distro_release="$(sed 's/Oracle Linux //' /etc/oracle-release)"
          ;;
        "LinuxMint")
          my_distro="Mint"
          ;;
        "openSUSE" | "openSUSE project" | "SUSE LINUX" | "SUSE" | *SUSELinuxEnterprise*)
          my_distro="openSUSE"
          ;;
        "Parabola GNU/Linux-libre" | "Parabola")
          my_distro="Parabola GNU/Linux-libre"
          unset distro_codename
          unset distro_release
          ;;
        "Parrot" | "Parrot Security")
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
        "rhel" | *RedHatEnterprise*)
          my_distro="Red Hat Enterprise Linux"
          ;;
        "RosaDesktopFresh")
          my_distro="ROSA"
          distro_release=$(grep 'VERSION=' /etc/os-release | cut -d ' ' -f3 | cut -d '"' -f1)
          distro_codename=$(grep 'PRETTY_NAME=' /etc/os-release | cut -d ' ' -f4,4)
          ;;
        "SailfishOS")
          my_distro="SailfishOS"
          ;;
        "Sparky" | "SparkyLinux")
          my_distro="SparkyLinux"
          ;;
        "Ubuntu")
          my_distro="Ubuntu"
          ;;
        "Void" | "VoidLinux")
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
    # TODO: Lots of optimization with these if statements to do
    if [ "${my_distro}" == "Unknown" ]; then
      if [ -f "/etc/mcst_version" ]; then
        my_distro="OS Elbrus"
        distro_release="$(tail -n 1 /etc/mcst_version)"
        if [ -n "${distro_release}" ]; then
          distro_more="${distro_release}"
        fi
      fi
      if [ -n "$(uname -o 2> /dev/null)" ]; then
        os="$(uname -o)"
        case ${os} in
          "EndeavourOS") my_distro="EndeavourOS" ;;
          "GNU/Linux")
            if type -p crux > /dev/null 2>&1; then
              my_distro="CRUX"
              distro_more="$(crux | awk '{print $3}')"
            fi
            if type -p nixos-version > /dev/null 2>&1; then
              my_distro="NixOS"
              distro_more="$(nixos-version)"
            fi
            if type -p sorcery > /dev/null 2>&1; then
              my_distro="SMGL"
            fi
            if (type -p guix && type -p herd) > /dev/null 2>&1; then
              my_distro="Guix System"
            fi
            ;;
          *) return ;;
        esac
      fi

      if [ "${my_distro}" == "Unknown" ]; then
        if [ -f /etc/os-release ]; then
          os_release="/etc/os-release"
        elif [ -f /usr/lib/os-release ]; then
          os_release="/usr/lib/os-release"
        fi
        if [ -n "${os_release}" ]; then
          # shellcheck disable=SC2248
          distrib_id="$(< ${os_release})"
          for l in ${distrib_id}; do
            if [[ ${l} =~ ^ID= ]]; then
              distrib_id=${l//*=/}
              distrib_id=${distrib_id//\"/}
              break 1
            fi
          done
          if [ -n "${distrib_id}" ]; then
            if [ "${BASH_VERSINFO[0]}" -ge 4 ]; then
              distrib_id=$(for d in ${distrib_id}; do printf '%s' "${d^} "; done)
              my_distro=${distrib_id% }
              unset distrib_id
            else
              distrib_id=$(
                for d in ${distrib_id}; do
                  FIRST_LETTER=$(printf '%s' "${d:0:1}" | tr "[:lower:]" "[:upper:]")
                  printf '%s' "${FIRST_LETTER}${d:1} "
                done
              )
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
          [[ ${my_distro} == "Arch" || ${my_distro} == "Archarm" || ${my_distro} == "archarm" ]] && my_distro="Arch Linux"
          [ "${my_distro}" == "elementary" ] && my_distro="elementary OS"
          [[ ${my_distro} == "Fedora" && -d /etc/qubes-rpc ]] && my_distro="qubes" # Inner VM
          [[ ${my_distro} == "Ol" || ${my_distro} == "ol" ]] && my_distro="Oracle Linux"
          if [[ ${my_distro} == "Oracle Linux" && -f /etc/oracle-release ]]; then
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
          [[ ${my_distro} == "SLED" || ${my_distro} == "sled" || ${my_distro} == "SLES" || ${my_distro} == "sles" ]] && my_distro="SUSE Linux Enterprise"
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

      if [[ ${my_distro} == "Unknown" && ${OSTYPE} =~ "linux" && -f /etc/lsb-release ]]; then
        LSB_RELEASE=$(< /etc/lsb-release)
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

      if [ "${my_distro}" == "Unknown" ] && [[ ${OSTYPE} =~ "linux" || ${OSTYPE} == "gnu" ]]; then
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
            if grep -q -i 'SUSE Linux Enterprise' /etc/os-release; then
              my_distro="SUSE Linux Enterprise"
              distro_more=$(awk -F'=' '/^VERSION_ID=/ {print $2}' /etc/os-release | tr -d '"')
            fi
          fi
          if [[ ${distro_more} =~ "Tumbleweed" ]]; then
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
        if [[ ${OSTYPE} =~ "linux" || ${OSTYPE} == "gnu" ]]; then
          if [ -f /etc/debian_version ]; then
            if [ -f /etc/issue ]; then
              if grep -q -i 'gNewSense' /etc/issue; then
                my_distro="gNewSense"
              elif grep -q -i 'KDE neon' /etc/issue; then
                my_distro="KDE neon"
                distro_more="$(cut -d ' ' -f3 /etc/issue)"
              else
                my_distro="Debian"
              fi
            fi
            if grep -q -i 'Kali' /etc/debian_version; then
              my_distro="Kali Linux"
            fi
          elif [ -f /etc/NIXOS ]; then
            my_distro="NixOS"
          elif [ -f /etc/dragora-version ]; then
            my_distro="Dragora"
            distro_more="$(cut -d, -f1 /etc/dragora-version)"
          elif [ -f /etc/slackware-version ]; then
            my_distro="Slackware"
          elif [ -f /usr/share/doc/tc/release.txt ]; then
            my_distro="TinyCore"
            distro_more="$(cat /usr/share/doc/tc/release.txt)"
          elif [ -f /etc/sabayon-edition ]; then
            my_distro="Sabayon"
          fi
        fi
      fi

      if [ "${my_distro}" == "Unknown" ] && [[ ${OSTYPE} =~ "linux" || ${OSTYPE} == "gnu" ]]; then
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

      if [ "${my_distro}" == "Unknown" ] && [[ ${OSTYPE} =~ "linux" || ${OSTYPE} == "gnu" ]]; then
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
    my_distro=${my_distro/Caption/}
    my_distro=$(trim "${my_distro/Microsoft /}")
    my_distro=${my_distro%%+([[:space:]])}
    [[ ${my_distro} =~ [[:space:]](.*) ]] && my_distro=${BASH_REMATCH[1]}
  elif [[ ${my_os} =~ [Mm]ac ]]; then
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

  # shellcheck disable=SC1090,SC2034
  {
    case ${my_distro,,} in
      aldos) my_distro="ALDOS" ;;
      alpine) my_distro="Alpine Linux" ;;
      amzn | amazon | amazon*linux) my_distro="Amazon Linux" ;;
      arch | arch*linux) my_distro="Arch Linux" ;;
      arch32)
        my_distro="Arch Linux 32"
        [ -z "${ascii_distro}" ] && ascii_distro="Arch Linux"
        ;;
      arcolinux | arcolinux*) my_distro="ArcoLinux" ;;
      artix | artix*linux) my_distro="Artix Linux" ;;
      blackpantheros | black*panther*) my_distro="blackPanther OS" ;;
      bunsenlabs) my_distro="BunsenLabs" ;;
      centos) my_distro="CentOS" ;;
      centos*stream)
        my_distro="CentOS Stream"
        [ -z "${ascii_distro}" ] && ascii_distro="CentOS"
        ;;
      chakra) my_distro="Chakra" ;;
      chrome* | chromium*) my_distro="Chrome OS" ;;
      crux) my_distro="CRUX" ;;
      debian)
        my_distro="Debian"
        . "${FETCH_DATA_DIR}/lib/distro/debian/lib.sh"
        ;;
      devuan) my_distro="Devuan" ;;
      deepin) my_distro="Deepin" ;;
      dragonflybsd) my_distro="DragonFlyBSD" ;;
      dragora) my_distro="Dragora" ;;
      drauger*) my_distro="DraugerOS" ;;
      elementary | 'elementary os') my_distro="elementary OS" ;;
      endeavour*) my_distro="EndeavourOS" ;;
      eurolinux) my_distro="EuroLinux" ;;
      evolveos) my_distro="Evolve OS" ;;
      exherbo | exherbo*linux) my_distro="Exherbo" ;;
      fedora)
        my_distro="Fedora"
        . "${FETCH_DATA_DIR}/lib/distro/fedora/lib.sh"
        ;;
      freebsd) my_distro="FreeBSD" ;;
      frugalware) my_distro="Frugalware" ;;
      funtoo) my_distro="Funtoo" ;;
      gentoo)
        my_distro="Gentoo"
        . "${FETCH_DATA_DIR}/lib/distro/gentoo/lib.sh"
        ;;
      gnewsense) my_distro="gNewSense" ;;
      guix*system) my_distro="Guix System" ;;
      haiku) my_distro="Haiku" ;;
      hyperbolagnu | hyperbolagnu/linux-libre | 'hyperbola gnu/linux-libre' | hyperbola)
        my_distro="Hyperbola GNU/Linux-libre"
        [ -z "${ascii_distro}" ] && ascii_distro="Hyperbola"
        ;;
      kali*linux) my_distro="Kali Linux" ;;
      kaos) my_distro="KaOS" ;;
      kde*neon | neon)
        my_distro="KDE neon"
        . "${FETCH_DATA_DIR}/lib/distro/kde-neon/lib.sh"
        ;;
      kogaion) my_distro="Kogaion" ;;
      lmde) my_distro="LMDE" ;;
      lunar | lunar*linux) my_distro="Lunar Linux" ;;
      *"macos"* | *"mac os x"*)
        [ -z "${ascii_distro}" ] && ascii_distro="macOS"
        ;;
      manjaro) my_distro="Manjaro" ;;
      mageia) my_distro="Mageia" ;;
      mer) my_distro="Mer" ;;
      mint | linux*mint)
        my_distro="Mint"
        . "${FETCH_DATA_DIR}/lib/distro/mint/lib.sh"
        ;;
      netbsd) my_distro="NetBSD" ;;
      netrunner) my_distro="Netrunner" ;;
      nix | nix*os) my_distro="NixOS" ;;
      obarun) my_distro="Obarun" ;;
      ol | oracle*linux) my_distro="Oracle Linux" ;;
      openbsd) my_distro="OpenBSD" ;;
      os*elbrus) my_distro="OS Elbrus" ;;
      parabolagnu | parabolagnu/linux-libre | 'parabola gnu/linux-libre' | parabola)
        my_distro="Parabola GNU/Linux-libre"
        [ -z "${ascii_distro}" ] && ascii_distro="Parabola"
        ;;
      parrot | parrot*security) my_distro="Parrot Security" ;;
      pclinuxos | pclos) my_distro="PCLinuxOS" ;;
      peppermint) my_distro="Peppermint" ;;
      proxmox | proxmox*ve) my_distro="Proxmox VE" ;;
      pureos) my_distro="PureOS" ;;
      qubes) my_distro="Qubes OS" ;;
      raspbian) my_distro="Raspbian" ;;
      red*hat* | rhel)
        my_distro="Red Hat Enterprise Linux"
        [ -z "${ascii_distro}" ] && ascii_distro="RHEL"
        ;;
      rosa) my_distro="ROSA" ;;
      sabayon) my_distro="Sabayon" ;;
      sailfish | sailfish*os)
        my_distro="SailfishOS"
        . "${FETCH_DATA_DIR}/lib/distro/sailfish/lib.sh"
        ;;
      scientific*) my_distro="Scientific Linux" ;;
      siduction) my_distro="Siduction" ;;
      smgl | source*mage | source*mage*gnu*linux)
        my_distro="Source Mage GNU/Linux"
        [ -z "${ascii_distro}" ] && ascii_distro="SourceMage"
        ;;
      solus) my_distro="Solus" ;;
      sparky | sparky*linux) my_distro="SparkyLinux" ;;
      steam | steam*os) my_distro="SteamOS" ;;
      sulin) my_distro="Sulin" ;;
      *suse*)
        my_distro="openSUSE"
        . "${FETCH_DATA_DIR}/lib/distro/suse/lib.sh"
        [ -z "${ascii_distro}" ] && ascii_distro="SUSE"
        ;;
      tinycore | tinycore*linux) my_distro="TinyCore" ;;
      trisquel) my_distro="Trisquel" ;;
      ubuntu)
        my_distro="Ubuntu"
        . "${FETCH_DATA_DIR}/lib/distro/ubuntu/lib.sh"
        ;;
      void*linux) my_distro="Void Linux" ;;
      *"windows"*)
        [ -z "${ascii_distro}" ] && ascii_distro="Windows"
        ;;
      zorin*) my_distro="Zorin OS" ;;
      *)
        ascii_distro="Unknown"
        config_ascii['colors']="random"
        ;;
    esac
  }

  [ -z "${ascii_distro}" ] && ascii_distro="${my_distro}"

  [ -n "${ascii_distro}" ] && ascii_distro="${ascii_distro// /-}"

  if [ -f "${FETCH_DATA_DIR}/ascii/${ascii_distro,,}.sh" ]; then
    # shellcheck source=/dev/null
    . "${FETCH_DATA_DIR}/ascii/${ascii_distro,,}.sh"
  else
    # shellcheck disable=SC1094,SC1090
    . "${FETCH_DATA_DIR}/ascii/unknown.sh"
  fi

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
    auto | *)
      # shellcheck disable=SC2154
      if [[ ${config_global[short]} =~ 'on' ]]; then
        :
      else
        [ -n "${distro_release}" ] && my_distro+=" ${distro_release}"
        [ -n "${distro_codename}" ] && my_distro+=" ${distro_codename}"
      fi
      ;;
  esac

  # TODO: turn into case
  [[ ${config_distro[os_arch]} =~ 'on' ]] && my_distro+=" ${kernel_machine}"

  # Return my_distro value for print_info()
  #printf '%b' "$(trim "${my_distro}")"

  # TODO: check verbosity here instead of in function, save function call
  verboseOut "Finding distribution...found as '${my_distro}'."
}
