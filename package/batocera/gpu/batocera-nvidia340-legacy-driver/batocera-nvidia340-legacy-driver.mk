################################################################################
#
# batocera-nvidia340-legacy-driver
#
################################################################################

BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION = 340.108
BATOCERA_NVIDIA340_LEGACY_DRIVER_SUFFIX = $(if $(BR2_x86_64),_64)
BATOCERA_NVIDIA340_LEGACY_DRIVER_SITE = \
    http://download.nvidia.com/XFree86/Linux-x86$(BATOCERA_NVIDIA340_LEGACY_DRIVER_SUFFIX)/$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)
BATOCERA_NVIDIA340_LEGACY_DRIVER_SOURCE = \
    NVIDIA-Linux-x86$(BATOCERA_NVIDIA340_LEGACY_DRIVER_SUFFIX)-$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION).run
BATOCERA_NVIDIA340_LEGACY_DRIVER_LICENSE = NVIDIA Software License
BATOCERA_NVIDIA340_LEGACY_DRIVER_LICENSE_FILES = LICENSE
BATOCERA_NVIDIA340_LEGACY_DRIVER_REDISTRIBUTE = NO
BATOCERA_NVIDIA340_LEGACY_DRIVER_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_BATOCERA_NVIDIA340_LEGACY_DRIVER_XORG),y)

# Since nvidia-driver are binary blobs, the below dependencies are not
# strictly speaking build dependencies of nvidia-driver. However, they
# are build dependencies of packages that depend on nvidia-driver, so
# they should be built prior to those packages, and the only simple
# way to do so is to make nvidia-driver depend on them.
#batocera enable nvidia-driver and mesa3d to coexist in the same fs
BATOCERA_NVIDIA340_LEGACY_DRIVER_DEPENDENCIES = mesa3d xlib_libX11 xlib_libXext libglvnd kmod

# batocera modified to suport the vendor-neutral "dispatching" API/ABI
#   https://github.com/aritger/linux-opengl-abi-proposal/blob/master/linux-opengl-abi-proposal.txt
#batocera generic GL libraries are provided by libglvnd
#batocera only vendor version are installed
BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS_GL = \
	libGL.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)

BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS_EGL = \
	libEGL.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)

BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS_GLES = \
	libGLESv1_CM.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	libGLESv2.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)

#batocera libnvidia-egl-wayland soname bump
BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS_MISC = \
	libnvidia-eglcore.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	libnvidia-glcore.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	libnvidia-glsi.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	libnvidia-ml.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)

BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS_TLS = \
    libnvidia-tls.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \

BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS_VDPAU = \
    libvdpau.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	libvdpau_trace.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	libvdpau_nvidia.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)

BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS += \
	$(BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS_GL) \
	$(BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS_EGL) \
	$(BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS_GLES) \
	$(BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS_MISC)

BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS_GL_32 = \
	libGL.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)

# batocera 32bit libraries
BATOCERA_NVIDIA340_LEGACY_DRIVER_32 = \
	$(BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS_GL_32) \
	$(BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS_EGL) \
	$(BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS_GLES) \
	libnvidia-eglcore.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	libnvidia-glcore.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	libnvidia-glsi.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	libnvidia-ml.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)

# Install the gl.pc file
define BATOCERA_NVIDIA340_LEGACY_DRIVER_INSTALL_GL_DEV
	$(INSTALL) -D -m 0644 $(@D)/libGL.la $(STAGING_DIR)/usr/lib/libGL.la
	$(SED) 's:__GENERATED_BY__:Buildroot:' $(STAGING_DIR)/usr/lib/libGL.la
	$(SED) 's:__LIBGL_PATH__:/usr/lib:' $(STAGING_DIR)/usr/lib/libGL.la
	$(SED) 's:-L[^[:space:]]\+::' $(STAGING_DIR)/usr/lib/libGL.la
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL_REGLINUX_PATH)/package/nvidia-driver/gl.pc \
	    $(STAGING_DIR)/usr/lib/pkgconfig/gl.pc
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL_REGLINUX_PATH)/package/nvidia-driver/egl.pc \
	    $(STAGING_DIR)/usr/lib/pkgconfig/egl.pc
endef

# Those libraries are 'private' libraries requiring an agreement with
# NVidia to develop code for those libs. There seems to be no restriction
# on using those libraries (e.g. if the user has such an agreement, or
# wants to run a third-party program developped under such an agreement).
ifeq ($(BR2_PACKAGE_BATOCERA_NVIDIA340_LEGACY_DRIVER_PRIVATE_LIBS),y)
BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS += \
	libnvidia-ifr.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	libnvidia-fbc.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)
endif
endif # X drivers

ifeq ($(BR2_PACKAGE_BATOCERA_NVIDIA340_LEGACY_DRIVER_CUDA),y)
BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS += \
	libcuda.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	libnvidia-compiler.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	libnvcuvid.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	libnvidia-encode.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)
ifeq ($(BR2_PACKAGE_BATOCERA_NVIDIA340_LEGACY_DRIVER_CUDA_PROGS),y)
BATOCERA_NVIDIA340_LEGACY_DRIVER_PROGS = nvidia-cuda-mps-control nvidia-cuda-mps-server
endif
endif

