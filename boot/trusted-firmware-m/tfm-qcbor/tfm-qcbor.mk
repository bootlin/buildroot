################################################################################
#
# qcbor
#
################################################################################

ifeq ($(BR2_TARGET_TRUSTED_FIRMWARE_M_CUSTOM_3RD_PARTY),y)
TFM_QCBOR_VERSION = custom
TFM_QCBOR_TARBALL = $(call qstrip,$(BR2_TARGET_TFM_QCBOR_CUSTOM_TARBALL_LOCATION))
TFM_QCBOR_SITE = $(patsubst %/,%,$(dir $(TFM_QCBOR_TARBALL)))
TFM_QCBOR_SOURCE = $(notdir $(TFM_QCBOR_TARBALL))
BR_NO_CHECK_HASH_FOR += $(TFM_QCBOR_SOURCE)
else
TFM_QCBOR_VERSION = v1.2
TFM_QCBOR_SITE = $(call github,laurencelundblade,qcbor,$(TFM_QCBOR_VERSION))
TFM_QCBOR_LICENSE = BSD-3-Clause
TFM_QCBOR_LICENSE_FILES = README.md
endif

# This components is not built and installed, because it is intended to
# be included as source in TrustedFirmware-M build.

$(eval $(generic-package))
