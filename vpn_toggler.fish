#!/bin/fish

set window_title "Toggle VPN"

# If there are existing processes with same title, do nothing
set existing_processes (xdotool search --name "$window_title")
if test -n "$existing_processes"
    exit
end

set vpn_connections (nmcli connection show | grep vpn | grep -v "ipv6leak")
set yad_command "yad --title='$window_title' \
                --checklist \
                --undecorated \
                --no-click \
                --width=450 \
                --height=300 \
                --list \
                --column='Status ' \
                --column='VPN'"
set active_connections
set inactive_connections

for connection in $vpn_connections
    set name (echo $connection | awk '{print $1}')
    set id (echo $connection | awk '{print $2}')
    set vpn_status (echo $connection | awk '{print $4}')

    if test "$vpn_status" = --
        # This connection is not active
        set vpn_bool false
        set inactive_connections $inactive_connections $connection
    else
        # This connection is active
        set vpn_bool true
        set active_connections $active_connections $connection
    end

    set yad_command $yad_command $vpn_bool $name
end

set yad_command "$yad_command \
                --button='Cancel!gtk-cancel:1' \
                --button='Configure!gtk-preferences:nm-connection-editor' \
                --button='Confirm!gtk-ok:0'"

set toggled_active (eval $yad_command)

# The value of $status is 0 or 1 depending on which button the user pressed
if test $status -eq 0
    # Toggle connections on
    for result in $toggled_active
        set result (string replace "TRUE|" "" $result)
        set result (string replace "|" "" $result)
        set connection (echo $inactive_connections | grep "$result")

        if test -n "$connection"
            nmcli connection up (echo $connection | awk '{print $1}')
        end
    end

    # Toggle connections off
    set to_be_toggled_off ""
    for connection in $active_connections
        set name (echo $connection | awk '{print $1}')
        set match (echo $toggled_active | grep "$name")

        if not test -n "$match"
            set to_be_toggled_off $to_be_toggled_off $name
        end
    end

    for connection in $to_be_toggled_off
        nmcli connection down $connection
    end
end
