#!/bin/fish

set vpn_connections (nmcli connection show | grep vpn | grep -v "ipv6leak")
set nmcli_command "nmcli connection"
set yad_command "yad --title='Toggle VPN' --checklist --undecorated --no-click --width=450 --height=300 --list --column="Status " --column='VPN' --close-on-unfocus"
set active_connections
set inactive_connections

for connection in $vpn_connections
    set name (echo $connection | awk '{print $1}')
    set id (echo $connection | awk '{print $2}')
    set vpn_status (echo $connection | awk '{print $4}')

    if test "$vpn_status" = --
        set vpn_action up
        set vpn_bool false
        set inactive_connections $inactive_connections $connection
    else
        set vpn_action down
        set vpn_bool true
        set active_connections $active_connections $connection
    end

    set nmcli_command "nmcli connection $vpn_action $id)"
    set yad_command "$yad_command $vpn_bool $name"
end

set results (eval $yad_command)

if test $status -eq 0
    # Toggle connections on
    for result in $results
        set result (string replace "TRUE|" "" $result)
        set result (string replace "|" "" $result)
        set connection (echo $inactive_connections | grep "$result")

        if test -n "$connection"
            nmcli connection up (echo $connection | awk '{print $2}')
        end
    end

    # Toggle connections off
    set to_be_toggled_off ""
    for connection in $active_connections
        set id (echo $connection | awk '{print $2}')
        set match (echo $results | grep "$name")

        if test -z "$match"
            set to_be_toggled_off $to_be_toggled_off $id
        end
    end

    for connection in $to_be_toggled_off
        if test (string length "$connection") -gt 2
            nmcli connection down $connection
        end
    end
end
