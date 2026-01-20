include $(TOPDIR)/rules.mk

PKG_NAME:=usteer
PKG_RELEASE:=1

PKG_SOURCE_URL=https://git.openwrt.org/project/usteer.git
PKG_MIRROR_HASH:=ccca1352653415a30a11203451469c7f5bbe8a8f2436f3a77a68c6c95baa643d
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2021-04-19
PKG_SOURCE_VERSION:=f42bf2962edd0199e4c96ebf19933b2846bcce27

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

CMAKE_OPTIONS += -DCMAKE_POLICY_VERSION_MINIMUM=3.5

define Package/usteer
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+libubox +libubus +libblobmsg-json +libnl-tiny +libpcap
  TITLE:=OpenWrt AP roaming assist daemon
endef

define Package/usteer/conffiles
/etc/config/usteer
endef

define Package/usteer/install
	$(INSTALL_DIR) $(1)/sbin $(1)/etc/init.d $(1)/etc/config
	$(CP) ./files/* $(1)/
	$(CP) $(PKG_BUILD_DIR)/{usteerd,ap-monitor} $(1)/sbin/
endef

$(eval $(call BuildPackage,usteer))
