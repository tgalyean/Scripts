#!/usr/bin/env bash
# Kali linux setup script for Sana

RELEASE=`lsb_release -c|awk '{print $2}'`

if [ ${RELEASE} == "sana" ]; then

    # going to be working from tmp so cd there now..
    cd /tmp

    # add additional repositories
    echo '
    deb http://security.kali.org/kali-security/ sana/updates main contrib non-free
    deb-src http://security.kali.org/kali-security/ sana/updates main contrib non-free
    deb http://http.kali.org/kali sana main non-free contrib' > /etc/apt/sources.list

    # update packages
    apt-get update
    apt-get upgrade -y
    apt-get dist-upgrade -y
    apt-get install ccache libssl-dev liblzo2-dev mtr -y

    #configure ccache
    echo 'export CC="ccache gcc"' >> ~/.bashrc
    source ~/.bashrc

    # install openssl 1.0.2d (latest as of 11/19/2015)
    wget http://www.openssl.org/source/openssl-1.0.2d.tar.gz -O /tmp/openssl-1.0.2d.tar.gz
    tar -xzf openssl-1.0.2d.tar.gz
    cd openssl-1.0.2d
    ./config
    make
    make install
    cd ..

    # install openvpn 2.3.8 (latest as of 11/19/2015)
    wget https://swupdate.openvpn.org/community/releases/openvpn-2.3.8.tar.gz -O /tmp/openvpn-2.3.8.tar.gz
    tar -xzf openvpn-2.3.8.tar.gz
    cd openvpn-2.3.8
    ./configure --enable-password-save --disable-plugin-auth-pam
    make
    make install

    # cleaning up
    cd ..
    rm -rf openvpn*
    rm -rf openssl*

    # setup vimrc
    wget http://www.timgalyean.com/.vimrc -O ~/.vimrc
else
    echo "This script was written for Kali Linux 2.0.. you are running ${RELEASE}"
fi
