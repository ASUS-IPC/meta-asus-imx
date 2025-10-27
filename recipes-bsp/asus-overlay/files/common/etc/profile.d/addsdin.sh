# add sbin to root user
if [ "$(id -u)" -eq 0 ]; then
    echo "$PATH" | grep -q "sbin"
    if [ "$?" == 1 ]; then
       PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin
    fi
fi
