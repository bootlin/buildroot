#!/usr/bin/env bash

set -eu

#
# atf_image extracts the ATF binary image from DTB_FILE_NAME that appears in
# BR2_TARGET_ARM_TRUSTED_FIRMWARE_ADDITIONAL_VARIABLES in ${BR_CONFIG},
# then prints the corresponding file name for the genimage
# configuration file
#
atf_image()
{
	local ATF_VARIABLES="$(sed -n 's/^BR2_TARGET_ARM_TRUSTED_FIRMWARE_ADDITIONAL_VARIABLES="\([\/a-zA-Z0-9_=. \-]*\)"$/\1/p' ${BR2_CONFIG})"

	if grep -Eq "DTB_FILE_NAME=stm32mp157c-dk2.dtb" <<< ${ATF_VARIABLES}; then
		echo "tf-a-stm32mp157c-dk2.stm32"
	elif grep -Eq "DTB_FILE_NAME=stm32mp157a-dk1.dtb" <<< ${ATF_VARIABLES}; then
                echo "tf-a-stm32mp157a-dk1.stm32"
	elif grep -Eq "DTB_FILE_NAME=stm32mp157a-avenger96.dtb" <<< ${ATF_VARIABLES}; then
                echo "tf-a-stm32mp157a-avenger96.stm32"
	fi
}

main()
{
	local BOARD_DIR="board/stmicroelectronics/stm32mp157a-dk1-debugging"
	local ATFBIN="$(atf_image)"
	local GENIMAGE_CFG="$(mktemp --suffix genimage.cfg)"
	local GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"
	local EXTLINUXCONF="${BOARD_DIR}/extlinux.conf"
	local BOOT_DIR="${BINARIES_DIR}/boot_part"

	sed -e "s/%ATFBIN%/${ATFBIN}/" \
		${BOARD_DIR}/genimage.cfg.template > ${GENIMAGE_CFG}

	cp ${EXTLINUXCONF} ${BINARIES_DIR}
	mkdir -p ${BOOT_DIR}/boot/extlinux
	cp ${EXTLINUXCONF} ${BOOT_DIR}/boot/extlinux/
	cp ${BINARIES_DIR}/zImage ${BOOT_DIR}/boot/
	cp ${BINARIES_DIR}/stm32mp157a-dk1.dtb ${BOOT_DIR}/boot/

	GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"
	rm -rf ${GENIMAGE_TMP}

	genimage \
	--rootpath "${BINARIES_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

	rm -rf ${GENIMAGE_CFG} ${BOOT_DIR}

	exit $?
}

main $@
