LINUX_DISTRO := RHEL
DISTRO_RELEASE := 9.1
ISO_FILENAME := rhel-baseos-9.1-x86_64-dvd.iso

REPO_DIR := ./mirror
TFTP_ROOT := ./pxelinux

ISO_DIR := ./iso
BOOT_IMAGES := $(TFTP_ROOT)/images
RELEASE_SHORTNAME := $(LINUX_DISTRO)-$(DISTRO_RELEASE)

pxelinux:
	DIST_TYPE=$(. /etc/os-release; echo $ID_LIKE | tr '[:upper:]' '[:lower:]')
	[ DIST_TYPE -eq 'debian' ] && apt install -y rpm2cpio
	mount -o loop,ro -t iso9660 $(ISO_DIR)/$(ISO_FILE) /media
	cd /tmp && find /media -regex '.*syslinux-tftpboot.*noarch.rpm' | xargs rpm2cpio | cpio -dimv
	cp /tmp/tftpboot/{pxelinux.0,menu.c32,ldlinux.c32,libutil.c32,libcom32.c32} $(TFTPROOT)/
	umount /media
bootimgs:
	mount -o loop,ro -t iso9660 $(ISO_DIR)/$(ISO_FILE) /media
	mkdir -p $(BOOT_IMAGES)/$(RELEASE_SHORTNAME)
	cp /media/images/pxeboot/vmlinuz $(BOOT_IMAGES)/$(RELEASE_SHORTNAME)
	cp /media/images/pxeboot/initrd.img $(BOOT_IMAGES)/$(RELEASE_SHORTNAME)
	touch $(BOOT_IMAGES)/$(RELEASE_SHORTNAME)/.gitignore
	umount /media
osrepo:
	mount -o loop,ro -t iso9660 $(ISO_DIR)/$(ISO_FILE) /media
	mkdir -p $(REPO_DIR)/$(RELEASE_SHORTNAME)
	cp -r /media/* $(REPO_DIR)/$(RELEASE_SHORTNAME)/
	touch $(REPO_DIR)/$(RELEASE_SHORTNAME)/.gitignore
	umount /media
