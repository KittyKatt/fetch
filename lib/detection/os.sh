# shellcheck shell=bash
# shellcheck disable=SC2154
detect_os() {
  case "${kernel_name}" in
    Darwin)   my_os=${darwin_name} ;;
    SunOS)    my_os=Solaris ;;
    Haiku)    my_os=Haiku ;;
    MINIX)    my_os=MINIX ;;
    AIX)      my_os=AIX ;;
    IRIX*)    my_os=IRIX ;;
    FreeMiNT) my_os=FreeMiNT ;;
    Linux | GNU*)
      my_os=Linux
      ;;
    *BSD | DragonFly | Bitrig)
      my_os=BSD
      ;;
    CYGWIN* | MSYS* | MINGW*)
      my_os=Windows
      ;;
    *)
      errorOut "Unknown OS detected, please report this issue."
      ;;
  esac

  verboseOut "Finding OS...found as '${my_os}'."
}

detect_os
