################################################################################
#
# TrustedFirmware-M
#
################################################################################

TRUSTED_FIRMWARE_M_VERSION = $(call qstrip,$(BR2_TARGET_TRUSTED_FIRMWARE_M_VERSION))

ifeq ($(BR2_TARGET_TRUSTED_FIRMWARE_M_CUSTOM_TARBALL),y)
# Handle custom FT-M tarballs as specified by the configuration
TRUSTED_FIRMWARE_M_TARBALL = $(call qstrip,$(BR2_TARGET_TRUSTED_FIRMWARE_M_CUSTOM_TARBALL_LOCATION))
TRUSTED_FIRMWARE_M_SITE = $(patsubst %/,%,$(dir $(TRUSTED_FIRMWARE_M_TARBALL)))
TRUSTED_FIRMWARE_M_SOURCE = $(notdir $(TRUSTED_FIRMWARE_M_TARBALL))
else ifeq ($(BR2_TARGET_TRUSTED_FIRMWARE_M_CUSTOM_GIT),y)
TRUSTED_FIRMWARE_M_SITE = $(call qstrip,$(BR2_TARGET_TRUSTED_FIRMWARE_M_CUSTOM_REPO_URL))
TRUSTED_FIRMWARE_M_SITE_METHOD = git
else
# Handle stable official TF-M versions
TRUSTED_FIRMWARE_M_SITE = https://git.trustedfirmware.org/TF-M/trusted-firmware-m.git
TRUSTED_FIRMWARE_M_SITE_METHOD = git
# The licensing of custom or from-git versions is unknown.
# This is valid only for the latest (i.e. known) version.
ifeq ($(BR2_TARGET_TRUSTED_FIRMWARE_M_LATEST_VERSION),y)
TRUSTED_FIRMWARE_M_LICENSE = BSD-3-Clause
TRUSTED_FIRMWARE_M_LICENSE_FILES = license.rst
endif
endif

ifeq ($(BR2_TARGET_TRUSTED_FIRMWARE_M):$(BR2_TARGET_TRUSTED_FIRMWARE_M_CUSTOM_VERSION)$(BR2_TARGET_TRUSTED_FIRMWARE_M_CUSTOM_TARBALL)$(BR2_TARGET_TRUSTED_FIRMWARE_M_CUSTOM_GIT),y:y)
BR_NO_CHECK_HASH_FOR += $(TRUSTED_FIRMWARE_M_SOURCE)
endif

TRUSTED_FIRMWARE_M_DEPENDENCIES += \
	$(BR2_CMAKE_HOST_DEPENDENCY) \
	host-arm-gnu-toolchain \
	host-python-cbor2 \
	host-python-click \
	host-python-cryptography \
	host-python-jinja2 \
	host-python-intelhex \
	host-python-pyyaml

TRUSTED_FIRMWARE_M_PATCH_DEPENDENCIES += \
	tfm-mbedtls \
	tfm-mcuboot \
	tfm-qcbor \
	tfm-cmsis \
	tfm-tests

define TRUSTED_FIRMWARE_M_PATCH_3RD_PARTIES
	if [ -d $(@D)/lib/ext/cmsis ]; then \
		$(APPLY_PATCHES) $(TFM_CMSIS_SRCDIR) $(@D)/lib/ext/cmsis \*.patch; \
	fi
	$(APPLY_PATCHES) $(TFM_MBEDTLS_SRCDIR) $(@D)/lib/ext/mbedcrypto \*.patch; \
	$(APPLY_PATCHES) $(TFM_MCUBOOT_SRCDIR) $(@D)/lib/ext/mcuboot \*.patch; \
	$(APPLY_PATCHES) $(TFM_QCBOR_SRCDIR) $(@D)/lib/ext/qcbor \*.patch; \
	$(APPLY_PATCHES) $(TFM_TESTS_SRCDIR) $(@D)/lib/ext/tf-m-tests \*.patch;
