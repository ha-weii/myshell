#!/bin/bash
#execute with general users
HOSTIP1=$1
HOSTIP2=$2
ssh_keygen() {
    /usr/bin/expect <<EOF
    set timeout 60
    spawn ssh-keygen -t rsa
    expect {
        "Enter file in which to save the key*" { send "\r"; exp_continue}
        "Overwrite (y/n)?*" { send "y\r";exp_continue}
	"Enter passphrase*" { send "\r";exp_continue }
        "Enter same passphrase again*" { send "\r"; exp_continue}
    }
    expect eof
EOF
}
pub_copy_1(){
    /usr/bin/expect <<EOF
    set timeout 60
    spawn ssh-copy-id -i /home/minz/.ssh/id_rsa.pub $HOSTIP1
    expect {
	"*connecting (yes/no)?" { send "yes\r";exp_continue}
	"*'s password:" { send "minz\r";exp_continue}
    }
    expect eof
EOF
}
pub_copy_2(){
    /usr/bin/expect <<EOF
    set timeout 60
    spawn ssh-copy-id -i /home/minz/.ssh/id_rsa.pub $HOSTIP2
    expect {
        "*connecting (yes/no)?" { send "yes\r";exp_continue}
        "*'s password:" { send "minz\r";exp_continue}
    }
    expect eof
EOF
}

[ "$#" -ne "2" ] && {
        echo Please input TWO object host ip  separated by a space.
        exit 0
}

echo minz |sudo -S apt-get install expect -y
ssh_keygen
sleep 5

pub_copy_1
sleep 5
pub_copy_2
sleep 5


eval "$(ssh-agent -s)" 
ssh-add
