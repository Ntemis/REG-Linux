################################################################################
#
# Yamagi Quake 2 (Zaero)
#
################################################################################
# Version: Commits on Jan 4, 2025
YQUAKE2_ZAERO_VERSION = 093aaefdfd2b7396fd518e3be6ff197552a3d072
YQUAKE2_ZAERO_SITE = https://github.com/yquake2/zaero.git
YQUAKE2_ZAERO_SITE_METHOD = git
YQUAKE2_ZAERO_DEPENDENCIES = sdl2

YQUAKE2_ZAERO_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release

# Install game library
define YQUAKE2_ZAERO_INSTALL_TARGET_CMDS
        mkdir -p $(TARGET_DIR)/usr/yquake2/zaero/
        $(INSTALL) -D -m 0755 $(@D)/Release/game.so $(TARGET_DIR)/usr/yquake2/zaero/game.so
endef

$(eval $(cmake-package))
