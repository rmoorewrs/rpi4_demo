# Generate boot.scr:
# mkimage -c none -A arm -T script -d boot.cmd boot.scr.uimg
#
################
echo "This is the bootscript on microSD that boots VxWorks on the KR260"

# set your IP address and address of TFTP server
setenv ipaddr 192.168.12.32
setenv netmask 255.255.255.0
setenv serverip 192.168.12.51

tftpboot 0x100000 uVxWorks_rpi4
