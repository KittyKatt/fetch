# shellcheck shell=bash
# shellcheck disable=SC2154
detect_cpu() {
    case ${my_os} in
        "Mac OS X" | "macOS")
            my_cpu="$(sysctl -n machdep.cpu.brand_string)"
            _cores=$(sysctl -n hw.logicalcpu_max)
            ;;
        "Linux" | "Windows")
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
                    [ -z "${my_cpu}" ] && my_cpu="$(awk -F':' '/family/ {printf $2; exit}' "${_file}")"
                    ;;
                *)
                    my_cpu="$(awk -F '\\s*: | @' \
                        '/model name|Hardware|Processor|^cpu model|chip type|^cpu type/ {
                        cpu=$2; if ($1 == "Hardware") exit } END { print cpu }' "${_file}")"
                    ;;
            esac

            _speed_dir="/sys/devices/system/cpu/cpu0/cpufreq"

            # Select the right temperature file.
            [[ -d /sys/class/hwmon && -n "$(ls -A /sys/class/hwmon)" ]] &&
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
                _speed="$(< "${_speed_dir}/bios_limit")" ||
                    _speed="$(< "${_speed_dir}/scaling_max_freq")" ||
                    _speed="$(< "${_speed_dir}/cpuinfo_max_freq")"
                _speed="$((_speed / 1000))"
            else
                _speed="$(awk -F ': |\\.' '/cpu MHz|^clock/ {printf $2; exit}' "${_file}")"
                _speed="${_speed/MHz/}"
            fi

            # Get CPU temp.
            [ -f "${temp_dir}" ] && _deg="$(($(< "${temp_dir}") * 100 / 10000))"

            # Get CPU cores.
            _cores="$(grep -c "^processor" "${_file}")"
            ;;
        *) return ;;
    esac

    # Remove un-needed patterns from cpu output.
    my_cpu="${my_cpu//(TM)/}"
    my_cpu="${my_cpu//(tm)/}"
    my_cpu="${my_cpu//(R)/}"
    my_cpu="${my_cpu//(r)/}"
    my_cpu="${my_cpu//?([+[:space:]])CPU/}"
    my_cpu="${my_cpu//Processor/}"
    my_cpu="${my_cpu//Dual-Core/}"
    my_cpu="${my_cpu//Quad-Core/}"
    my_cpu="${my_cpu//Six-Core/}"
    my_cpu="${my_cpu//Eight-Core/}"
    my_cpu="${my_cpu//[1-9][0-9]-Core/}"
    my_cpu="${my_cpu//[0-9]-Core/}"
    my_cpu="${my_cpu//, * Compute Cores/}"
    my_cpu="${my_cpu//Core / }"
    my_cpu="${my_cpu//(\"AuthenticAMD\"*)/}"
    my_cpu="${my_cpu//with Radeon * Graphics/}"
    my_cpu="${my_cpu// with Radeon * Gfx/}"
    my_cpu="${my_cpu//, altivec supported/}"
    my_cpu="${my_cpu//FPU*/}"
    my_cpu="${my_cpu//Chip Revision*/}"
    my_cpu="${my_cpu//Technologies, Inc/}"
    my_cpu="${my_cpu//Core2/Core 2}"

    # Trim spaces from core and speed output
    _cores="${_cores//[[:space:]]/}"
    _speed="${_speed//[[:space:]]/}"

    # Remove CPU brand from the output.
    # shellcheck disable=SC2154
    if [ "${config_cpu[brand]}" == "off" ]; then
        my_cpu="${my_cpu/AMD /}"
        my_cpu="${my_cpu/Intel /}"
        my_cpu="${my_cpu/Core? Duo /}"
        my_cpu="${my_cpu/Qualcomm /}"
    fi

    # Add CPU cores to the output.
    # shellcheck disable=SC2154
    [[ ${config_cpu[cores]} != "off" && -n ${_cores} ]] &&
        case ${my_os} in
            "Mac OS X" | "macOS")   my_cpu="${my_cpu/@/(${_cores}) @}" ;;
            *)                      my_cpu="${my_cpu} (${_cores})" ;;
        esac

    # Add CPU speed to the output.
    # shellcheck disable=SC2154
    if [[ ${config_cpu[speed]} != "off" && -n ${_speed} ]]; then
        if ((_speed < 1000)); then
            my_cpu="${my_cpu} @ ${_speed}MHz"
        else
            _speed="${_speed:0:1}.${_speed:1}"
            my_cpu="${my_cpu} @ ${_speed}GHz"
        fi
    fi

    # Add CPU temp to the output.
    # shellcheck disable=SC2154
    {
        if [[ ${config_cpu[temp]} != "off" && -n ${_deg} ]]; then
            _deg="${_deg//./}"
            # Convert to Fahrenheit if enabled
            [ "${config_cpu[temp]}" == "F" ] && _deg="$((_deg * 90 / 50 + 320))"
            # Format the output
            _deg="[${_deg/${_deg: -1}/}.${_deg: -1}°${config_cpu[temp]:-C}]"
            my_cpu="${my_cpu} ${_deg}"
        fi
    }

    # TODO: check verbosity here instead of in function, save function call
    verboseOut "Finding CPU...found as '${my_cpu}'."
}
