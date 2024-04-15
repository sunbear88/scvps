#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
# (C) Copyright 2022 Oleh KaizenVPN
# ═══════════════════════════════════════════════════════════════════
# Nama        : Autoskrip VPN
# Info        : Memasang pelbagai jenis servis vpn didalam satu skrip
# Dibuat Pada : 30-08-2022 ( 30 Ogos 2022 )
# OS Support  : Ubuntu & Debian
# Owner       : KaizenVPN
# Telegram    : https://t.me/KaizenA
# Github      : github.com/sunbear88
# ═══════════════════════════════════════════════════════════════════

dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

# ══════════════════════════
# // Export Warna & Maklumat
# ══════════════════════════
export RED='\033[1;91m';
export GREEN='\033[1;92m';
export YELLOW='\033[1;93m';
export BLUE='\033[1;94m';
export PURPLE='\033[1;95m';
export CYAN='\033[1;96m';
export LIGHT='\033[1;97m';
export NC='\033[0m';

# ════════════════════════════════
# // Export Maklumat Status Banner
# ════════════════════════════════
export ERROR="[${RED} ERROR ${NC}]";
export INFO="[${YELLOW} INFO ${NC}]";
export OKEY="[${GREEN} OKEY ${NC}]";
export PENDING="[${YELLOW} PENDING ${NC}]";
export SEND="[${YELLOW} SEND ${NC}]";
export RECEIVE="[${YELLOW} RECEIVE ${NC}]";
export REDBG='\e[41m';
export WBBG='\e[1;47;30m';

# ═══════════════
# // Export Align
# ═══════════════
export BOLD="\e[1m";
export WARNING="${RED}\e[5m";
export UNDERLINE="\e[4m";

