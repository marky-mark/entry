#!/bin/bash

set -e

telnetWait() {
    host=$1
    port=$2
    name=$3

    until echo "quit" | telnet "$host" "$port"; do
    >&2 echo "$name is unavailable - sleeping"
      sleep 1
    done

    >&2 echo "$name is up - starting service"
}

jarCommandsStartIndex=0

waitOnApps() {
    numberOfApps=${args[1]}
    echo "waiting on ${numberOfApps} apps"

    argNumber=2;

    leastArgumentSize=$((numberOfApps * 3))
    argumentLength=$(($# - $argNumber))

    if [ "$argumentLength" -lt "$leastArgumentSize" ]; then
        echo "Missing some details....wait <number_of_apps> <app_address> <app_port> <app_name>.."
    else
        apps=0;
        until [ "$apps" -ge "$numberOfApps" ]; do
            host=argNumber
            port=argNumber+1
            name=argNumber+2
            echo "waiting on... ${args[host]} ${args[port]} ${args[name]}"
            telnetWait ${args[host]} ${args[port]} ${args[name]}
            argNumber=$((argNumber + 3))
            apps=$((apps + 1))
        done
    fi

    jarCommandsStartIndex="$argNumber"
}

AppCommandArgs=("$@")

if [ $# -gt 0 ]; then

    echo "$# Arguments...$@"
    args=("$@")
    if [ "${args[0]}" == "wait" ]; then
        waitOnApps $@
        len=${#args[@]}
        AppCommandArgs=${args[@]:$jarCommandsStartIndex:$len}
    fi
fi

exec $AppCommandArgs
