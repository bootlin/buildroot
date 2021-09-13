################################################################################
#
# edk2-images
#
################################################################################

EDK2_IMAGES_VERSION = 20210804.42.gcf7c650592
ifeq ($(BR2_PACKAGE_HOST_EDK2_IMAGES_IA32),y)
EDK2_IMAGES_ARCH = ia32
else
EDK2_IMAGES_ARCH = x64
endif
EDK2_IMAGES_SITE = https://www.kraxel.org/repos/jenkins/edk2
EDK2_IMAGES_SOURCE = edk2.git-ovmf-$(EDK2_IMAGES_ARCH)-0-$(EDK2_IMAGES_VERSION).noarch.rpm
EDK2_IMAGES_LICENSE = BSD-2-Clause-Patent

HOST_EDK2_IMAGES_INSTALL_DIR = $(HOST_DIR)/usr/share/ovmf-$(EDK2_IMAGES_ARCH)

HOST_EDK2_IMAGES_DEPENDENCIES = host-cpio

define HOST_EDK2_IMAGES_EXTRACT_CMDS
	$(HOST_EDK2_IMAGES_PKGDIR)/rpm2cpio.sh $(HOST_EDK2_IMAGES_DL_DIR)/$(HOST_EDK2_IMAGES_SOURCE) | \
		$(HOST_DIR)/bin/cpio -dimv -D $(@D)
endef

define HOST_EDK2_IMAGES_INSTALL_CMDS
	rm -rf $(HOST_EDK2_IMAGES_INSTALL_DIR)
	mkdir -p $(HOST_EDK2_IMAGES_INSTALL_DIR)
	cp -af $(@D)/usr/share/edk2.git/ovmf-$(EDK2_IMAGES_ARCH)/* $(HOST_EDK2_IMAGES_INSTALL_DIR)/
endef

$(eval $(host-generic-package))