ifeq ($(BR2_PACKAGE_BATOCERA_NVIDIA340_LEGACY_DRIVER_OPENCL),y)
BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS += \
	libOpenCL.so.1.0.0 \
	libnvidia-opencl.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)
BATOCERA_NVIDIA340_LEGACY_DRIVER_DEPENDENCIES += mesa3d-headers
BATOCERA_NVIDIA340_LEGACY_DRIVER_PROVIDES += libopencl
endif

# Build and install the kernel modules if needed
ifeq ($(BR2_PACKAGE_BATOCERA_NVIDIA340_LEGACY_DRIVER_MODULE),y)

BATOCERA_NVIDIA340_LEGACY_DRIVER_MODULES = nvidia
ifeq ($(BR2_x86_64),y)
BATOCERA_NVIDIA340_LEGACY_DRIVER_MODULES += uvm
endif

# They can't do everything like everyone. They need those variables,
# because they don't recognise the usual variables set by the kernel
# build system. We also need to tell them what modules to build.
BATOCERA_NVIDIA340_LEGACY_DRIVER_MODULE_MAKE_OPTS = \
	KERNEL_SOURCES="$(LINUX_DIR)" \
	KERNEL_OUTPUT="$(LINUX_DIR)" \
	NV_KERNEL_MODULES="$(BATOCERA_NVIDIA340_LEGACY_DRIVER_MODULES)" \
	IGNORE_CC_MISMATCH="1"

BATOCERA_NVIDIA340_LEGACY_DRIVER_MODULE_SUBDIRS = kernel \
	kernel/uvm

$(eval $(kernel-module))

endif # BR2_PACKAGE_BATOCERA_NVIDIA340_LEGACY_DRIVER_MODULE == y

