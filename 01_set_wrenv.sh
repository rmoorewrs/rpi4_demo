# please set the VXWORKS_INSTALL_PATH to match your setup
export VXWORKS_INSTALL_PATH=/opt/wr/vx/vx2509
export VXWORKS_VERSION=25.09

echo "Setting VxWorks developer's shell environment variables. type 'env | grep WIND' to see them"
${VXWORKS_INSTALL_PATH}/wrenv.sh -p vxworks/${VXWORKS_VERSION}
