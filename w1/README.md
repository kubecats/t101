PIP=52.79.157.103
while true; do curl --connect-timeout 1  http://$PIP:50000/ ; echo "------------------------------"; date; sleep 1; done
Hello, LHS 50000
------------------------------
Sun Oct 23 00:45:18 KST 2022


pluralith plan


infracost breakdown --path . > infracost.txt
