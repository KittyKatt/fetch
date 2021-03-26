# shellcheck shell=bash
# shellcheck disable=SC2154,SC2034
detect_kernel() {
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

    # Return my_kernel value for print_info()
    #printf '%b' "$(trim "${my_kernel}")"

    # TODO: check verbosity here instead of in function, save function call
    verboseOut "Finding kernel...found as '${my_kernel}'."
}
