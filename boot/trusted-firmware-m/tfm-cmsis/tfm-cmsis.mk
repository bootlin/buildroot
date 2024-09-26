################################################################################
#
# cmcis
#
################################################################################

ifeq ($(BR2_TARGET_TRUSTED_FIRMWARE_M_CUSTOM_3RD_PARTY),y)
TFM_CMSIS_VERSION = custom
TFM_CMSIS_TARBALL = $(call qstrip,$(BR2_TARGET_TFM_CMSIS_CUSTOM_TARBALL_LOCATION))
TFM_CMSIS_SITE = $(patsubst %/,%,$(dir $(TFM_CMSIS_TARBALL)))
TFM_CMSIS_SOURCE = $(notdir $(TFM_CMSIS_TARBALL))
BR_NO_CHECK_HASH_FOR += $(TFM_CMSIS_SOURCE)
else
TFM_CMSIS_VERSION = d0c460c1697d210b49a4b90998195831c0cd325c
TFM_CMSIS_SITE = $(call github,arm-software,cmsis_6,$(TFM_CMSIS_VERSION))
TFM_CMSIS_LICENSE = Apache-2.0
TFM_CMSIS_LICENSE_FILES = LICENSE
endif

# This components is not built and installed, because it is intended to
# be included as source in TrustedFirmware-M build.

$(eval $(generic-package))
