import infra.basetest


class TestTFMBuild(infra.basetest.BRTest):
    config = \
        """
	BR2_TARGET_TRUSTED_FIRMWARE_M=y
	BR2_TARGET_TRUSTED_FIRMWARE_M_PLATFORM="arm/mps2/an521"
        """

    def test_run(self):
        pass
