# please set the VXWORKS_INSTALL_PATH to match your setup
export VXWORKS_INSTALL_PATH=/opt/wr/vx/vx2509
export VXWORKS_VERSION=25.09

# set this section for your target network
export TARGET_IP=192.168.12.35
export SERVER_IP=192.168.12.51
export GATEWAY_IP=192.168.12.1
export NETMASK=255.255.255.0
export NETMASKHEX=ffffff00
export NETMASKCIDR=24


echo "Setting VxWorks developer's shell environment variables. type 'env | grep WIND' to see them"
${VXWORKS_INSTALL_PATH}/wrenv.sh -p vxworks/${VXWORKS_VERSION}
