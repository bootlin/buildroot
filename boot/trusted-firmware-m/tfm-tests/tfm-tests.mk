################################################################################
#
# TF-M tests
#
################################################################################

ifeq ($(BR2_TARGET_TRUSTED_FIRMWARE_M_CUSTOM_3RD_PARTY),y)
TFM_TESTS_VERSION = custom
TFM_TESTS_TARBALL = $(call qstrip,$(BR2_TARGET_TFM_TESTS_CUSTOM_TARBALL_LOCATION))
TFM_TESTS_SITE = $(patsubst %/,%,$(dir $(TFM_TESTS_TARBALL)))
TFM_TESTS_SOURCE = $(notdir $(TFM_TESTS_TARBALL))
BR_NO_CHECK_HASH_FOR += $(TFM_TESTS_SOURCE)
else
TFM_TESTS_VERSION = TF-Mv2.1.0
TFM_TESTS_SITE = https://git.trustedfirmware.org/TF-M/trusted-firmware-m.git
TFM_TESTS_SITE_METHOD = git
TFM_TESTS_LICENSE = BSD-3-Clause
TFM_TESTS_LICENSE_FILES = license.rst
endif

# This components is not built and installed, because it is intended to
# be included as source in TrustedFirmware-M build.

$(eval $(generic-package))
