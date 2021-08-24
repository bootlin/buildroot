################################################################################
#
# grub2
#
################################################################################

GRUB2_VERSION = 2.04
GRUB2_SITE = http://ftp.gnu.org/gnu/grub
GRUB2_SOURCE = grub-$(GRUB2_VERSION).tar.xz
GRUB2_LICENSE = GPL-3.0+
GRUB2_LICENSE_FILES = COPYING
GRUB2_DEPENDENCIES = host-bison host-flex host-grub2
HOST_GRUB2_DEPENDENCIES = host-bison host-flex
GRUB2_INSTALL_IMAGES = YES

# 0001-build-Fix-GRUB-i386-pc-build-with-Ubuntu-gcc.patch and 2021/03/02
# security fixes (patches 0029-0149)
define GRUB2_AVOID_AUTORECONF
	$(Q)touch $(@D)/Makefile.util.am
	$(Q)touch $(@D)/aclocal.m4
	$(Q)touch $(@D)/Makefile.in
	$(Q)touch $(@D)/configure
endef
GRUB2_POST_PATCH_HOOKS += GRUB2_AVOID_AUTORECONF
HOST_GRUB2_POST_PATCH_HOOKS += GRUB2_AVOID_AUTORECONF

# 0002-yylex-Make-lexer-fatal-errors-actually-be-fatal.patch
GRUB2_IGNORE_CVES += CVE-2020-10713
# 0005-calloc-Use-calloc-at-most-places.patch
GRUB2_IGNORE_CVES += CVE-2020-14308
# 0006-malloc-Use-overflow-checking-primitives-where-we-do-.patch
GRUB2_IGNORE_CVES += CVE-2020-14309 CVE-2020-14310 CVE-2020-14311
# 0019-script-Avoid-a-use-after-free-when-redefining-a-func.patch
GRUB2_IGNORE_CVES += CVE-2020-15706
# 0028-linux-Fix-integer-overflows-in-initrd-size-handling.patch
GRUB2_IGNORE_CVES += CVE-2020-15707
# 2021/03/02 security fixes - patches 0029-0149
GRUB2_IGNORE_CVES += CVE-2020-25632 CVE-2020-25647 CVE-2020-27749 \
	CVE-2020-27779 CVE-2021-3418 CVE-2021-20225 CVE-2021-20233
# 0039-acpi-Don-t-register-the-acpi-command-when-locked-dow.patch
GRUB2_IGNORE_CVES += CVE-2020-14372
# CVE-2019-14865 is about a flaw in the grub2-set-bootflag tool, which
# doesn't exist upstream, but is added by the Redhat/Fedora
# packaging. Not applicable to Buildroot.
GRUB2_IGNORE_CVES += CVE-2019-14865
# CVE-2020-15705 is related to a flaw in the use of the
# grub_linuxefi_secure_validate(), which was added by Debian/Ubuntu
# patches. The issue doesn't affect upstream Grub, and
# grub_linuxefi_secure_validate() is not implemented in the grub2
# version available in Buildroot.
GRUB2_IGNORE_CVES += CVE-2020-15705

ifeq ($(BR2_TARGET_GRUB2_INSTALL_TOOLS),y)
GRUB2_INSTALL_TARGET = YES
else
GRUB2_INSTALL_TARGET = NO
endif
GRUB2_CPE_ID_VENDOR = gnu

GRUB2_BUILTIN_MODULES_PC = $(call qstrip,$(BR2_TARGET_GRUB2_BUILTIN_MODULES_PC))
GRUB2_BUILTIN_MODULES_EFI = $(call qstrip,$(BR2_TARGET_GRUB2_BUILTIN_MODULES_EFI))
GRUB2_BUILTIN_CONFIG_PC = $(call qstrip,$(BR2_TARGET_GRUB2_BUILTIN_CONFIG_PC))
GRUB2_BUILTIN_CONFIG_EFI = $(call qstrip,$(BR2_TARGET_GRUB2_BUILTIN_CONFIG_EFI))
GRUB2_BOOT_PARTITION = $(call qstrip,$(BR2_TARGET_GRUB2_BOOT_PARTITION))

