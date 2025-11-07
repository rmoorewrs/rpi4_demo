# VxWorks on Raspberry Pi 4
This script builds a VxWorks Source Build (VSB) and a VxWorks Image Project (VIP) that will boot VxWorks on a Raspberry Pi 4 from the SD card, or via the network.
It will work on both Windows and Linux supported development hosts. 

## Step 1: Clone the Project
Open the right shell for your Host OS
- `bash` for Linux
- `cmd` for Windows (powershell may or may not work)
```
git clone https://github.com/rmoorewrs/rpi4_demo.git
cd rpi4_demo
```

## Step 2: Edit the Setup Script
Edit the `01_setup_script` for your Host OS (Windows or Linux) to match your VxWorks and Desired IP settings

### Linux Users: 
- edit the file `01_setup_wrenv.sh`
- run the script
```
./01_setup_wrenv.sh
```
### Windows Users: 
- edit the file `01_setup_script.bat`
- run the script
```
01_setup_wrenv.bat
```
 Note: after running either script, you will be in a bash shell

## Step 3: Run the project creation script
You should now be in a bash shell, regardless of your Host OS.
- run the `02_create_rpi4.sh` script
```
./02_create_rpi4.sh
```
>Note: On Windows, this could take 45-60 minutes. On Linux (even WSL2), it should be considerably faster. 

## Step 4 (Optional): Import projects into Workbench
The `VSB` and `VIP` projects can be imported into Workbench and used from there. See `README.md` for details

