################################################################################
#
# mbedtls
#
################################################################################

ifeq ($(BR2_TARGET_TRUSTED_FIRMWARE_M_CUSTOM_3RD_PARTY),y)
TFM_MBEDTLS_VERSION = custom
TFM_MBEDTLS_TARBALL = $(call qstrip,$(BR2_TARGET_TFM_MBEDTLS_CUSTOM_TARBALL_LOCATION))
TFM_MBEDTLS_SITE = $(patsubst %/,%,$(dir $(TFM_MBEDTLS_TARBALL)))
TFM_MBEDTLS_SOURCE = $(notdir $(TFM_MBEDTLS_TARBALL))
BR_NO_CHECK_HASH_FOR += $(TFM_MBEDTLS_SOURCE)
else
TFM_MBEDTLS_VERSION = 3.6.0
TFM_MBEDTLS_SITE = https://github.com/Mbed-TLS/mbedtls/releases/download/v$(TFM_MBEDTLS_VERSION)
TFM_MBEDTLS_SOURCE = mbedtls-$(TFM_MBEDTLS_VERSION).tar.bz2
TFM_MBEDTLS_LICENSE = Apache-2.0 or GPL-2.0-or-later
TFM_MBEDTLS_LICENSE_FILES = LICENSE
endif

# This components is not built and installed, because it is intended to
# be included as source in TrustedFirmware-M build.

$(eval $(generic-package))
