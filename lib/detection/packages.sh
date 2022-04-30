# shellcheck shell=bash
# shellcheck disable=SC2154
detect_packages() {
  # most of this is pulled from neofetch with small edits to line up with
  # previous screenfetch functionality

  # to adjust the number of pkgs per pkg manager
  pkgs_h=0

  # _has: Check if package manager installed.
  # _dir: Count files or dirs in a glob.
  # _pac: If packages > 0, log package manager name.
  # _tot: Count lines in command output.
  _has() { type -p "${1}" > /dev/null && manager=${1}; }
  _dir() {
    ((my_packages += $#))
    _pac "$(($# - pkgs_h))"
  }
  _pac() {
    ((${1} > 0)) && {
      managers+=("${1} (${manager})")
      manager_string+="${manager}, "
    }
  }
  _tot() {
    IFS=$'\n' read -d "" -ra pkgs <<< "$("$@" 2> /dev/null)"
    ((my_packages += ${#pkgs[@]}))
    _pac "$((${#pkgs[@]} - pkgs_h))"
  }

  # Redefine _tot() for Bedrock Linux.
  [[ -f /bedrock/etc/bedrock-release && ${PATH} == */bedrock/cross/* ]] && {
    _tot() {
      IFS=$'\n' read -d "" -ra pkgs <<< "$(for s in $(brl list); do strat -r "${s}" "${@}"; done)"
      ((my_packages += "${#pkgs[@]}"))
      _pac "$((${#pkgs[@]} - pkgs_h))"
    }
    br_prefix="/bedrock/strata/*"
  }

  # get total packages based on OS value
  case ${my_os} in
    Linux | BSD | Solaris)
      # simple commands
      _has kiss           && _tot kiss 1
      _has cpt-list       && _tot cpt-list
      _has pacman-key     && _tot pacman -Qq --color never
      _has apt            && _tot dpkg-query -W   # dpkg-query is much faster than apt
      _has xbps-query     && _tot xbps-query -list
      _has apk            && _tot apk info
      _has opkg           && _tot opkg list-installed
      _has pacman-g2      && _tot pacman-g2 -q
      _has lvu            && _tot lvu installed
      _has tce-status     && _tot tce-status -lvu
      _has pkg_info       && _tot pkg_info
      _has tazpkg         && pkgs_h=6 _tot tazpkg list && ((my_packages -= 6))
      _has sorcery        && _tot gaze installed
      _has alps           && _tot alps showinstalled
      _has butch          && _tot butch list
      _has swupd          && _tot swupd bundle-list --quiet
      _has pisi           && _tot pisi list-installed
      _has inary          && _tot inary li

      if _has dnf && type -p sqlite3 > /dev/null && [[ -f /var/cache/dnf/packages.db ]]; then
        _pac "$(sqlite3 /var/cache/dnf/packages.db "SELECT count(pkg) FROM installed")"
      else
        _has rpm && _tot rpm -qa
      fi

      # 'mine' conflicts with minesweeper games.
      [[ -f /etc/SDE-VERSION ]] && _has mine && _tot mine -q

      # file/dir count
      # $br_prefix is apparently fixed and won't change based on user input
      # shellcheck disable=SC2086
      {
        shopt -s nullglob
        _has brew       && _dir "$(brew --cellar)"/*
        _has emerge     && _dir ${br_prefix}/var/db/pkg/*/*/
        _has Compile    && _dir ${br_prefix}/Programs/*/
        _has eopkg      && _dir ${br_prefix}/var/lib/eopkg/package/*
        _has crew       && _dir ${br_prefix}/usr/local/etc/crew/meta/*.filelist
        _has pkgtool    && _dir ${br_prefix}/var/log/packages/*
        _has scratch    && _dir ${br_prefix}/var/lib/scratchpkg/index/*/.pkginfo
        _has kagami     && _dir ${br_prefix}/var/lib/kagami/pkgs/*
        _has cave       && _dir ${br_prefix}/var/db/paludis/repositories/cross-installed/*/data/*/ \
          ${br_prefix}/var/db/paludis/repositories/installed/data/*/
        shopt -u nullglob
      }

      # Complex commands
      _has kpm-pkg        && ((my_packages += $(kpm  --get-selections | grep -cv deinstall$)))
      _has guix           && {
        manager=guix-system && _tot guix package -p "/run/current-system/profile" -I
        manager=guix-user   && _tot guix package -I
      }
      _has nix-store      && {
        nix-user-pkgs() {
          nix-store -qR ~/.nix-profile
          nix-store -qR /etc/profiles/per-user/"${USER}"
        }
        manager=nix-system  && _tot nix-store -qR /run/current-system/sw
        manager=nix-user    && _tot nix-user-pkgs
        manager=nix-default && _tot nix-store -qR /nix/var/nix/profiles/default
      }

      # pkginfo is also the name of a python package manager which is painfully slow.
      # TODO: Fix this somehow. (neofetch)
      _has pkginfo && _tot pkginfo -i

      # BSD-like package detection
      case ${kernel_name} in
        FreeBSD | DragonFly) _has pkg && _tot pkg info ;;
        *)
          _has pkg && _dir /var/db/pkg/*
          ((my_packages == 0)) && _has pkg && _tot pkg list
          ;;
      esac

      # list these last as they accompany regular package managers.
      _has flatpak    && _tot flatpak list
      _has spm        && _tot spm list -i
      _has puyo       && _dir ~/.puyo/installed

      # Snap hangs if the command is run without the daemon running.
      # Only run snap if the daemon is also running.
      _has snap && pgrep -x snapd > /dev/null &&
        pkgs_h=1 _tot snap list && ((my_packages -= 1))

      # This is the only standard location for appimages.
      # See: https://github.com/AppImage/AppImageKit/wiki
      manager=appimage && _has appimaged && _dir ~/.local/bin/*.appimage
      ;;
    "Mac OS X" | "macOS")
      _has port   && pkgs_h=1 _tot port installed && ((my_packages -= 1))
      _has brew   && _dir /usr/local/Cellar/*
      _has nix-store && {
        nix-user-pkgs() {
          nix-store -qR ~/.nix-profile
          nix-store -qR /etc/profiles/per-user/"${USER}"
        }
        manager=nix-system  && _tot nix-store -qR /run/current-system/sw
        manager=nix-user    && _tot nix-store -qR nix-user-pkgs
      }
      ;;
    Windows)
      case ${kernel_name} in
        CYGWIN*)    _has cygcheck && _tot cygcheck -cd ;;
        MSYS*)      _has pacman   && _tot pacman -Qq --color never ;;
        *)          : ;;
      esac

      # Scoop environment throws errors if `tot scoop list` is used
      _has scoop && pkgs_h=1 _dir ~/scoop/apps/* && ((my_packages -= 1))

      # Count chocolatey packages.
      _has choco && _dir /c/ProgramData/chocolatey/lib/*
      [ -d /cygdrive/c/ProgramData/chocolatey/lib ] &&
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
      on | *)
        my_packages+=" (${manager_string%,*})"
        ;;
    esac
    # replace pacman-key with pacman
    my_packages=${my_packages/pacman-key/pacman}
  fi

  verboseOut "Finding current package count...found as '${my_packages}'."
}

detect_packages