endef
TRUSTED_FIRMWARE_M_POST_PATCH_HOOKS += TRUSTED_FIRMWARE_M_PATCH_3RD_PARTIES

TRUSTED_FIRMWARE_M_CONF_OPTS += \
	-DCMAKE_TOOLCHAIN_FILE="$(HOST_DIR)/share/buildroot/toolchainfile.cmake" \
	-DFETCHCONTENT_FULLY_DISCONNECTED=ON \
	-DMBEDCRYPTO_PATH=$(TFM_MBEDTLS_SRCDIR) \
	-DTFM_TEST_REPO_PATH=$(TFM_TESTS_SRCDIR) \
	-DMCUBOOT_PATH=$(TFM_MCUBOOT_SRCDIR) \
	-DQCBOR_PATH=$(TFM_QCBOR_SRCDIR) \
	-DCMSIS_PATH=$(TFM_CMSIS_SRCDIR) \
	-DTFM_PLATFORM=$(call qstrip,$(BR2_TARGET_TRUSTED_FIRMWARE_M_PLATFORM))

ifeq ($(BR2_TARGET_TRUSTED_FIRMWARE_M_DEBUG),y)
TRUSTED_FIRMWARE_M_CONF_OPTS += -DCMAKE_BUILD_TYPE=Debug
endif

TRUSTED_FIRMWARE_M_CONF_ENV += \
	CROSS_COMPILE=$(HOST_DIR)/bin/arm-none-eabi-

define TRUSTED_FIRMWARE_M_CONFIGURE_CMDS
	rm -f $(@D)/CMakeCache.txt
	PATH=$(BR_PATH) \
	$(TRUSTED_FIRMWARE_M_CONF_ENV) $(BR2_CMAKE) -S $(@D) -B $(@D) \
		$(TRUSTED_FIRMWARE_M_CONF_OPTS) \
		$(call qstrip,$(BR2_TARGET_TRUSTED_FIRMWARE_M_ADDITIONAL_VARIABLES))
endef

define TRUSTED_FIRMWARE_M_BUILD_CMDS
	PATH=$(BR_PATH) \
	$(TRUSTED_FIRMWARE_M_CONF_ENV) $(BR2_CMAKE) \
		--build $(@D) -- install
endef

define TRUSTED_FIRMWARE_M_INSTALL_TARGET_CMDS
	# Install path for old version of TF-M
	if [ -d $(@D)/install/outputs ]; then \
		$(INSTALL) -D -m 0755 $(@D)/install/outputs/*.bin $(BINARIES_DIR); \
		$(INSTALL) -D -m 0755 $(@D)/install/outputs/*.elf $(BINARIES_DIR); \
	else \
		$(INSTALL) -D -m 0755 $(@D)/api_ns/bin/*.bin $(BINARIES_DIR); \
		$(INSTALL) -D -m 0755 $(@D)/api_ns/bin/*.elf $(BINARIES_DIR); \
	fi
endef

# Configuration check
ifeq ($(BR2_TARGET_TRUSTED_FIRMWARE_M)$(BR_BUILDING),yy)

ifeq ($(BR2_TARGET_TRUSTED_FIRMWARE_M_CUSTOM_TARBALL),y)
ifeq ($(call qstrip,$(BR2_TARGET_TRUSTED_FIRMWARE_M_CUSTOM_TARBALL_LOCATION)),)
$(error No tarball location specified. Please check BR2_TARGET_TRUSTED_FIRMWARE_M_CUSTOM_TARBALL_LOCATION)
endif
endif

ifeq ($(BR2_TARGET_TRUSTED_FIRMWARE_M_CUSTOM_GIT),y)
ifeq ($(call qstrip,$(BR2_TARGET_TRUSTED_FIRMWARE_M_CUSTOM_REPO_URL)),)
$(error No repository specified. Please check BR2_TARGET_TRUSTED_FIRMWARE_M_CUSTOM_REPO_URL)
endif
endif

endif

$(eval $(generic-package))
