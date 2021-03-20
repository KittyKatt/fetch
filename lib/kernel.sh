# shellcheck shell=bash
# shellcheck disable=SC2154,SC2034
detect_kernel() {
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
        for ((i = 0; i < ${#sw_vers[@]}; i += 2)); do
            case ${sw_vers[i]} in
                ProductName)            darwin_name=${sw_vers[i + 1]} ;;
                ProductVersion)         osx_version=${sw_vers[i + 1]} ;;
                #ProductBuildVersion)   osx_build=${sw_vers[i + 1]} ;;
                *) : ;;
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

detect_kernel