# The downloaded archive is in fact an auto-extract script. So, it can run
# virtually everywhere, and it is fine enough to provide useful options.
# Except it can't extract into an existing (even empty) directory.
define BATOCERA_NVIDIA340_LEGACY_DRIVER_EXTRACT_CMDS
	$(SHELL) $(BATOCERA_NVIDIA340_LEGACY_DRIVER_DL_DIR)/$(BATOCERA_NVIDIA340_LEGACY_DRIVER_SOURCE) \
	    --extract-only --target $(@D)/tmp-extract
	chmod u+w -R $(@D)
	mv $(@D)/tmp-extract/* $(@D)/tmp-extract/.manifest $(@D)
	rm -rf $(@D)/tmp-extract
endef

# Helper to install libraries
# $1: destination directory (target or staging)
#
define BATOCERA_NVIDIA340_LEGACY_DRIVER_INSTALL_LIBS
	$(foreach lib,$(BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS),\
		$(INSTALL) -D -m 0644 $(@D)/$(lib) $(1)/usr/lib/$(notdir $(lib))
	)
	$(foreach lib,$(BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS_TLS),\
		$(INSTALL) -D -m 0644 $(@D)/tls/$(lib) $(1)/usr/lib/$(notdir $(lib))
	)
	$(foreach lib,$(BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS_VDPAU),\
		$(INSTALL) -D -m 0644 $(@D)/$(lib) $(1)/usr/lib/vdpau/$(notdir $(lib))
	)
endef

# batocera install 32bit libraries
define BATOCERA_NVIDIA340_LEGACY_DRIVER_INSTALL_32
	$(foreach lib,$(BATOCERA_NVIDIA340_LEGACY_DRIVER_32),\
		$(INSTALL) -D -m 0644 $(@D)/32/$(lib) $(1)/lib32/$(notdir $(lib))
	)
	$(foreach lib,$(BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS_TLS),\
		$(INSTALL) -D -m 0644 $(@D)/32/tls/$(lib) $(1)/lib32/$(notdir $(lib))
	)
	$(foreach lib,$(BATOCERA_NVIDIA340_LEGACY_DRIVER_LIBS_VDPAU),\
		$(INSTALL) -D -m 0644 $(@D)/32/$(lib) $(1)/lib32/vdpau/$(notdir $(lib))
	)
endef

define BATOCERA_NVIDIA340_LEGACY_DRIVER_INSTALL_COMMON
	$(INSTALL) -D -m 0644 $(@D)/nvidia_drv.so \
	    $(TARGET_DIR)/usr/lib/xorg/modules/drivers/nvidia340_legacy_drv.so
	$(INSTALL) -D -m 0644 $(@D)/libglx.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	    $(TARGET_DIR)/usr/lib/nvidia/xorg/libglx.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)
	$(foreach p,$(BATOCERA_NVIDIA340_LEGACY_DRIVER_PROGS), \
		$(INSTALL) -D -m 0755 $(@D)/$(p) \
			$(TARGET_DIR)/usr/bin/$(p)
	)
	mkdir -p $(TARGET_DIR)/usr/share/nvidia
	mkdir -p $(TARGET_DIR)/usr/share/nvidia/X11
	$(INSTALL) -D -m 0644 \
	    $(BR2_EXTERNAL_REGLINUX_PATH)/package/batocera/gpu/batocera-nvidia340-legacy-driver/20-nvidia.conf \
		$(TARGET_DIR)/usr/share/nvidia/X11/20-nvidia.conf
endef

# For target, install libraries and X.org modules
ifeq ($(BR2_x86_64),y)
define BATOCERA_NVIDIA340_LEGACY_DRIVER_INSTALL_TARGET_CMDS
	$(call BATOCERA_NVIDIA340_LEGACY_DRIVER_INSTALL_LIBS,$(TARGET_DIR))
	$(call BATOCERA_NVIDIA340_LEGACY_DRIVER_INSTALL_COMMON)
endef
else ifeq ($(BR2_i686),y)
define BATOCERA_NVIDIA340_LEGACY_DRIVER_INSTALL_TARGET_CMDS
	$(call BATOCERA_NVIDIA340_LEGACY_DRIVER_INSTALL_32,$(TARGET_DIR))
	$(call BATOCERA_NVIDIA340_LEGACY_DRIVER_INSTALL_COMMON)
endef
endif


KVER = $(shell expr $(BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE))

define BATOCERA_NVIDIA340_LEGACY_DRIVER_RENAME_KERNEL_MODULES_32BITS
	# move .so.340.108 files (32-bits)
	mkdir -p $(TARGET_DIR)/usr/share/nvidia/libraries/32
	mv -f $(TARGET_DIR)/lib32/libGL.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	    $(TARGET_DIR)/usr/share/nvidia/libraries/32/libGL.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)
	mv -f $(TARGET_DIR)/lib32/libEGL.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	    $(TARGET_DIR)/usr/share/nvidia/libraries/32/libEGL.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)
	mv -f $(TARGET_DIR)/lib32/libGLESv1_CM.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	    $(TARGET_DIR)/usr/share/nvidia/libraries/32/libGLESv1_CM.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)
	mv -f $(TARGET_DIR)/lib32/libGLESv2.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	    $(TARGET_DIR)/usr/share/nvidia/libraries/32/libGLESv2.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)

endef

define BATOCERA_NVIDIA340_LEGACY_DRIVER_RENAME_KERNEL_MODULES_64BITS
	# move .so.340.108 files (64-bits)
	mkdir -p $(TARGET_DIR)/usr/share/nvidia/libraries
	mv -f $(TARGET_DIR)/usr/lib/libGL.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	    $(TARGET_DIR)/usr/share/nvidia/libraries/libGL.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)
	mv -f $(TARGET_DIR)/usr/lib/libEGL.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	    $(TARGET_DIR)/usr/share/nvidia/libraries/libEGL.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)
	mv -f $(TARGET_DIR)/usr/lib/libGLESv1_CM.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	    $(TARGET_DIR)/usr/share/nvidia/libraries/libGLESv1_CM.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)
	mv -f $(TARGET_DIR)/usr/lib/libGLESv2.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) \
	    $(TARGET_DIR)/usr/share/nvidia/libraries/libGLESv2.so.$(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION)

endef

define BATOCERA_NVIDIA340_LEGACY_DRIVER_RENAME_KERNEL_MODULES_COMMON
	mkdir -p $(TARGET_DIR)/usr/share/nvidia
	mkdir -p $(TARGET_DIR)/usr/share/nvidia/modules
	# rename the kernel modules to avoid conflict
	mv -f $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/updates/nvidia.ko \
	    $(TARGET_DIR)/usr/share/nvidia/modules/nvidia340-legacy.ko
	mv -f $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/updates/nvidia-uvm.ko \
	    $(TARGET_DIR)/usr/share/nvidia/modules/nvidia340-uvm-legacy.ko

	# set the driver version file
	echo $(BATOCERA_NVIDIA340_LEGACY_DRIVER_VERSION) > $(TARGET_DIR)/usr/share/nvidia/legacy340.version
endef

# move to avoid the production driver conflicts
ifeq ($(BR2_x86_64),y)
define BATOCERA_NVIDIA340_LEGACY_DRIVER_RENAME_KERNEL_MODULES
	$(call BATOCERA_NVIDIA340_LEGACY_DRIVER_RENAME_KERNEL_MODULES_COMMON)
	$(call BATOCERA_NVIDIA340_LEGACY_DRIVER_RENAME_KERNEL_MODULES_64BITS)
endef
else ifeq ($(BR2_i686),y)
define BATOCERA_NVIDIA340_LEGACY_DRIVER_RENAME_KERNEL_MODULES
	$(call BATOCERA_NVIDIA340_LEGACY_DRIVER_RENAME_KERNEL_MODULES_COMMON)
	$(call BATOCERA_NVIDIA340_LEGACY_DRIVER_RENAME_KERNEL_MODULES_32BITS)
endef
endif

BATOCERA_NVIDIA340_LEGACY_DRIVER_POST_INSTALL_TARGET_HOOKS += BATOCERA_NVIDIA340_LEGACY_DRIVER_RENAME_KERNEL_MODULES

$(eval $(generic-package))
