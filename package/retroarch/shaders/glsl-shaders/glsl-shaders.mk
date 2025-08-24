################################################################################
#
# glsl-shaders
#
################################################################################
# Version: Commits on Aug 21, 2025
GLSL_SHADERS_VERSION = 2903be405926f473b270accf22cfb560af9cc54c
GLSL_SHADERS_SITE = $(call github,libretro,glsl-shaders,$(GLSL_SHADERS_VERSION))
GLSL_SHADERS_LICENSE = GPL

define GLSL_SHADERS_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CXXFLAGS)" \
	$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile
endef

define GLSL_SHADERS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/reglinux/shaders
	$(MAKE) CXX="$(TARGET_CXX)" -C $(@D) \
	    INSTALLDIR=$(TARGET_DIR)/usr/share/reglinux/shaders install
	sed -e "s:^//#define CURVATURE:#define CURVATURE:" \
	    $(TARGET_DIR)/usr/share/reglinux/shaders/crt/shaders/crt-pi.glsl > \
		    $(TARGET_DIR)/usr/share/reglinux/shaders/crt/shaders/crt-pi-curvature.glsl
	sed -e 's:^shader0 = "shaders/crt-pi.glsl":shader0 = "shaders/crt-pi-curvature.glsl":' \
	    $(TARGET_DIR)/usr/share/reglinux/shaders/crt/crt-pi.glslp > \
		    $(TARGET_DIR)/usr/share/reglinux/shaders/crt/crt-pi-curvature.glslp
endef

# No Mega Bezel / koko-aio for non-x86 systems
define GLSL_SHADERS_DELETE_BEZEL
    rm -Rf $(TARGET_DIR)/usr/share/reglinux/shaders/bezel/Mega_Bezel
    rm -Rf $(TARGET_DIR)/usr/share/reglinux/shaders/bezel/koko-aio
endef
ifneq ($(BR2_x86_64),y)
    GLSL_SHADERS_POST_INSTALL_TARGET_HOOKS += GLSL_SHADERS_DELETE_BEZEL
endif

$(eval $(generic-package))
