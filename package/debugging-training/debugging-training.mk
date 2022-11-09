################################################################################
#
# debianutils
#
################################################################################

DEBUGGING_TRAINING_VERSION = 1.0
DEBUGGING_TRAINING_SITE = board/stmicroelectronics/stm32mp157a-dk1-debugging/source
DEBUGGING_TRAINING_SITE_METHOD = local

define DEBUGGING_TRAINING_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) $(@D)/sched_intensive/sched_intensive.c -o $(@D)/sched_intensive/sched_intensive
endef

define DEBUGGING_TRAINING_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/sched_intensive/sched_intensive $(TARGET_DIR)/usr/bin/sched_intensive
endef

$(eval $(generic-package))
