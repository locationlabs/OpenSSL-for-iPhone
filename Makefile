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
IOS_INSTALL_LIB_DIR=$(INSTALL_DIR)/lib-ios
MACOSX_INSTALL_LIB_DIR=$(INSTALL_DIR)/lib-macosx
DEVELOPER=$(shell xcode-select -print-path)
IPHONE_SDKVERSION=$(call sdkversion,iphoneos)
IPHONE_SIMULATOR_SDKVERSION=$(call sdkversion,iphoneos)
MACOSX_SDKVERSION=$(call sdkversion,macosx)

CONFIG_VAR=no-dso no-dsa no-engine no-gost no-ec no-dh no-krb5 no-asm no-hw no-des no-idea no-rc2 -DOPENSSL_NO_BUF_FREELISTS

IOS_BASE=$(INSTALL_DIR)/bin/iphoneos$(IPHONE_SDKVERSION)
SIM_BASE=$(INSTALL_DIR)/bin/iphonesimulator$(IPHONE_SIMULATOR_SDKVERSION)
MACOSX_BASE=$(INSTALL_DIR)/bin/macosx$(MACOSX_SDKVERSION)
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
include $(dir $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))Makefile.macosx

###############
# macosx i386 #
###############

MACOSX_I386_LIB=$(MACOSX_BASE)-i386/lib

$(MACOSX_I386_LIB)/libssl.a $(MACOSX_I386_LIB)/libcrypto.a: $(TOUCH_BASE)/macosx-i386 

$(TOUCH_BASE)/macosx-i386: $(PREPARE_TOUCH) Makefile
	$(call build_macosx,i386,$@)

#################
# macosx x86_64 #
#################

MACOSX_X86_64_LIB=$(MACOSX_BASE)-x86_64/lib

$(MACOSX_X86_64_LIB)/libssl.a $(MACOSX_X86_64_LIB)/libcrypto.a: $(TOUCH_BASE)/macosx-x86_64 

$(TOUCH_BASE)/macosx-x86_64: $(PREPARE_TOUCH) Makefile
	$(call build_macosx,x86_64,$@)

################
# iphone armv7 #
################

IPHONE_ARMV7_LIB=$(IOS_BASE)-armv7/lib

$(IPHONE_ARMV7_LIB)/libssl.a $(IPHONE_ARMV7_LIB)/libcrypto.a: $(TOUCH_BASE)/iphone-armv7 

$(TOUCH_BASE)/iphone-armv7: $(PREPARE_TOUCH) Makefile
	$(call build_arm,armv7,$@)

#################
# iphone armv7s #
#################

IPHONE_ARMV7S_LIB=$(IOS_BASE)-armv7s/lib

$(IPHONE_ARMV7S_LIB)/libssl.a $(IPHONE_ARMV7S_LIB)/libcrypto.a: $(TOUCH_BASE)/iphone-armv7s

$(TOUCH_BASE)/iphone-armv7s: $(PREPARE_TOUCH) Makefile
	$(call build_arm,armv7s,$@)

################
# iphone arm64 #
################

IPHONE_ARM64_LIB=$(IOS_BASE)-arm64/lib

$(IPHONE_ARM64_LIB)/libssl.a $(IPHONE_ARM64_LIB)/libcrypto.a: $(TOUCH_BASE)/iphone-arm64

$(TOUCH_BASE)/iphone-arm64: $(PREPARE_TOUCH) Makefile
	$(call build_arm,arm64,$@)

##############
# lipo it up #
##############
$(IOS_INSTALL_LIB_DIR)/%.a: $(IPHONE_ARMV7_LIB)/%.a $(IPHONE_ARMV7S_LIB)/%.a $(IPHONE_ARM64_LIB)/%.a $(SIM_BASE)-i386/lib/%.a $(SIM_BASE)-x86_64/lib/%.a 
	mkdir -p $(IOS_INSTALL_LIB_DIR)
	lipo -create $^ -output $@

$(MACOSX_INSTALL_LIB_DIR)/%.a: $(MACOSX_I386_LIB)/%.a $(MACOSX_X86_64_LIB)/%.a
	mkdir -p $(MACOSX_INSTALL_LIB_DIR)
	lipo -create $^ -output $@

all: $(IOS_INSTALL_LIB_DIR)/libssl.a $(IOS_INSTALL_LIB_DIR)/libcrypto.a $(MACOSX_INSTALL_LIB_DIR)/libssl.a $(MACOSX_INSTALL_LIB_DIR)/libcrypto.a
	cp -R $(SIM_BASE)-i386/include/openssl $(INSTALL_INC_DIR)


##
## Local Variables:
##   mode: Makefile
##   tab-width: 3
## End:
##
## vim: tabstop=3 shiftwidth=3
##
