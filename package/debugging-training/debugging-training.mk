################################################################################
#
# debianutils
#
################################################################################

DEBUGGING_TRAINING_VERSION = 1.0
DEBUGGING_TRAINING_SITE = board/stmicroelectronics/stm32mp157a-dk1-debugging/source
DEBUGGING_TRAINING_SITE_METHOD = local
DEBUGGING_TRAINING_MODULE_SUBDIRS = irqs_latency/ kmemleak/ locking/

$(eval $(kernel-module))
$(eval $(generic-package))
