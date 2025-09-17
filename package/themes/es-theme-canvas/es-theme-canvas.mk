################################################################################
#
# EmulationStation theme "Canvas"
#
################################################################################

ES_THEME_CANVAS_VERSION = c64f8aa2ab009a5f97aedb5a409a2a0f9a0e6fc4
ES_THEME_CANVAS_SITE = $(call github,REG-Linux,es-theme-canvas,$(ES_THEME_CANVAS_VERSION))

define ES_THEME_CANVAS_INSTALL_TARGET_CMDS
    mkdir -p $(TARGET_DIR)/usr/share/emulationstation/themes/es-theme-canvas
    cp -r $(@D)/* $(TARGET_DIR)/usr/share/emulationstation/themes/es-theme-canvas
endef

$(eval $(generic-package))