ifeq ($(BR2_TARGET_GRUB2_I386_PC),y)
GRUB2_I386_PC_IMAGE = $(BINARIES_DIR)/grub.img
GRUB2_I386_PC_CFG = $(TARGET_DIR)/boot/grub/grub.cfg
GRUB2_I386_PC_PREFIX = ($(GRUB2_BOOT_PARTITION))/boot/grub
GRUB2_I386_PC_TARGET = i386
GRUB2_I386_PC_PLATFORM = pc
GRUB2_I386_PC_BUILTIN = PC
GRUB2_TUPLES += i386-pc
endif
ifeq ($(BR2_TARGET_GRUB2_I386_EFI),y)
GRUB2_I386_EFI_IMAGE = $(BINARIES_DIR)/efi-part/EFI/BOOT/bootia32.efi
GRUB2_I386_EFI_CFG = $(BINARIES_DIR)/efi-part/EFI/BOOT/grub.cfg
GRUB2_I386_EFI_PREFIX = /EFI/BOOT
GRUB2_I386_EFI_TARGET = i386
GRUB2_I386_EFI_PLATFORM = efi
GRUB2_I386_EFI_BUILTIN = EFI
GRUB2_TUPLES += i386-efi
endif
ifeq ($(BR2_TARGET_GRUB2_X86_64_EFI),y)
GRUB2_X86_64_EFI_IMAGE = $(BINARIES_DIR)/efi-part/EFI/BOOT/bootx64.efi
GRUB2_X86_64_EFI_CFG = $(BINARIES_DIR)/efi-part/EFI/BOOT/grub.cfg
GRUB2_X86_64_EFI_PREFIX = /EFI/BOOT
GRUB2_X86_64_EFI_TARGET = x86_64
GRUB2_X86_64_EFI_PLATFORM = efi
GRUB2_X86_64_EFI_BUILTIN = EFI
GRUB2_TUPLES += x86_64-efi
endif
ifeq ($(BR2_TARGET_GRUB2_ARM_UBOOT),y)
GRUB2_ARM_UBOOT_IMAGE = $(BINARIES_DIR)/boot-part/grub/grub.img
GRUB2_ARM_UBOOT_CFG = $(BINARIES_DIR)/boot-part/grub/grub.cfg
GRUB2_ARM_UBOOT_PREFIX = ($(GRUB2_BOOT_PARTITION))/boot/grub
GRUB2_ARM_UBOOT_TARGET = arm
GRUB2_ARM_UBOOT_PLATFORM = uboot
GRUB2_ARM_UBOOT_BUILTIN = PC
GRUB2_TUPLES += arm-uboot
endif
ifeq ($(BR2_TARGET_GRUB2_ARM_EFI),y)
GRUB2_ARM_EFI_IMAGE = $(BINARIES_DIR)/efi-part/EFI/BOOT/bootarm.efi
GRUB2_ARM_EFI_CFG = $(BINARIES_DIR)/efi-part/EFI/BOOT/grub.cfg
GRUB2_ARM_EFI_PREFIX = /EFI/BOOT
GRUB2_ARM_EFI_TARGET = arm
GRUB2_ARM_EFI_PLATFORM = efi
GRUB2_ARM_EFI_BUILTIN = EFI
GRUB2_TUPLES += arm-efi
endif
ifeq ($(BR2_TARGET_GRUB2_ARM64_EFI),y)
GRUB2_ARM64_EFI_IMAGE = $(BINARIES_DIR)/efi-part/EFI/BOOT/bootaa64.efi
GRUB2_ARM64_EFI_CFG = $(BINARIES_DIR)/efi-part/EFI/BOOT/grub.cfg
GRUB2_ARM64_EFI_PREFIX = /EFI/BOOT
GRUB2_ARM64_EFI_TARGET = aarch64
GRUB2_ARM64_EFI_PLATFORM = efi
GRUB2_ARM64_EFI_BUILTIN = EFI
GRUB2_TUPLES += arm64-efi
endif

# Grub2 is kind of special: it considers CC, LD and so on to be the
# tools to build the host programs and uses TARGET_CC, TARGET_CFLAGS,
# TARGET_CPPFLAGS, TARGET_LDFLAGS to build the bootloader itself.
#
# NOTE: TARGET_STRIP is overridden by !BR2_STRIP_strip, so always
# use the cross compile variant to ensure grub2 builds

