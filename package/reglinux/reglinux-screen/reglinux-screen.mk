################################################################################
#
# reglinux screen
#
################################################################################

REGLINUX_SCREEN_VERSION = 0.0
REGLINUX_SCREEN_LICENSE = GPL
REGLINUX_SCREEN_DEPENDENCIES = pciutils
REGLINUX_SCREEN_SOURCE=
REGLINUX_SCREEN_PATH = $(BR2_EXTERNAL_REGLINUX_PATH)/package/reglinux/reglinux-screen/scripts

ifeq ($(BR2_PACKAGE_REGLINUX_SWAY)$(BR2_PACKAGE_BATOCERA_AUDIO),yy)
REGLINUX_SCREEN_DEPENDENCIES += grim wf-recorder
endif

define REGLINUX_SCREEN_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/reglinux
	$(INSTALL) -m 0755 $(REGLINUX_SCREEN_PATH)/resolution/resolution.drm		$(TARGET_DIR)/etc/reglinux/
	$(INSTALL) -m 0755 $(REGLINUX_SCREEN_PATH)/resolution/resolution.sway		$(TARGET_DIR)/etc/reglinux/
	$(INSTALL) -m 0755 $(REGLINUX_SCREEN_PATH)/resolution/system-resolution	    $(TARGET_DIR)/usr/bin/

	$(INSTALL) -m 0755 $(REGLINUX_SCREEN_PATH)/recorder/recorder.drm		$(TARGET_DIR)/etc/reglinux/
	$(INSTALL) -m 0755 $(REGLINUX_SCREEN_PATH)/recorder/recorder.sway		$(TARGET_DIR)/etc/reglinux/
	$(INSTALL) -m 0755 $(REGLINUX_SCREEN_PATH)/recorder/system-recorder		$(TARGET_DIR)/usr/bin/

	$(INSTALL) -m 0755 $(REGLINUX_SCREEN_PATH)/screenshot/screenshot.drm		$(TARGET_DIR)/etc/reglinux/
	$(INSTALL) -m 0755 $(REGLINUX_SCREEN_PATH)/screenshot/screenshot.sway		$(TARGET_DIR)/etc/reglinux/
	$(INSTALL) -m 0755 $(REGLINUX_SCREEN_PATH)/screenshot/system-screenshot	    $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
