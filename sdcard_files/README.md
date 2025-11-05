# Setting up microSD card for RPI4

### Step 1: prepare a microSD card
- card size doesn't matter, no much space is required
- format the card with FAT32 filesystem

### Step 2: Copy the files in this directory to the root directory on the microSD card


### Step 3: (optional) create a custom u-boot script 
Edit the contents of boot.cmd and then create the boot script image like this:

```
mkimage -c none -A arm -T script -d boot.cmd boot.scr.uimg
```

> Note: you need to install the Debian package `u-boot-tools` in order to get mkimage

With the RPI4 and a microSD card, you can also just edit the u-boot env variables and do a `saveenv`

