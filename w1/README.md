PIP=${EC2_Public_IP}
while true; do curl --connect-timeout 1  http://$PIP:50000/ ; echo "------------------------------"; date; sleep 1; done
Hello, LHS 50000
---------------------------
Sun Oct 23 00:45:18 KST 2022


pluralith plan
![image](https://user-images.githubusercontent.com/76464384/197349108-d9496ed2-05c1-438c-9c6d-181433d893c3.png)


infracost breakdown --path .
![image](https://user-images.githubusercontent.com/76464384/197348267-b3f30034-9928-4ba0-af42-3ab8f3c59394.png)