# ════════════════════════════
# // Export Maklumat Sistem OS
# ════════════════════════════
export OS_ID=$( cat /etc/os-release | grep -w ID | sed 's/ID//g' | sed 's/=//g' | sed 's/ //g' );
export OS_VERSION=$( cat /etc/os-release | grep -w VERSION_ID | sed 's/VERSION_ID//g' | sed 's/=//g' | sed 's/ //g' | sed 's/"//g' );
export OS_NAME=$( cat /etc/os-release | grep -w PRETTY_NAME | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' );
export OS_KERNEL=$( uname -r );
export OS_ARCH=$( uname -m );

# ═══════════════════════════════════
# // String Untuk Membantu Pemasangan
# ═══════════════════════════════════
export VERSION="2.5";
export EDITION="Multiport Edition";
export AUTHER="KaizenVPN";
export ROOT_DIRECTORY="/etc/sunbearvpn";
export CORE_DIRECTORY="/usr/local/sunbearvpn";
export SERVICE_DIRECTORY="/etc/systemd/system";
export SCRIPT_SETUP_URL="https://raw.githubusercontent.com/sunbear88/scvps/main/setup.sh";
export REPO_URL="https://github.com/sunbear88/scvps";

# ═══════════════
# // Allow Access
# ═══════════════
BURIQ () {
    curl -sS https://raw.githubusercontent.com/sunbear88/scvpssettings/main/specialaccess > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f  /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f  /root/tmp
}
# https://raw.githubusercontent.com/sunbear88/scvpssettings/main/specialaccess
MYIP=$(curl -sS ipv4.icanhazip.com)
Name=$(curl -sS https://raw.githubusercontent.com/sunbear88/scvpssettings/main/specialaccess | grep $MYIP | awk '{print $2}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)
Bloman () {
if [ -f "/etc/.$Name.ini" ]; then
CekTwo=$(cat /etc/.$Name.ini)
    if [ "$CekOne" = "$CekTwo" ]; then
        res="Expired"
    fi
else
res="Permission Accepted..."
fi
}
PERMISSION () {
    MYIP=$(curl -sS ipv4.icanhazip.com)
    IZIN=$(curl -sS https://raw.githubusercontent.com/sunbear88/scvpssettings/main/specialaccess | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}
PERMISSION
if [ "$res" = "Permission Accepted..." ]; then
echo -ne
else
echo -e "${ERROR} Permission Denied!";
exit 0
fi

# ═════════════════════════════════════════════════════════
# // Semak kalau anda sudah running sebagai root atau belum
# ═════════════════════════════════════════════════════════
if [[ "${EUID}" -ne 0 ]]; then
		echo -e " ${ERROR} Sila jalankan skrip ini sebagai root user";
		exit 1
fi

# ════════════════════════════════════════════════════════════
# // Menyemak sistem sekiranya terdapat pemasangan yang kurang
# ════════════════════════════════════════════════════════════
if ! which jq > /dev/null; then
    clear;
    echo -e "${ERROR} JQ Packages Not installed";
    exit 1;
fi

# ═══════════════════════════════
# // Exporting maklumat rangkaian
# ═══════════════════════════════
wget -qO- --inet4-only 'https://raw.githubusercontent.com/sunbear88/scvpssettings/main/get-ip_sh' | bash;
source /root/ip-detail.txt;
export IP_NYA="$IP";
export ASN_NYA="$ASN";
export ISP_NYA="$ISP";
export REGION_NYA="$REGION";
export CITY_NYA="$CITY";
export COUNTRY_NYA="$COUNTRY";
export TIME_NYA="$TIMEZONE";

# ═════════════
# // Clear Data
# ═════════════
clear;

# ════════════════
# // Membuat Akaun
# ════════════════
clear;
echo -e "";
echo -e "";
cowsay -f ghostbusters "SELAMAT DATANG BOSKU.";
echo -e "";
echo -e "${CYAN}════════════════════════════════════════════${NC}";
echo -e "${WBBG}          [ Membuat Akaun Vless ]           ${NC}";
echo -e "${CYAN}════════════════════════════════════════════${NC}";
echo -e "";
read -p "  ► Sila masukkan Username            : " Username;
Username="$(echo ${Username} | sed 's/ //g' | tr -d '\r' | tr -d '\r\n' )";

# // Validate Input
if [[ $Username == "" ]]; then
    clear;
    echo -e "  ${EROR} Sila masukkan Username !";
    exit 1;
fi

# // Creating User database file
touch /etc/xray-mini/client.conf;

# // Checking User already on vps or no
if [[ "$( cat /etc/xray-mini/client.conf | grep -w ${Username})" == "" ]]; then
    Do=Nothing;
else
    clear;
    echo -e "  ${EROR} User ( ${YELLOW}$Username${NC} ) sudah dipakai !";
    exit 1;
fi

# // Expired Date
read -p "  ► Sila masukkan Tempoh Aktif (hari) : " Jumlah_Hari;
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`;
hariini=`date -d "0 days" +"%Y-%m-%d"`;

# // Generate New UUID & Domain
uuid=$( cat /proc/sys/kernel/random/uuid );
domain=$( cat /etc/sunbearvpn/domain.txt );

# // Force create folder for fixing account wasted
mkdir -p /etc/sunbearvpn/cache/;
mkdir -p /etc/xray-mini/;
mkdir -p /etc/sunbearvpn/xray-mini-tls/;
mkdir -p /etc/sunbearvpn/xray-mini-nontls/;

# // Getting vless port using grep from config
tls_port=$( cat /etc/xray-mini/tls.json | grep -w port | awk '{print $2}' | head -n1 | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' );
nontls_port=$( cat /etc/xray-mini/nontls.json | grep -w port | awk '{print $2}' | head -n1 | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' );

export CHK=$( cat /etc/xray-mini/tls.json );
if [[ $CHK == "" ]]; then
    clear;
    echo -e "  ${ERROR} Terdapat masalah teknikal didalam VPS anda. Sila hubungi admin untuk fixkan VPS anda !";
    exit 1;
fi

# // Input Your Data to server
cp /etc/xray-mini/tls.json /etc/sunbearvpn/xray-mini-utils/tls-backup.json;
cat /etc/sunbearvpn/xray-mini-utils/tls-backup.json | jq '.inbounds[3].settings.clients += [{"id": "'${uuid}'","email": "'${Username}'"}]' > /etc/sunbearvpn/xray-mini-cache.json;
cat /etc/sunbearvpn/xray-mini-cache.json | jq '.inbounds[6].settings.clients += [{"id": "'${uuid}'","email": "'${Username}'"}]' > /etc/xray-mini/tls.json;
cp /etc/xray-mini/nontls.json /etc/sunbearvpn/xray-mini-utils/nontls-backup.json;
cat /etc/sunbearvpn/xray-mini-utils/nontls-backup.json | jq '.inbounds[1].settings.clients += [{"id": "'${uuid}'","email": "'${Username}'"}]' > /etc/xray-mini/nontls.json;
echo -e "Vless $Username $exp" >> /etc/xray-mini/client.conf;

# // Make Config Link
vless_nontls="vless://${uuid}@162.159.134.61:${nontls_port}?path=/vless&security=none&encryption=none&host=${domain}&headerType=none&type=ws&quicSecurity=none#${Username}";
vless_nontls2="vless://${uuid}@useinsider.com:${nontls_port}?path=/vless&security=none&encryption=none&host=${domain}&headerType=none&type=ws&quicSecurity=none#${Username}";
#vless_nontls1="vless://${uuid}@mobilesdk.useinsider.com:${nontls_port}?path=%2Fvless&security=none&encryption=none&host=${domain}&type=ws#${Username}";
#vless_tls="vless://${uuid}@api.useinsider.com:${tls_port}?path=CF-RAY%3Ahttp%3A//api.useinsider.com/vless&security=tls&encryption=none&host=${domain}&type=ws&sni=api.useinsider.com#${Username}";
vless_tls1="vless://${uuid}@www.pokemon.com.${domain}:${tls_port}?path=/vless&security=tls&encryption=none&type=ws&sni=www.pokemon.com#${Username}";
#vless_grpc="vless://${uuid}@${domain}:${tls_port}?mode=gun&security=tls&encryption=none&type=grpc&serviceName=Vless-GRPC#${Username}";

# // Restarting XRay Service
systemctl enable xray-mini@tls;
systemctl enable xray-mini@nontls;
systemctl start xray-mini@tls;
systemctl start xray-mini@nontls;
systemctl restart xray-mini@tls;
systemctl restart xray-mini@nontls;

# // Make Client Folder for save the configuration
mkdir -p /etc/sunbearvpn/vless/;
mkdir -p /etc/sunbearvpn/vless/${Username};
rm -f /etc/sunbearvpn/vless/${Username}/config.log;

# ═══════════════════════
# // Maklumat Akaun Vless
# ═══════════════════════
clear; 
echo "" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e "${WBBG}          [ Maklumat Akaun Vless ]          ${NC}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " Username    ► ${Username}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " Dibuat Pada ► ${hariini}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " Expire Pada ► ${exp}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " IP          ► ${IP_NYA}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " Address     ► ${domain}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " Port TLS    ► ${tls_port}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " Port NTLS   ► ${nontls_port}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " User ID     ► ${uuid}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " LINK CONFIG DIGI POKEMON" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " ${vless_tls1}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " LINK CONFIG DIGI ANDROID & IOS (VLESS WS NONE TLS)" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " ${vless_nontls}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " LINK CONFIG DIGI APN (VLESS WS NONE TLS)" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " ${vless_nontls2}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;          A       ���F�U  P��F�U                                         !       UID                     !       UID                     1                ��F�U  ���F�U  �f            !       0                       A       ���F�U   ��F�U                                         !       EUID                    !       EUID                    1               Ј�F�U  p��F�U  ����            !       0                       A       ���F�U                  �D�U  P�D�U                  !       SECONDS                 !       SECONDS                 1               ���F�U  @��F�U  ����            A       0��F�U                  ��D�U  @�D�U                  !       BASH_ARGV0              !       BASH_ARGV0              1               P��F�U  ���F�U  $�I�            A       ���F�U                  ��D�U                          !       BASH_COMMAND            !       BASH_COMMAND            1                ��F�U  ���F�U  ɝ��            A       ���F�U                  ��D�U  ��D�U                  !       BASH_SUBSHELL           !       BASH_SUBSHELL           1               ���F�U  P��F�U  >X�I            A       @��F�U                  �*�D�U  �"�D�U                 !       RANDOM                  !       RANDOM                  1               `��F�U   ��F�U  �N^            A       ���F�U                  ��D�U  p�D�U                !       LINENO                  !       LINENO                  1               ��F�U  ���F�U  F��            A       ���F�U                  P�D�U  ��D�U                 !       BASHPID                 !       BASHPID                 1               ���F�U  `��F�U  z}�k            A       P��F�U                  ��D�U  ��D�U                 !       EPOCHSECONDS            !       EPOCHSECONDS            1               p��F�U  ��F�U  �-            A        ��F�U                  ��D�U  ��D�U                 !       EPOCHREALTIME           !       EPOCHREALTIME           1                ��F�U  ���F�U  ��%�            A       ���F�U                  �D�U                         !       HISTCMD                 !       HISTCMD                 1               Џ�F�U  p��F�U  S&5            A       `��F�U                  ��D�U   �D�U                  !       COMP_WORDBREAKS         !       COMP_WORDBREAKS         1               ���F�U   ��F�U  �e��            A       ��F�U  ���F�U          P�D�U  0�D�U                 !       DIRSTACK                !       DIRSTACK                1       @�F�U  0��F�U  А�F�U  � T�            1               ��������                ���F�U  1       ��������        ���F�U  ���F�U          A        ��F�U  ���F�U          �!�D�U  �$�D�U  @              !       GROUPS                  !       GROUPS                  1               @��F�U  ���F�U  �W3            1               ��������                ���F�U  1       ��������        ���F�U  ���F�U          A       0��F�U  ���F�U          `q�D�U  �$�D�U  `              !       BASH_ARGC               !       BASH_ARGC               1               P��F�U  ��F�U  	2��            1               ��������                Г�F�U  1       ��������        Г�F�U  Г�F�U          A       @��F�U  ���F�U          `q�D�U  �$�D�U  `              !       BASH_ARGV               !       BASH_ARGV               1               `��F�U   ��F�U  2��            1               ��������                ���F�U  1       ��������        ���F�U  ���F�U          A       P��F�U  ���F�U          ��D�U  �$�D�U  `              !       BASH_SOURCE             !       BASH_SOURCE             1               p��F�U  ��F�U  �F��            1               ��������                ��F�U  1       ��������        ��F�U  ��F�U          A       `��F�U  Ж�F�U          ��D�U  �$�D�U  `              !       BASH_LINENO             !       BASH_LINENO             1               ���F�U   ��F�U  ���Y            1               ��������                 ��F�U  1       ��������         ��F�U   ��F�U          A       p��F�U  ���F�U          �D�U   !�D�U  @              !       BASH_CMDS               !       BASH_CMDS               1               ���F�U  0��F�U  a���            !        ��F�U  �                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             A       P��F�U  ���F�U           �D�U  � �D�U  @              !       BASH_ALIASES            !       BASH_ALIASES            1               p��F�U  ��F�U  ���            !       ���F�U  �                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             A       0��F�U  ���F�U          �$�D�U  �$�D�U  P              !       FUNCNAME                !       FUNCNAME                1               P��F�U  ��F�U  j�V,            1               ��������                С�F�U  1       ��������        С�F�U  С�F�U          A       У�F�U  @��F�U                                         A       ���F�U  ��F�U                                         !       SHELLOPTS               !       SHELLOPTS               1               ���F�U  @��F�U  ��f�            A       braceexpand:hashall:interactive-comments                �               ��F�U  hist:complete_fullquote:extquote:force_fignore:globasciiranges:hostcomplete:interactive_comments:progcomp:promptvars:sourcepath         !       BASHOPTS                !       BASHOPTS                1               ��F�U   ��F�U  �            �       checkwinsize:cmdhist:complete_fullquote:extquote:force_fignore:globasciiranges:hostcomplete:interactive_comments:progcomp:promptvars:sourcepath         !                               �      ���F�U  0��F�U  `��F�U  ���F�U  ���F�U  ���F�U  ��F�U  Я�F�U   ��F�U   ��F�U  P��F�U  p��F�U  ���F�U   ��F�U  ���F�U  ���F�U                                                                                                                                                                                                                                                                                                                          !       SHELL=/bin/bash         �              ��F�U  ��F�U  ��F�U  ��F�U  ��F�U  ��F�U  *�F�U  +�F�U   ,�F�U   -�F�U  �-�F�U  �.�F�U   0�F�U  �1�F�U  �2�F�U                                                                                                                                                                                                                                                                                                                          �               ��F�U  `��F�U  ���F�U  ���F�U  ���F�U  ��F�U  Я�F�U   ��F�U   ��F�U  P��F�U  p��F�U  ���F�U   ��F�U  ���F�U  ���F�U          1       PWD=/root/scvps/Resource/Config/files   !       LOGNAME=root            !       _=./adddigi.sh          !       HOME=/root              !       LANG=en_US.UTF-8        �      LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:       1       LESSCLOSE=/usr/bin/lesspipe %s %s       !       TERM=xterm              1       LESSOPEN=| /usr/bin/lesspipe %s         !       USER=root               !       SHLVL=3                 !       SHLVL=3                 Q       XDG_DATA_DIRS=/usr/local/share:/usr/share:/var/lib/snapd/desktop        �       PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/root/.dotnet/tools             !       MAIL=/var/mail/root     A       OLDPWD=/root/scvps/Resource/Config/files                !       en_US.UTF-8             !       en_US.UTF-8             !       @-�F�U                 !       0:�F�U  ��F�U          !       ./adddigi.sh                  �9�F�U  �9�F�U  �:�F�U  �:�F�U  P;�F�U  �;�F�U  0<�F�U   =�F�U  @=�F�U  `>�F�U                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P:�F�U  p:�F�U  �:�F�U  0;�F�U  �;�F�U  �<�F�U  �<�F�U  �=�F�U  �=�F�U  �>�F�U                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 6�F�U  �5�F�U  @5�F�U  5�F�U  �4�F�U  �4�F�U  �4�F�U  P4�F�U   4�F�U  �3�F�U  �3�F�U  �2�F�U  �2�F�U  p2�F�U                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          �F                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      #!/bin/bash
# ═══════════════════════════════════════════════════════════════════
# (C) Copyright 2022 Oleh KaizenVPN
# ═══════════════════════════════════════════════════════════════════
# Nama        : Autoskrip VPN
# Info        : Memasang pelbagai jenis servis vpn didalam satu skrip
# Dibuat Pada : 30-08-2022 ( 30 Ogos 2022 )
# OS Support  : Ubuntu & Debian
# Owner       : KaizenVPN
# Telegram    : https://t.me/KaizenA
# Github      : github.com/sunbear88
# ═══════════════════════════════════════════════════════════════════

dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

# ══════════════════════════
# // Export Warna & Maklumat
# ══════════════════════════
export RED='\033[1;91m';
export GREEN='\033[1;92m';
export YELLOW='\033[1;93m';
export BLUE='\033[1;94m';
export PURPLE='\033[1;95m';
export CYAN='\033[1;96m';
export LIGHT='\033[1;97m';
export NC='\033[0m';

# ════════════════════════════════
# // Export Maklumat Status Banner
# ════════════════════════════════
export ERROR="[${RED} ERROR ${NC}]";
export INFO="[${YELLOW} INFO ${NC}]";
export OKEY="[${GREEN} OKEY ${NC}]";
export PENDING="[${YELLOW} PENDING ${NC}]";
export SEND="[${YELLOW} SEND ${NC}]";
export RECEIVE="[${YELLOW} RECEIVE ${NC}]";
export REDBG='\e[41m';
export WBBG='\e[1;47;30m';

# ═══════════════
# // Export Align
# ═══════════════
export BOLD="\e[1m";
export WARNING="${RED}\e[5m";
export UNDERLINE="\e[4m";

# ════════════════════════════
# // Export Maklumat Sistem OS
# ════════════════════════════
export OS_ID=$( cat /etc/os-release | grep -w ID | sed 's/ID//g' | sed 's/=//g' | sed 's/ //g' );
export OS_VERSION=$( cat /etc/os-release | grep -w VERSION_ID | sed 's/VERSION_ID//g' | sed 's/=//g' | sed 's/ //g' | sed 's/"//g' );
export OS_NAME=$( cat /etc/os-release | grep -w PRETTY_NAME | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' );
export OS_KERNEL=$( uname -r );
export OS_ARCH=$( uname -m );

# ═══════════════════════════════════
# // String Untuk Membantu Pemasangan
# ═══════════════════════════════════
export VERSION="2.5";
export EDITION="Multiport Edition";
export AUTHER="KaizenVPN";
export ROOT_DIRECTORY="/etc/sunbearvpn";
export CORE_DIRECTORY="/usr/local/sunbearvpn";
export SERVICE_DIRECTORY="/etc/systemd/system";
export SCRIPT_SETUP_URL="https://raw.githubusercontent.com/sunbear88/scvps/main/setup.sh";
export REPO_URL="https://github.com/sunbear88/scvps";

# ═══════════════
# // Allow Access
# ═══════════════
BURIQ () {
    curl -sS https://raw.githubusercontent.com/sunbear88/scvpssettings/main/specialaccess > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f  /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f  /root/tmp
}
# https://raw.githubusercontent.com/sunbear88/scvpssettings/main/specialaccess
MYIP=$(curl -sS ipv4.icanhazip.com)
Name=$(curl -sS https://raw.githubusercontent.com/sunbear88/scvpssettings/main/specialaccess | grep $MYIP | awk '{print $2}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)
Bloman () {
if [ -f "/etc/.$Name.ini" ]; then
CekTwo=$(cat /etc/.$Name.ini)
    if [ "$CekOne" = "$CekTwo" ]; then
        res="Expired"
    fi
else
res="Permission Accepted..."
fi
}
PERMISSION () {
    MYIP=$(curl -sS ipv4.icanhazip.com)
    IZIN=$(curl -sS https://raw.githubusercontent.com/sunbear88/scvpssettings/main/specialaccess | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}
PERMISSION
if [ "$res" = "Permission Accepted..." ]; then
echo -ne
else
echo -e "${ERROR} Permission Denied!";
exit 0
fi

# ═════════════════════════════════════════════════════════
# // Semak kalau anda sudah running sebagai root atau belum
# ═════════════════════════════════════════════════════════
if [[ "${EUID}" -ne 0 ]]; then
		echo -e " ${ERROR} Sila jalankan skrip ini sebagai root user";
		exit 1
fi

# ════════════════════════════════════════════════════════════
# // Menyemak sistem sekiranya terdapat pemasangan yang kurang
# ════════════════════════════════════════════════════════════
if ! which jq > /dev/null; then
    clear;
    echo -e "${ERROR} JQ Packages Not installed";
    exit 1;
fi

# ═══════════════════════════════
# // Exporting maklumat rangkaian
# ═══════════════════════════════
wget -qO- --inet4-only 'https://raw.githubusercontent.com/sunbear88/scvpssettings/main/get-ip_sh' | bash;
source /root/ip-detail.txt;
export IP_NYA="$IP";
export ASN_NYA="$ASN";
export ISP_NYA="$ISP";
export REGION_NYA="$REGION";
export CITY_NYA="$CITY";
export COUNTRY_NYA="$COUNTRY";
export TIME_NYA="$TIMEZONE";

# ═════════════
# // Clear Data
# ═════════════
clear;

# ════════════════
# // Membuat Akaun
# ════════════════
clear;
echo -e "";
echo -e "";
cowsay -f ghostbusters "SELAMAT DATANG BOSKU.";
echo -e "";
echo -e "${CYAN}════════════════════════════════════════════${NC}";
echo -e "${WBBG}          [ Membuat Akaun Vless ]           ${NC}";
echo -e "${CYAN}════════════════════════════════════════════${NC}";
echo -e "";
read -p "  ► Sila masukkan Username            : " Username;
Username="$(echo ${Username} | sed 's/ //g' | tr -d '\r' | tr -d '\r\n' )";

# // Validate Input
if [[ $Username == "" ]]; then
    clear;
    echo -e "  ${EROR} Sila masukkan Username !";
    exit 1;
fi

# // Creating User database file
touch /etc/xray-mini/client.conf;

# // Checking User already on vps or no
if [[ "$( cat /etc/xray-mini/client.conf | grep -w ${Username})" == "" ]]; then
    Do=Nothing;
else
    clear;
    echo -e "  ${EROR} User ( ${YELLOW}$Username${NC} ) sudah dipakai !";
    exit 1;
fi

# // Expired Date
read -p "  ► Sila masukkan Tempoh Aktif (hari) : " Jumlah_Hari;
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`;
hariini=`date -d "0 days" +"%Y-%m-%d"`;

# // Generate New UUID & Domain
uuid=$( cat /proc/sys/kernel/random/uuid );
domain=$( cat /etc/sunbearvpn/domain.txt );

# // Force create folder for fixing account wasted
mkdir -p /etc/sunbearvpn/cache/;
mkdir -p /etc/xray-mini/;
mkdir -p /etc/sunbearvpn/xray-mini-tls/;
mkdir -p /etc/sunbearvpn/xray-mini-nontls/;

# // Getting vless port using grep from config
tls_port=$( cat /etc/xray-mini/tls.json | grep -w port | awk '{print $2}' | head -n1 | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' );
nontls_port=$( cat /etc/xray-mini/nontls.json | grep -w port | awk '{print $2}' | head -n1 | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' );

export CHK=$( cat /etc/xray-mini/tls.json );
if [[ $CHK == "" ]]; then
    clear;
    echo -e "  ${ERROR} Terdapat masalah teknikal didalam VPS anda. Sila hubungi admin untuk fixkan VPS anda !";
    exit 1;
fi

# // Input Your Data to server
cp /etc/xray-mini/tls.json /etc/sunbearvpn/xray-mini-utils/tls-backup.json;
cat /etc/sunbearvpn/xray-mini-utils/tls-backup.json | jq '.inbounds[3].settings.clients += [{"id": "'${uuid}'","email": "'${Username}'"}]' > /etc/sunbearvpn/xray-mini-cache.json;
cat /etc/sunbearvpn/xray-mini-cache.json | jq '.inbounds[6].settings.clients += [{"id": "'${uuid}'","email": "'${Username}'"}]' > /etc/xray-mini/tls.json;
cp /etc/xray-mini/nontls.json /etc/sunbearvpn/xray-mini-utils/nontls-backup.json;
cat /etc/sunbearvpn/xray-mini-utils/nontls-backup.json | jq '.inbounds[1].settings.clients += [{"id": "'${uuid}'","email": "'${Username}'"}]' > /etc/xray-mini/nontls.json;
echo -e "Vless $Username $exp" >> /etc/xray-mini/client.conf;

# // Make Config Link
vless_nontls="vless://${uuid}@162.159.134.61:${nontls_port}?path=/vless&security=none&encryption=none&host=${domain}&headerType=none&type=ws&quicSecurity=none#${Username}";
vless_nontls2="vless://${uuid}@useinsider.com:${nontls_port}?path=/vless&security=none&encryption=none&host=${domain}&headerType=none&type=ws&quicSecurity=none#${Username}";
#vless_nontls1="vless://${uuid}@mobilesdk.useinsider.com:${nontls_port}?path=%2Fvless&security=none&encryption=none&host=${domain}&type=ws#${Username}";
#vless_tls="vless://${uuid}@api.useinsider.com:${tls_port}?path=CF-RAY%3Ahttp%3A//api.useinsider.com/vless&security=tls&encryption=none&host=${domain}&type=ws&sni=api.useinsider.com#${Username}";
vless_tls1="vless://${uuid}@www.pokemon.com.${domain}:${tls_port}?path=/vless&security=tls&encryption=none&type=ws&sni=www.pokemon.com#${Username}";
#vless_grpc="vless://${uuid}@${domain}:${tls_port}?mode=gun&security=tls&encryption=none&type=grpc&serviceName=Vless-GRPC#${Username}";

# // Restarting XRay Service
systemctl enable xray-mini@tls;
systemctl enable xray-mini@nontls;
systemctl start xray-mini@tls;
systemctl start xray-mini@nontls;
systemctl restart xray-mini@tls;
systemctl restart xray-mini@nontls;

# // Make Client Folder for save the configuration
mkdir -p /etc/sunbearvpn/vless/;
mkdir -p /etc/sunbearvpn/vless/${Username};
rm -f /etc/sunbearvpn/vless/${Username}/config.log;

# ═══════════════════════
# // Maklumat Akaun Vless
# ═══════════════════════
clear; 
echo "" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e "${WBBG}          [ Maklumat Akaun Vless ]          ${NC}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " Username    ► ${Username}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " Dibuat Pada ► ${hariini}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " Expire Pada ► ${exp}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " IP          ► ${IP_NYA}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " Address     ► ${domain}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " Port TLS    ► ${tls_port}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " Port NTLS   ► ${nontls_port}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " User ID     ► ${uuid}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " LINK CONFIG DIGI POKEMON" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " ${vless_tls1}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " LINK CONFIG DIGI ANDROID & IOS (VLESS WS NONE TLS)" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " ${vless_nontls}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " LINK CONFIG DIGI APN (VLESS WS NONE TLS)" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e " ${vless_nontls2}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/sunbearvpn/vless/${Username}/config.log;