HOST_GRUB2_CONF_ENV = \
	CPP="$(HOSTCC) -E"

GRUB2_CONF_ENV = \
	CPP="$(TARGET_CC) -E" \
	TARGET_CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	TARGET_CFLAGS="$(TARGET_CFLAGS) -Os" \
	CPPFLAGS="$(TARGET_CPPFLAGS) -Os -fno-stack-protector" \
	TARGET_CPPFLAGS="$(TARGET_CPPFLAGS) -Os -fno-stack-protector" \
	TARGET_LDFLAGS="$(TARGET_LDFLAGS) -Os" \
	TARGET_NM="$(TARGET_NM)" \
	TARGET_OBJCOPY="$(TARGET_OBJCOPY)" \
	TARGET_STRIP="$(TARGET_CROSS)strip"

GRUB2_CONF_OPTS = \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--target=$(GRUB2_$(call UPPERCASE,$(tuple))_TARGET) \
	--with-platform=$(GRUB2_$(call UPPERCASE,$(tuple))_PLATFORM) \
	--prefix=/ \
	--exec-prefix=/ \
	--disable-grub-mkfont \
	--enable-efiemu=no \
	ac_cv_lib_lzma_lzma_code=no \
	--enable-device-mapper=no \
	--enable-libzfs=no \
	--disable-werror

HOST_GRUB2_CONF_OPTS = \
	--disable-grub-mkfont \
	--enable-efiemu=no \
	ac_cv_lib_lzma_lzma_code=no \
	--enable-device-mapper=no \
	--enable-libzfs=no \
	--disable-werror

define GRUB2_CONFIGURE_CMDS
	$(foreach tuple, $(GRUB2_TUPLES), \
		mkdir -p $(@D)/build-$(tuple) ; \
		cd $(@D)/build-$(tuple) ; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		$(GRUB2_CONF_ENV) \
		../configure \
			$(GRUB2_CONF_OPTS)
	)
endef

define GRUB2_BUILD_CMDS
	$(foreach tuple, $(GRUB2_TUPLES), \
		$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/build-$(tuple)
	)
endef

define GRUB2_INSTALL_IMAGES_CMDS
	$(foreach tuple, $(GRUB2_TUPLES), \
		mkdir -p $(dir $(GRUB2_$(call UPPERCASE,$(tuple))_IMAGE)) ; \
		$(HOST_DIR)/usr/bin/grub-mkimage \
			-d $(@D)/build-$(tuple)/grub-core/ \
			-O $(tuple) \
			-o $(GRUB2_$(call UPPERCASE,$(tuple))_IMAGE) \
			-p "$(GRUB2_$(call UPPERCASE,$(tuple))_PREFIX)" \
			$(if $(GRUB2_BUILTIN_CONFIG_$(GRUB2_$(call UPPERCASE,$(tuple))_BUILTIN)), \
				-c $(GRUB2_BUILTIN_CONFIG_$(GRUB2_$(call UPPERCASE,$(tuple))_BUILTIN))) \
			$(GRUB2_BUILTIN_MODULES_$(GRUB2_$(call UPPERCASE,$(tuple))_BUILTIN)) ; \
		$(INSTALL) -D -m 0644 boot/grub2/grub.cfg $(GRUB2_$(call UPPERCASE,$(tuple))_CFG) ; \
		$(if $(findstring $(GRUB2_$(call UPPERCASE,$(tuple))_PLATFORM), pc), \
			cat $(HOST_DIR)/lib/grub/$(tuple)/cdboot.img $(GRUB2_$(call UPPERCASE,$(tuple))_IMAGE) > \
				$(BINARIES_DIR)/grub-eltorito.img, \
		) \
		$(if $(findstring $(GRUB2_$(call UPPERCASE,$(tuple))_PLATFORM), efi), \
			echo $(notdir $(GRUB2_$(call UPPERCASE,$(tuple))_IMAGE)) > \
				$(BINARIES_DIR)/efi-part/startup.nsh \
		)
	)
endef

$(eval $(generic-package))
$(eval $(host-autotools-package))
