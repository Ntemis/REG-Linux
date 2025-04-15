
################################################################################
#
# libretro-sameboy
#
################################################################################
# Version: Release 1.0.1 on Apr 5, 2025
LIBRETRO_SAMEBOY_VERSION = v1.0.1
LIBRETRO_SAMEBOY_SITE = $(call github,LIJI32,SameBoy,$(LIBRETRO_SAMEBOY_VERSION))
LIBRETRO_SAMEBOY_LICENSE = Expat
LIBRETRO_SAMEBOY_DEPENDENCIES = host-rgbds host-xxd

# Improve plaform selection
LIBRETRO_SAMEBOY_PLATFORM = unix

define LIBRETRO_SAMEBOY_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) \
	    -f Makefile platform="$(LIBRETRO_SAMEBOY_PLATFORM)" bootroms libretro
endef

define LIBRETRO_SAMEBOY_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/build/bin/sameboy_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/sameboy_libretro.so
endef

$(eval $(generic-package))
