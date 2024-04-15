echo > /etc/sunbearvpn/xray-mini-nontls/access.log
echo > /etc/sunbearvpn/xray-mini-nontls/error.log
echo > /etc/sunbearvpn/xray-mini-tls/access.log
echo > /etc/sunbearvpn/xray-mini-tls/error.log
echo > /etc/sunbearvpn/xray-mini-socks/access.log
echo > /etc/sunbearvpn/xray-mini-socks/error.log
echo > /etc/sunbearvpn/xray-mini-shadowsocks/access.log
echo > /etc/sunbearvpn/xray-mini-shadowsocks/error.log
echo > /var/log/syslog
echo "$(date) | Berjaya clear semua log" > /etc/sunbearvpn/clearlog.log
