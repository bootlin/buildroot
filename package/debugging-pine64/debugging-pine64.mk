################################################################################
#
# debugging-pine64
#
################################################################################

DEBUGGING_PINE64_VERSION = 1.0
DEBUGGING_PINE64_SITE = board/pine64/pine64-debugging/source
DEBUGGING_PINE64_SITE_METHOD = local



define DEBUGGING_PINE64_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) $(@D)/sched_intensive/sched_intensive.c -o $(@D)/sched_intensive/sched_intensive
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) $(@D)/strace/strace_me.c -o $(@D)/strace/strace_me
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) $(@D)/mmc/mmc_reader.c -o $(@D)/mmc/mmc_reader
endef

define DEBUGGING_PINE64_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/sched_intensive/sched_intensive $(TARGET_DIR)/usr/bin/mystery_program
	$(INSTALL) -D -m 0755 $(@D)/strace/strace_me $(TARGET_DIR)/root/strace/strace_me
	$(INSTALL) -D -m 0755 $(@D)/mmc/mmc_reader $(TARGET_DIR)/usr/bin/mmc_reader
endef

$(eval $(generic-package))
