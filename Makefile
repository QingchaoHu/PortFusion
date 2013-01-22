#
# CORSIS PortFusion -S[nowfall
# Copyright © 2013  Cetin Sert
#

#
# OpenWrt Package Makefile
#

include $(TOPDIR)/rules.mk

PKG_NAME:=PortFusion
PKG_VERSION:=2013-01-22
PKG_RELEASE:=2013-01-22
PKG_LICENSE:=GPLv3
PKG_LICENSE_FILE:=License
PKG_MAINTAINER:=Cetin Sert <fusion@corsis.eu>, Corsis Research
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/pf
  SECTION:=corsis
  CATEGORY:=Corsis Research
  TITLE:=CORSIS PortFusion Embedded
  URL:=http://fusion.corsis.eu
  MAINTAINER:=Cetin Sert <fusion@corsis.eu>, Corsis Research
  DEPENDS:=+libpthread
endef

define Package/pf/description
  CORSIS PortFusion Embedded Packaged for OpenWrt.
endef

define Package/pf/config
menu "pf"
	choice
		prompt "Data transfer"
		default PF_LOOPS_SPLICE
	config PF_LOOPS_SPLICE
		bool "Zero-copy in kernel space; pipe/splice"
		help
		  Open a pipe in kernel space and run for maximum
		  possible throughput; utilize Linux system calls
		  pipe(2) and splice(2).
	config PF_LOOPS_PORTABLE
		bool "Buffered in user space; recv/send"
		help
		  Allocate a buffer on the stack and run for maximum
		  portability; utilize BSD sockets API calls recv(3)
		  and send(3).
	endchoice

	choice
		prompt "Concurrency"
		default PF_THREADS_POSIX
		help
		  PortFusion supports 2 modes for concurrency.
	config PF_THREADS_POSIX
		bool "POSIX threads"
	config PF_THREADS_PROTO
		bool "Protothreads"
		help
		  Not implemented.
	endchoice
endmenu
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	OS=OpenWrt ARCH=native $(MAKE) -C $(PKG_BUILD_DIR) $(TARGET_CONFIGURE_OPTS)
endef

define Package/pf/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/pf $(1)/usr/bin/
endef

$(eval $(call BuildPackage,pf))
