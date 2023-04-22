= Linux Deployment Server Files

These files are basically all you need to run a Linux deployment server. There are 3 directories, each used by a separate service in the provisioning process:

== 0. Edit Makefile

You can edit the first 3 arguments in the Makefile to avoid passing parameters to `make` on the command line.

	LINUX_DISTRO := RHEL
	DISTRO_RELEASE := 9.2
	ISO_FILENAME := rhel-baseos-9.1-x86_64-dvd.iso

Edit these 3 values (assuming ISO_FILENAME is the name of a file in the ./iso directory) and you can just type

	make pxelinux
	make bootimgs
	make osrepo

== 1. Make PXE Loaders

The following really only needs to be done once. The rest of the steps you will repeat with each ISO you create (of the same architecture, e.g. x86_64)

	make ISO_FILENAME=rhel-baseos-9.1-x86_64-dvd.iso pxelinux

Will create the following files:

	pxelinux/pxelinux.0
	pxelinux/menu.c32
	pxelinux/ldlinux.c32
	pxelinux/libutil.c32
	pxelinux/libcom32.c32

These are the bootloaders needed to run the PXE boot and load `pxelinux/pxelinux.cfg/default`

== 2. Make Boot Images

	make ISO_FILENAME=rhel-baseos-9.1-x86_64-dvd.iso LINUX_DISTRO=RHEL DISTRO_RELEASE=9.1 bootimgs

Will create the following files:
	
	pxelinux/images/RHEL-9.1/vmlinuz
	pxelinux/images/RHEL-9.1/initrd.img

This will create the boot images needed for whatever OS is fed in in the ISO argument. For example if rhel-baseos-9.1-x86_64-dvd.iso

== 3. Make OS Repostitory Mirror

	make ISO_FILENAME=rhel-baseos-9.1-x86_64-dvd.iso LINUX_DISTRO=RHEL DISTRO_RELEASE=9.1 osrepo 

This will clone the installation DVD to the `./mirror` directory such that there is a file structure resemebling the following:

	mirror/RHEL-9.1/AppStream
	mirror/RHEL-9.1/BaseOS
	mirror/RHEL-9.1/EFI
	mirror/RHEL-9.1/EULA
	mirror/RHEL-9.1/GPL
	mirror/RHEL-9.1/RPM-GPG-KEY-redhat-beta
	mirror/RHEL-9.1/RPM-GPG-KEY-redhat-release
	mirror/RHEL-9.1/extra_files.json
	mirror/RHEL-9.1/images
	mirror/RHEL-9.1/isolinux
	mirror/RHEL-9.1/media.repo

== 4. Edit `pxelinux/pxelinux.cfg/default`

You'll now want to go in and add the boot options for the new OS you just added.
