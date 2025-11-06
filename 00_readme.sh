#!/bin/sh
echo "****************************"
echo "-Step one: edit the \"O1_setup_wrenv\" wrenv setup script for your OS. Point it at your VxWorks installation. 
echo "      Linux Users: edit and run 01_setup_wrenv.sh"
echo "      Windows Users: edit and run 01_setup_wrenv.bat"
echo " Note: after running either script, you'll be in a bash shell
echo " "
echo "-Step two: run the 02_create_rpi4.sh"
echo " "
echo "- Note: after building, you can import the project into Workbench, see README.md for instructions"
echo "****************************"
mkdir -p build
