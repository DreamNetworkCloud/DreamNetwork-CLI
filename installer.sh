#!/bin/bash
echo "Installing DreamNetwork-CLI"
OS=linux
UID_ROOT=0
echo "
  
                                  ./((((/.            
                                (///////////          
                       ,(((((*///////////////.        
                       /(((((////////////////,        
                   (((((((((/////////////////////,    
                 /(((((((((////////////////////////   
                 /((((((((/////////////////////////   
                  ,((((((/////////////////////////    
                         \`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`  

______                               _   _        _                          _    
|  _  \                             | \ | |      | |                        | |   
| | | | _ __  ___   __ _  _ __ ___  |  \| |  ___ | |_ __      __ ___   _ __ | | __
| | | || '__|/ _ \ / _\` || '_ \` _ \ | . \` | / _ \| __|\ \ /\ / // _ \ | '__|| |/ /
| |/ / | |  |  __/| (_| || | | | | || |\  ||  __/| |_  \ V  V /| (_) || |   |   < 
|___/  |_|   \___| \__,_||_| |_| |_|\_| \_/ \___| \__|  \_/\_/  \___/ |_|   |_|\_\\
"

if [[ "$OSTYPE" != *"$OS"* ]];
then
    echo "Detected ${OSTYPE} but must be on ${OS}. "
    exit 0
fi


if [ "$UID" -ne "$UID_ROOT" ]
then
    echo "FAILED You must be a super user (root) to install the DreamNetwork-CLI."
    exit 0
fi  

if test -f "/etc/dreamnetwork/dreamnetwork"; then
    echo "You have already installed dreamnetwork"
    exit 0
fi

echo "Installing DreamNetwork..."
">> Checking OS"

declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/slackware-version]=pacman
osInfo[/etc/lsb-release]=apt-get

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        PACKAGE_MANAGER=${osInfo[$f]}
        success "Detected package manager: ${PACKAGE_MANAGER}"
    fi
done

if [ -z ${PACKAGE_MANAGER} ];then
    die "Unable to detect package manager or/and your OS isn't supported. Aborting."
fi

info ">> Updating system with ${PACKAGE_MANAGER}

"


case ${PACKAGE_MANAGER} in
    yum)
        yum -y update
        ;;
    pacman)
        pacman -Syu
        ;;
    apt-get)
        apt-get update
        apt-get -y upgrade
        ;;
    zypp)
        zypper update
        ;;
    emerge)
        emerge -uDN world
        ;;
    *)
        echo "$(printf '\033[31m')WARNING: Unable to detect package manager or/and your OS isn't supported. Continuing anyways."
        ;;
esac


