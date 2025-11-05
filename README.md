# VxWorks demo scripts for Raspberry Pi 4
Rich Moore (rmoorewrs at gmail.com)

This is a set of scripts that will build VxWorks projects that can be loaded and run on a Raspberry Pi 4

## Prerequisites: 
- Valid VxWorks 25.09 installation and active license
- Raspberry Pi 4 with a heatsink and/or fan on the CPU
- USB serial adapter with connectors that can fit onto the RPI4 GPIO pins
    - https://www.amazon.com/dp/B07B5TP67V works well
    - see the Appendix on how to wire the GPIO for serial. 
- FAT32 microSD
- tftp server
    - Ethernet cable connected to network
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

### 3) Run the RPI4 VxWorks project creation script
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

> Time-saving Tip:
> If you've imported the projects into Workbench, you can add a command to the `.wrmakefile` in the VIP that will automatically copy the `uVxWorks` file to your tftp server. 
>
> First, open `.wrmakefile` in the VxWorks Image Project directory.
>
> Search for `deploy_output` in `.wrmakefile` and add your OS copy commands. Note that the extra copy commands will persist only as long as you do `Build Project` in Workbench. If you do a `Rebuild Project` the files may be refreshed and you'll have to reapply.

```
# entry point for deploying output after the build
deploy_output ::
	@echo "deploy_output"
	cp default/uVxWorks /tftpboot/uVxWorks_rpi4
```

### 5) Prepare the microSD boot device
- Format a microSD card with FAT32 filesystem
- If you've built your own u-boot, add that along with the additional RPI4 boot files to the root directory of the microSD Card.
- otherwise, copy the contents of `sdcard_files` to the root directory of the microSD card.
- The root directory of the microSD should look something like this:
```
bcm2711-rpi-4-b.dtb
boot.cmd
boot.scr.uimg
config.txt
fixup4.dat
README.md
rpi-4b.dtb
start4.elf
u-boot.bin
uboot.env
```


### 6) Boot via tftp using u-boot
Using the tftp boot method is great for a rapid development cycle. 
Insert the microSD card into the RPI4 and apply power to boot. Hit a key to enter u-boot. Enther the IP addresses for your setup: 
```
setenv ipaddr 192.168.12.32
setenv netmask 255.255.255.0
setenv serverip 192.168.12.51

tftpboot 0x100000 uVxWorks_rpi4
bootm 0x100000
```

### 7) Alternately, you can boot from an image on the microSD card
When you're ready to deploy, copy the `default/uVxWorks` to the root directory of the microSD card

Set up the following `bootcmd` in u-boot
```
fatload mmc 0:1 0x100000 uVxWorks
bootm 0x100000
```


---

## Appendix:  Attach Serial Port to GPIO

- Note that Raspberry Pi GPIO pins are 3.3V
	- Connecting to 5V will damage the board 
- easiest solution is an FTDI USB RS232 cable with GND,TX, RX connections
- Recommended Cable: FTDI chipset USB/232 adapters on Amazon 
  https://www.amazon.com/dp/B07B5TP67V
  
