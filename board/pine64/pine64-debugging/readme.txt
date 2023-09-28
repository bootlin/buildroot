Pine64

Intro
=====

This configuration supports the Pine A64+ Board with 2GB of RAM
platform:

  https://www.pine64.org/devices/single-board-computers/pine-a64/

How to build
============

 $ make pine64_debugging_defconfig
 $ make

How to write the microSD card
=============================

Once the build process is finished you will have an image called
"sdcard.img" in the output/images/ directory.

Copy the bootable "sdcard.img" onto an microSD card with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX

Boot the board
==============

 (1) Insert the microSD card in the micro SD card slot

 (2) Connect a USB to UART converter to the Exp bus header
     and point your communication program on /dev/ttyUSBxx.

 (3) Plug a USB cable to power-up the board.

 (4) The system will start, with the console on UART, but also visible
     on the screen.
