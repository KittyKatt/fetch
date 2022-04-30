# shellcheck shell=bash
# shellcheck disable=SC2154
detect_memory() {
  case ${my_os} in
    "Linux" | "Windows")
      # MemUsed = Memtotal + Shmem - MemFree - Buffers - Cached - SReclaimable
      # Source: https://github.com/KittyKatt/screenFetch/issues/386#issuecomment-249312716
      while IFS=":" read -r a b; do
        case ${a} in
          "MemTotal")
            ((mem_used += ${b/kB/}))
            mem_total="${b/kB/}"
            ;;
          "Shmem") ((mem_used += ${b/kB/}))  ;;
          "MemFree" | "Buffers" | "Cached" | "SReclaimable")
            mem_used="$((mem_used -= ${b/kB/}))"
            ;;
          "MemAvailable")
            mem_avail=${b/kB/}
            ;;
          *) exit 1 ;;
        esac
      done < /proc/meminfo

      if [[ -n ${mem_avail} ]]; then
        mem_used=$(((mem_total - mem_avail) / 1024))
      else
        mem_used="$((mem_used / 1024))"
      fi

      mem_total="$((mem_total / 1024))"
      ;;
    "BSD")
      case ${kernel_name} in
        "NetBSD"*) mem_total="$(($(sysctl -n hw.physmem64) / 1024 / 1024))" ;;
        *) mem_total="$(($(sysctl -n hw.physmem) / 1024 / 1024))" ;;
      esac

      # shellcheck disable=SC2312
      {
        case ${kernel_name} in
          "NetBSD"*)
            mem_free="$(($(awk -F ':|kB' '/MemFree:/ {printf $2}' /proc/meminfo) / 1024))"
            ;;
          "FreeBSD"* | "DragonFly"*)
            hw_pagesize="$(sysctl -n hw.pagesize)"
            mem_inactive="$(($(sysctl -n vm.stats.vm.v_inactive_count) * hw_pagesize))"
            mem_unused="$(($(sysctl -n vm.stats.vm.v_free_count) * hw_pagesize))"
            mem_cache="$(($(sysctl -n vm.stats.vm.v_cache_count) * hw_pagesize))"
            mem_free="$(((mem_inactive + mem_unused + mem_cache) / 1024 / 1024))"
            ;;
          "OpenBSD"*) ;;
          *) mem_free="$(($(vmstat | awk 'END {printf $5}') / 1024))" ;;
        esac
      }

      # shellcheck disable=SC2312
      {
        case ${kernel_name} in
          "OpenBSD"*)
            mem_used="$(vmstat | awk 'END {printf $3}')"
            mem_used="${mem_used/M/}"
            ;;
          *) mem_used="$((mem_total - mem_free))" ;;
        esac
      }
      ;;
    "Mac OS X" | "macOS")
      # shellcheck disable=SC2312
      {
        mem_total="$(($(sysctl -n hw.memsize) / 1024 / 1024))"
        mem_wired="$(vm_stat | awk '/ wired/ { print $4 }')"
        mem_active="$(vm_stat | awk '/ active/ { printf $3 }')"
        mem_compressed="$(vm_stat | awk '/ occupied/ { printf $5 }')"
        mem_compressed="${mem_compressed:-0}"
        mem_used="$(((${mem_wired//./} + ${mem_active//./} + ${mem_compressed//./}) * 4 / 1024))"
      }
      ;;
    "Haiku")
      # shellcheck disable=SC2312
      {
        mem_total="$(($(sysinfo -mem | awk -F '\\/ |)' '{print $2; exit}') / 1024 / 1024))"
        mem_used="$(sysinfo -mem | awk -F '\\/|)' '{print $2; exit}')"
        mem_used="$((${mem_used/max/} / 1024 / 1024))"
      }
      ;;
    *)
      mem_total=
      mem_used=
      ;;
  esac

  # shellcheck disable=SC2154
  [[ ${config_memory[percent]} == "on" ]] && ((mem_perc = mem_used * 100 / mem_total))

  my_memory="${mem_used}${mem_label:-MiB} / ${mem_total}${mem_label:-MiB} ${mem_perc:+(${mem_perc}%)}"

  # Return my_memory value for print_info()
  #printf '%b' "$(trim "${my_memory}")"

  # TODO: check verbosity here instead of in function, save function call
  verboseOut "Finding memory usage...found as '${my_memory}'."
}
