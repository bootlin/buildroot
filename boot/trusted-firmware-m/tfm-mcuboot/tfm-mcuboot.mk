################################################################################
#
# mcuboot
#
################################################################################

ifeq ($(BR2_TARGET_TRUSTED_FIRMWARE_M_CUSTOM_3RD_PARTY),y)
TFM_MCUBOOT_VERSION = custom
TFM_MCUBOOT_TARBALL = $(call qstrip,$(BR2_TARGET_TFM_MCUBOOT_CUSTOM_TARBALL_LOCATION))
TFM_MCUBOOT_SITE = $(patsubst %/,%,$(dir $(TFM_MCUBOOT_TARBALL)))
TFM_MCUBOOT_SOURCE = $(notdir $(TFM_MCUBOOT_TARBALL))
BR_NO_CHECK_HASH_FOR += $(TFM_MCUBOOT_SOURCE)
else
TFM_MCUBOOT_VERSION = v2.1.0
TFM_MCUBOOT_SITE = $(call github,mcu-tools,mcuboot,$(TFM_MCUBOOT_VERSION))
TFM_MCUBOOT_LICENSE = Apache-2.0
TFM_MCUBOOT_LICENSE_FILES = LICENSE
endif

# This components is not built and installed, because it is intended to
# be included as source in TrustedFirmware-M build.

$(eval $(generic-package))
