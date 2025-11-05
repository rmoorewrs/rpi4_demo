# VxWorks demo scripts for Raspberry Pi 4
Rich Moore (rmoorewrs at gmail.com)

This is a set of scripts that will build VxWorks projects that can be loaded and run on a Raspberry Pi 4

## Prerequisites: 
- Valid VxWorks 25.09 installation and active license
- Raspberry Pi 4 with a heatsink and/or fan on the CPU
- USB serial adapter with connectors that can fit onto the RPI4 GPIO pins
    - https://www.amazon.com/dp/B07B5TP67V works well

- FAT32 microSD
- tftp server
- this git repo


---

## Instructions:

### 1) Clone this project and enter the project directory

```
git clone https://github.com/rmoorewrs/rpi4_demo.git
cd rpi4_demo
./00_runme_first.sh
```
>Note: 
- edit the `project_params.sh` script to match your VxWorks installation path, IP addresses, etc

### 2) Set up the environment variables for VxWorks

After editing `project_parameters` run the environment variable setup script
```
./01_set_wrenv.sh
```

 Alternately, run 
 ```
 <path-to-vxworks-install>/wrenv.sh -p vxworks/25.09     # use your path, your version
 ```

### 3) Run the RPI4 project creation script
```
./02_create_rpi4.sh
```
This script creates and configures the VxWorks Source Build and VxWorks Image Project needed to create a kernel image capable of booting on the RPI4. 


### 4) Optional: import the VSB and VIP projects into Workbench. 
Open Workbench and select the `build` directory as the workspace. It will be empty initially, so you must import these projects:
- rpi4-vsb
- rpi4-vip

To import in workbench, do the following (best practice to import the VSBs first):
```
File->Import->VxWorks->VxWorks VSB
Browse to the VSB project
Select the VSB project

File->Import->VxWorks->VxWorks VIP
Browse to the VIP
Select the VIP project
```

### 5) tftp Booting from u-boot
```
tftpboot 0x100000 uVxWorks_rpi4
bootm 0x100000
```


---

## Making edit->build->test easier
If you've imported the projects into Workbench, you can add a command to the `.wrmakefile` in the VIP that will automatically copy the `uVxWorks` file to your tftp server. 

First, open `.wrmakefile` in the VxWorks Image Project directory.

Search for `deploy_output` in `.wrmakefile` and add your OS copy commands. Note that the extra copy commands will persist only as long as you do `Build Project` in Workbench. If you do a `Rebuild Project` they'll be wiped out, since `.wrmakefile` gets refreshed.

```
# entry point for deploying output after the build
deploy_output ::
	@echo "deploy_output"
	cp default/uVxWorks /tftpboot/uVxWorks_rpi4
```
---