![](https://github.com/rmoorewrs/rpi4_demo/blob/main/pics/vxworks-on-rpi4-1740068768847.webp)


Here is the Raspberry Pi GPIO Layout, we're using the 3 pins near the top right: Pin 6 (Ground), Pin 8 (UART TX) and PIN 10 (UART RX)

![](https://github.com/rmoorewrs/rpi4_demo/blob/main/pics/vxworks-on-rpi4-1740068990218.webp)


### FTDI USB/Serial Cable to RPI GPIO Pinout

| Function | GPIO Name | GPIO Pin | Comment                | FTDI Wire Color |
| -------- | --------- | -------- | ---------------------- | --------------- |
| GND      | Ground    | 6        | many other pin options | Black           |
| TX       | GPIO 14   | 8        | UART TX                | White           |
| RX       | GPIO 15   | 10       | UART RX                | Green           |

### Optional: Glue the Single Pin Connectors Together

![](https://github.com/rmoorewrs/rpi4_demo/blob/main/pics/vxworks-on-rpi4-1740071287468.webp)

In the photo above, I wrapped cotton thread around the 3 pin connectors and added a drop of superglue. 

***Be careful***: it's easy to ruin the connectors with too much superglue! 

***Tip:*** squirt out a drop of superglue onto a piece of wax paper, silicone mat, etc and then add tiny amounts to the thread with a toothpick.

### Optional: Tie Back the Additional Wires with Heatshrink Tubing

Since you're only using 3 of the connectors on the FTDI/USB serial cable, the extra connectors can get in the way. Rather than cut the extras off (which runs the risk shorting something) I used a piece of heatshrink tubing to hold the extra connectors out of the way. This is completely non-destructive and allows you to potentially use the other signals in the future. 

![](https://github.com/rmoorewrs/rpi4_demo/blob/main/pics/vxworks-on-rpi4-1740071944476.webp)


### Optional: Wire tie the serial cable to the RPI4 case
This will help prevent accidental removal of the pins. Here's an example:
![](https://github.com/rmoorewrs/rpi4_demo/blob/main/pics/rpi4-with-serial-cabletied.jpeg)


## Additional Notes:
Useful tutorial on building rpi4 toolchain here (but I didn't get this one working):
https://hechao.li/2021/12/20/Boot-Raspberry-Pi-4-Using-uboot-and-Initramfs/

This tutorial was actually better, and I got u-boot up and running:
https://danmc.net/posts/raspberry-pi-4-b-u-boot/

If you use to WR Linux LTS (located here on GitHub https://github.com/WindRiverLinux24), building `u-boot` is easy.
```
$ mkdir u-boot-rpi4 && cd u-boot-rpi4
$ git clone --branch WRLINUX_10_24_LTS https://github.com/WindRiverLinux24/wrlinux-x
$ ./wrlinux-x/setup.sh --machines bcm-2xxx-rpi4 --accept-eula=yes
$ . ./environment-setup-x86_64-wrlinuxsdk-linux 	// optional, forces the build of local host tools
$ . ./oe-init-build-env [build-name-date]
$ bitbake u-boot
```

The output will be located in `<build_dir>/tmp-glibc/deploy/images/bcm-2xxx-rpi4/u-boot.bin`


---

# Appendix: Building VxWorks for the RPI4 using Workbench

## 1. Build the VxWorks VSB for RPI4
- Open Workbench 4/VxWorks 7 and create a VSB for the RPI4
	- name it something like `rpi4-vsb`
- for the BSP, select `rpi_4_xxxxxx` like this and hit `Finish`:
  
![](https://github.com/rmoorewrs/rpi4_demo/blob/main/pics/vxworks-on-rpi4-1739894945435.webp)

- Build the VSB, you shouldn't get any errors

## 2. Create, Configure and Build the VIP based on the VSB

- In Workbench, create a VxWorks Image Project (VIP)based on the above VSB
	- name it something like `rpi4-vip`
- Choose "Based on a source build project", select the previous `rpi4-vsb` and hit `Finish`
	- We'll customize in the next step
 
![](https://github.com/rmoorewrs/rpi4_demo/blob/main/pics/vxworks-on-rpi4-1739895265814.webp)


### 2.1 Configure the VIP project
- open the VIP project `Kernel Configuration` tool

#### 2.1.0 Add the Target Shell Bundle
- Select the `Bundles` Tab in the middle of the screen like this and add the `Standalone kernel Shell` bundle by right-clicking and hitting `Add`:

![](https://github.com/rmoorewrs/rpi4_demo/blob/main/pics/vxworks-on-rpi4-1739895693630.webp)
 
 - return to the `Components` Tab
 
#### 2.1.1 Set the Console Baud Rate
- hit `Ctrl-F` to search for `CONSOLE_BAUD_RATE` and set it to your desired rate
- Default is 115200

#### 2.1.2 Enable Built-in DTB mode
- In the kernel configurator tool, hit `Ctrl-F` and search for `STANDALONE_DTB`
- Right-click to include the feature (`INCLUDE_STANDALONE_DTB`)
- board won't boot properly without this feature

#### 2.1.3 Configure the Network
- Search for `GENETv5` and include `DRV_END_FDT_BCM_GENETv5`
- Search for `IFCONFIG_1` and set the value string similar to this:

```
"ifname genet0","devname genet0","gateway 192.168.12.1","inet 192.168.12.35/24"

or

"ifname genet0","devname genet0","gateway dhcp","inet dhcp"
```

![](https://github.com/rmoorewrs/rpi4_demo/blob/main/pics/vxworks-on-rpi4-1740086052356.webp)



#### 2.1.4 Optional: add utility features like ping
Use `Ctrl-F` to search for each of these, select the feature, hit `FIND` and then right-click the feature to `Add`
- `ping (FOLDER_PING)` enables network ping
- `ifconfig (INCLUDE_IFCONFIG)` enables setting IP address
- `routec (INCLUDE_ROUTECMD)` change IP routing
- `telnet (FOLDER_TELNET)` add `INCLUDE IPTELNETS` to enable telnet server
- `DHCP client (INCLUDE_IPDHPCC)` to enable DHCP client

Note: this will add the utilities to the VxWorks C Shell. In order to add them to the bash-like CMD shell, you need to add the corresponding `IPCOM` feature. For example, to add `ping` to the CMD shell, you must select and add `INCLUDE_IPPING_CMD`


