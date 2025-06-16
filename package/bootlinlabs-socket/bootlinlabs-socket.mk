################################################################################
#
# foo
#
################################################################################

BOOTLINLABS_SOCKET_VERSION = 0.1
BOOTLINLABS_SOCKET_SITE = $(CONFIG_DIR)/../target/lab3
BOOTLINLABS_SOCKET_SITE_METHOD = local
BOOTLINLABS_SOCKET_LICENSE = GPL-2.0
BOOTLINLABS_SOCKET_LICENSE_FILES = COPYING

define BOOTLINLABS_SOCKET_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) monitor
endef

define BOOTLINLABS_SOCKET_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/root/lab3/
	$(INSTALL) -D -m 0755 $(@D)/monitor $(TARGET_DIR)/root/lab3/
endef

$(eval $(generic-package))
