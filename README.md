# VxWorks demo scripts AMD Kria rpi4 Starter Kit
Rich Moore (rmoorewrs at gmail.com)

This is a set of scripts that will build VxWorks projects that can be loaded on an AMD Kria rpi4 starter kit. 

## Prerequisites: 
- Valid VxWorks 25.09 installation and active license
- rpi4 with serial adapter
- FAT32 microSD with RPI4 firmware, u-boot,etc (see notes)
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

### 3) Run the A53 creation script (Case 1)
```
./02_create_vsb_vip.sh
```
This script patches the A53 DTS file to add the generic memory device, enable Ethernet on the A53 and disable UART on the A53. If you want to run the A53 cores alone (i.e. no R5) then you need to **edit the DTS file to enable the UART for the A53 cores.**  


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
tftpboot 0x100000 vxWorks_rpi4.bin
go 0x100000
```


---

## Making edit->build->test easier
If you've imported the projects into Workbench, you can add a command to the `.wrmakefile` in the VIP that will automatically copy the `vxWorks.bin` file to your tftp server. 

First, open `.wrmakefile` in the VxWorks Image Project directory.

Search for `deploy_output` in `.wrmakefile` and add your OS copy commands. Note that the extra copy commands will persist only as long as you do `Build Project` in Workbench. If you do a `Rebuild Project` they'll be wiped out, since `.wrmakefile` gets refreshed.

```
# entry point for deploying output after the build
deploy_output ::
	@echo "deploy_output"
	cp default/vxWorks.bin /tftpboot/vxWorks_a53.bin
```
---



