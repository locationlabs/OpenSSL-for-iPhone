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


CURRENTPATH=$(shell pwd)
INSTALL_DIR?=$(CURRENTPATH)/results
INSTALL_INC_DIR=$(INSTALL_DIR)/include
INSTALL_LIB_DIR=$(INSTALL_DIR)/lib
DEVELOPER=$(shell xcode-select -print-path)
SDKVERSION=$(shell xcodebuild -showsdks | grep iphoneos | sed -e 's/.*iphoneos//g' | tail -n 1)

CONFIG_VAR=no-dso no-dsa no-engine no-gost no-ec no-dh no-krb5 no-asm no-hw no-des no-idea no-rc2 -DOPENSSL_NO_BUF_FREELISTS

IOS_BASE=$(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)
SIM_BASE=$(CURRENTPATH)/bin/iPhoneSimulator$(SDKVERSION)
OPENSSL_SRC=$(CURRENTPATH)/src/openssl-$(OPENSSL_VERSION)

# setup

$(CURRENTPATH)/src/touched:
	mkdir -p $(CURRENTPATH)/src
	mkdir -p $(INSTALL_INC_DIR)
	mkdir -p $(INSTALL_LIB_DIR)/pkgconfig
	tar zxf openssl-$(OPENSSL_VERSION).tar.gz -C $(CURRENTPATH)/src
	touch $(CURRENTPATH)/src/touched

include Makefile.simulator
include Makefile.arm


ARMV7_LIB=$(IOS_BASE)-armv7.sdk/lib

$(ARMV7_LIB)/libssl.a: $(OPENSSL_SRC)/touched_armv7

$(ARMV7_LIB)/libcrypto.a: $(OPENSSL_SRC)/touched_armv7

$(OPENSSL_SRC)/touched_armv7: $(CURRENTPATH)/src/touched
	$(call build_arm,armv7,$@)


ARMV7S_LIB=$(IOS_BASE)-armv7s.sdk/lib

$(ARMV7S_LIB)/libssl.a: $(OPENSSL_SRC)/touched_armv7s

$(ARMV7S_LIB)/libcrypto.a: $(OPENSSL_SRC)/touched_armv7s

$(OPENSSL_SRC)/touched_armv7s: $(CURRENTPATH)/src/touched
	$(call build_arm,armv7s,$@)


ARM64_LIB=$(IOS_BASE)-arm64.sdk/lib

$(ARM64_LIB)/libssl.a: $(OPENSSL_SRC)/touched_arm64

$(ARM64_LIB)/libcrypto.a: $(OPENSSL_SRC)/touched_arm64

$(OPENSSL_SRC)/touched_arm64: $(CURRENTPATH)/src/touched
	$(call build_arm,arm64,$@)


# lipo it up

$(INSTALL_LIB_DIR)/%.a: $(ARMV7_LIB)/%.a $(ARMV7S_LIB)/%.a $(ARM64_LIB)/%.a $(SIM_BASE).sdk/lib/%.a 
	lipo -create $^ -output $@

all: $(INSTALL_LIB_DIR)/libssl.a $(INSTALL_LIB_DIR)/libcrypto.a
	cp -R $(CURRENTPATH)/bin/iPhoneSimulator$(SDKVERSION).sdk/include/openssl $(INSTALL_INC_DIR)

clean:
	rm -rf bin/ src/

##
## Local Variables:
##   mode: Makefile
##   tab-width: 3
## End:
##
## vim: tabstop=3 shiftwidth=3
##
