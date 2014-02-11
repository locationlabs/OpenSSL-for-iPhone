.PHONY: prepare

default: all

###########################################################################
#  Change values here
#
OPENSSL_VERSION=1.0.1
MIN_IOS_VERSION=6.0
###########################################################################
#
# Don't change anything under this line!
#
###########################################################################

define sdkversion
	$(shell xcodebuild -showsdks | grep $(1) | sed -e "s/.*$(1)//g" | tail -n 1)
endef

HOME_DIR ?= $(shell pwd)
INSTALL_DIR ?= $(HOME_DIR)/results
INSTALL_INC_DIR=$(INSTALL_DIR)/include
INSTALL_LIB_DIR=$(INSTALL_DIR)/lib
DEVELOPER=$(shell xcode-select -print-path)
IPHONE_SDKVERSION=$(call sdkversion,iphoneos)
IPHONE_SIMULATOR_SDKVERSION=$(call sdkversion,iphoneos)
MACOSX_SDKVERSION=$(call sdkversion,macosx)

CONFIG_VAR=no-dso no-dsa no-engine no-gost no-ec no-dh no-krb5 no-asm no-hw no-des no-idea no-rc2 -DOPENSSL_NO_BUF_FREELISTS

IOS_BASE=$(INSTALL_DIR)/bin/iphoneos$(IPHONE_SDKVERSION)
SIM_BASE=$(INSTALL_DIR)/bin/iphonesimulator$(IPHONE_SIMULATOR_SDKVERSION)
OPENSSL_SRC=$(INSTALL_DIR)/src/openssl-$(OPENSSL_VERSION)

TOUCH_BASE=$(INSTALL_DIR)/touched
PREPARE_TOUCH=$(TOUCH_BASE)/prepare

#########
# setup #
#########

$(PREPARE_TOUCH):
	mkdir -p $(INSTALL_DIR)/src
	mkdir -p $(INSTALL_INC_DIR)
	mkdir -p $(TOUCH_BASE)
	tar zxf $(HOME_DIR)/openssl-$(OPENSSL_VERSION).tar.gz -C $(INSTALL_DIR)/src
	touch $(PREPARE_TOUCH)

include $(dir $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))Makefile.simulator
include $(dir $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))Makefile.arm

#########
# armv7 #
#########

ARMV7_LIB=$(IOS_BASE)-armv7/lib

$(ARMV7_LIB)/libssl.a $(ARMV7_LIB)/libcrypto.a: $(TOUCH_BASE)/armv7 

$(TOUCH_BASE)/armv7: $(PREPARE_TOUCH) Makefile
	$(call build_arm,armv7,$@)

##########
# armv7s #
##########

ARMV7S_LIB=$(IOS_BASE)-armv7s/lib

$(ARMV7S_LIB)/libssl.a $(ARMV7S_LIB)/libcrypto.a: $(TOUCH_BASE)/armv7s

$(TOUCH_BASE)/armv7s: $(PREPARE_TOUCH) Makefile
	$(call build_arm,armv7s,$@)

#########
# arm64 #
#########

ARM64_LIB=$(IOS_BASE)-arm64/lib

$(ARM64_LIB)/libssl.a $(ARM64_LIB)/libcrypto.a: $(TOUCH_BASE)/arm64

$(TOUCH_BASE)/arm64: $(PREPARE_TOUCH) Makefile
	$(call build_arm,arm64,$@)

##############
# lipo it up #
##############

$(INSTALL_LIB_DIR)/%.a: $(ARMV7_LIB)/%.a $(ARMV7S_LIB)/%.a $(ARM64_LIB)/%.a $(SIM_BASE)-i386/lib/%.a 
	lipo -create $^ -output $@

all: $(INSTALL_LIB_DIR)/libssl.a $(INSTALL_LIB_DIR)/libcrypto.a
	cp -R $(SIM_BASE)-i386/include/openssl $(INSTALL_INC_DIR)


##
## Local Variables:
##   mode: Makefile
##   tab-width: 3
## End:
##
## vim: tabstop=3 shiftwidth=3
##
