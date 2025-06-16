################################################################################
#
# foo
#
################################################################################

BOOTLINLABS_BLAN_VERSION = 0.1
BOOTLINLABS_BLAN_SITE = $(CONFIG_DIR)/../target/blan
BOOTLINLABS_BLAN_SITE_METHOD = local
BOOTLINLABS_BLAN_LICENSE = GPL-2.0
BOOTLINLABS_BLAN_LICENSE_FILES = COPYING

$(eval $(kernel-module))
$(eval $(generic-package))
