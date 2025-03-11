################################################################################
#
# etlegacy
#
################################################################################
# Version: Commits on Jan 19, 2025
ETLEGACY_VERSION = v2.83.2
ETLEGACY_SITE = https://github.com/etlegacy/etlegacy.git
ETLEGACY_SITE_METHOD = git
ETLEGACY_GIT_SUBMODULES = YES
ETLEGACY_LICENSE = GPL-3.0
ETLEGACY_LICENSE_FILE = COPYING.txt

ETLEGACY_DEPENDENCIES += freetype libcurl libpng libtheora
ETLEGACY_DEPENDENCIES += libvorbis lua openal openssl sdl2
ETLEGACY_DEPENDENCIES += minizip cjson jpeg sqlite minizip-zlib

ifeq ($(BR2_PACKAGE_REGLINUX_XWAYLAND),y)
ETLEGACY_DEPENDENCIES += libgl libglew libglu
endif

ETLEGACY_SUPPORTS_IN_SOURCE_BUILD = NO

ETLEGACY_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
ETLEGACY_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF
# build
ETLEGACY_CONF_OPTS += -DINSTALL_DEFAULT_BASEDIR=/userdata/roms/etlegacy
ETLEGACY_CONF_OPTS += -DBUILD_SERVER=OFF
ETLEGACY_CONF_OPTS += -DBUILD_MOD=ON
ETLEGACY_CONF_OPTS += -DCROSS_COMPILE32=OFF
ETLEGACY_CONF_OPTS += -DRENDERER_DYNAMIC=OFF
ETLEGACY_CONF_OPTS += -DENABLE_MULTI_BUILD=OFF
# No more bundled library
ETLEGACY_CONF_OPTS += -DBUNDLED_LIBS=OFF
ETLEGACY_CONF_OPTS += -DBUNDLED_LIBS_DEFAULT=OFF
# client features
ETLEGACY_CONF_OPTS += -DFEATURE_CURL=ON
ETLEGACY_CONF_OPTS += -DFEATURE_SSL=ON
ETLEGACY_CONF_OPTS += -DFEATURE_OGG_VORBIS=ON
ETLEGACY_CONF_OPTS += -DFEATURE_THEORA=ON
ETLEGACY_CONF_OPTS += -DFEATURE_OPENAL=ON
ETLEGACY_CONF_OPTS += -DFEATURE_FREETYPE=ON
ETLEGACY_CONF_OPTS += -DFEATURE_PNG=ON
ETLEGACY_CONF_OPTS += -DFEATURE_AUTOUPDATE=OFF
ETLEGACY_CONF_OPTS += -DFEATURE_IRC_CLIENT=OFF
ETLEGACY_CONF_OPTS += -DFEATURE_IRC_SERVER=OFF
# install extras?
ETLEGACY_CONF_OPTS += -DINSTALL_EXTRA=OFF

# Architecture
ifeq ($(BR2_aarch64),y)
    ETLEGACY_CONF_OPTS += -DARM=ON
endif

# Choose renderer
# - Vulkan does not link (why ? it seems to link to GL and glew)
# - RENDERER22 does not compile
# TODO improve that part of code
ETLEGACY_CONF_OPTS += -DFEATURE_RENDERER_VULKAN=OFF
ETLEGACY_CONF_OPTS += -DFEATURE_RENDERER2=OFF
ifeq ($(BR2_aarch64)$(BR2_PACKAGE_HAS_GLES3),yy)
    ETLEGACY_CONF_OPTS += -DARM=ON
    ETLEGACY_CONF_OPTS += -DFEATURE_RENDERER_GLES=ON
    ETLEGACY_CONF_OPTS += -DFEATURE_RENDERER1=OFF
else
    ETLEGACY_CONF_OPTS += -DFEATURE_RENDERER_GLES=OFF
    ETLEGACY_CONF_OPTS += -DFEATURE_RENDERER1=ON
endif

define ETLEGACY_INSTALL_TARGET_CMDS
    mkdir -p $(TARGET_DIR)/usr/share/etlegacy
	cp $(@D)/buildroot-build/legacy/legacy_2.83-dirty.pk3 \
	    $(TARGET_DIR)/usr/share/etlegacy
    cp $(@D)/buildroot-build/etl \
	    $(TARGET_DIR)/usr/bin/etl
endef

define ETLEGACY_EVMAPY
	mkdir -p $(TARGET_DIR)/usr/share/evmapy
	cp $(BR2_EXTERNAL_REGLINUX_PATH)/package/ports/etlegacy/etlegacy.keys \
	    $(TARGET_DIR)/usr/share/evmapy
endef

ETLEGACY_POST_INSTALL_TARGET_HOOKS += ETLEGACY_EVMAPY

$(eval $(cmake-package))
