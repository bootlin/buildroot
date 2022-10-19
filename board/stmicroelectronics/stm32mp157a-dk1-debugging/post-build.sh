#!/usr/bin/env bash

main()
{
	local VMLINUX="${BUILD_DIR}/linux-5.13/vmlinux"
	
	# Copy vmlinux for debugging and tracing purposes
	cp ${VMLINUX} ${TARGET_DIR}/root/

	exit 0
}

main $@
