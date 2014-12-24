sshrc.sh: Send mail while ssh login

pam.sh: Send mail while ssh login or logout, need add the follow line to /etc/pam.d/sshd

>session optional pam_exec.so log=/var/log/login.log /etc/ssh/pam.sh

