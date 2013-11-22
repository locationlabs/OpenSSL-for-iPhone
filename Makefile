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

CONFIG_VAR=no-dso no-dsa no-engine no-gost no-ec no-dh no-krb5 no-asm no-hw no-des no-ssl2 no-idea no-rc2 -DOPENSSL_NO_BUF_FREELISTS

# setup

$(CURRENTPATH)/src/touched:
	mkdir -p $(CURRENTPATH)/src
	mkdir -p $(INSTALL_INC_DIR)
	mkdir -p $(INSTALL_LIB_DIR)/pkgconfig
	tar zxf openssl-$(OPENSSL_VERSION).tar.gz -C $(CURRENTPATH)/src
	touch $(CURRENTPATH)/src/touched

# i386 (iPhoneSimulator)

$(CURRENTPATH)/bin/iPhoneSimulator$(SDKVERSION).sdk/lib/libssl.a: $(CURRENTPATH)/src/openssl-$(OPENSSL_VERSION)/touched_iphonesimulator_i386

$(CURRENTPATH)/bin/iPhoneSimulator$(SDKVERSION).sdk/lib/libcrypto.a: $(CURRENTPATH)/src/openssl-$(OPENSSL_VERSION)/touched_iphonesimulator_i386

$(CURRENTPATH)/src/openssl-$(OPENSSL_VERSION)/touched_iphonesimulator_i386: $(CURRENTPATH)/src/touched
	@echo "Building openssl for iPhoneSimulator $(SDKVERSION) i386"
	@echo "Please stand by..."
	mkdir -p $(CURRENTPATH)/bin/iPhoneSimulator$(SDKVERSION).sdk
	CC="$(DEVELOPER)/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -arch i386" && (cd $(CURRENTPATH)/src/openssl-$(OPENSSL_VERSION) && $(MAKE) clean && ./Configure BSD-generic32 $(CONFIG_VAR) --openssldir=$(CURRENTPATH)/bin/iPhoneSimulator$(SDKVERSION).sdk && sed -ie "s!^CFLAG=!CFLAG=-miphoneos-version-min=$(MIN_IOS_VERSION) -isysroot $(DEVELOPER)/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator$(SDKVERSION).sdk !" "Makefile" && $(MAKE) && $(MAKE) install && $(MAKE) clean ) > $(CURRENTPATH)/bin/iPhoneSimulator$(SDKVERSION).sdk/build-openssl-$(OPENSSL_VERSION).log 2>&1
	touch $@

# armv7

$(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-armv7.sdk/lib/libssl.a: $(CURRENTPATH)/src/openssl-$(OPENSSL_VERSION)/touched_armv7

$(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-armv7.sdk/lib/libcrypto.a: $(CURRENTPATH)/src/openssl-$(OPENSSL_VERSION)/touched_armv7

$(CURRENTPATH)/src/openssl-$(OPENSSL_VERSION)/touched_armv7: $(CURRENTPATH)/src/touched
	@echo "Building openssl for iOS $(SDKVERSION) armv7"
	@echo "Please stand by..."
	mkdir -p $(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-armv7.sdk
	export CC="$(DEVELOPER)/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -arch armv7" && (cd $(CURRENTPATH)/src/openssl-$(OPENSSL_VERSION) && $(MAKE) clean && ./Configure BSD-generic32 $(CONFIG_VAR) --openssldir=$(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-armv7.sdk && sed -ie "s!^CFLAG=!CFLAG=-miphoneos-version-min=${MIN_IOS_VERSION} -isysroot ${DEVELOPER}/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS${SDKVERSION}.sdk !" "Makefile" && sed -ie "s!static volatile sig_atomic_t intr_signal;!static volatile intr_signal;!" "crypto/ui/ui_openssl.c" && $(MAKE) && $(MAKE) install && $(MAKE) clean ) > $(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-armv7.sdk/build-openssl-$(OPENSSL_VERSION).log 2>&1
	touch $@

# armv7s

$(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-armv7s.sdk/lib/libssl.a: $(CURRENTPATH)/src/openssl-$(OPENSSL_VERSION)/touched_armv7s

$(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-armv7s.sdk/lib/libcrypto.a: $(CURRENTPATH)/src/openssl-$(OPENSSL_VERSION)/touched_armv7s

$(CURRENTPATH)/src/openssl-$(OPENSSL_VERSION)/touched_armv7s: $(CURRENTPATH)/src/touched
	@echo "Building openssl for iOS $(SDKVERSION) armv7s"
	@echo "Please stand by..."
	mkdir -p $(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-armv7s.sdk
	export CC="$(DEVELOPER)/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -arch armv7s" && (cd $(CURRENTPATH)/src/openssl-$(OPENSSL_VERSION) && $(MAKE) clean && ./Configure BSD-generic32 $(CONFIG_VAR) --openssldir=$(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-armv7s.sdk && sed -ie "s!^CFLAG=!CFLAG=-miphoneos-version-min=${MIN_IOS_VERSION} -isysroot ${DEVELOPER}/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS${SDKVERSION}.sdk !" "Makefile" && sed -ie "s!static volatile sig_atomic_t intr_signal;!static volatile intr_signal;!" "crypto/ui/ui_openssl.c" && $(MAKE) && $(MAKE) install && $(MAKE) clean ) > $(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-armv7s.sdk/build-openssl-$(OPENSSL_VERSION).log 2>&1
	touch $@

# arm64

$(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-arm64.sdk/lib/libssl.a: $(CURRENTPATH)/src/openssl-$(OPENSSL_VERSION)/touched_arm64

$(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-arm64.sdk/lib/libcrypto.a: $(CURRENTPATH)/src/openssl-$(OPENSSL_VERSION)/touched_arm64

$(CURRENTPATH)/src/openssl-$(OPENSSL_VERSION)/touched_arm64: $(CURRENTPATH)/src/touched
	@echo "Building openssl for iOS $(SDKVERSION) arm64"
	@echo "Please stand by..."
	mkdir -p $(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-arm64.sdk
	export CC="$(DEVELOPER)/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -arch arm64" && (cd $(CURRENTPATH)/src/openssl-$(OPENSSL_VERSION) && $(MAKE) clean && ./Configure BSD-generic32 $(CONFIG_VAR) --openssldir=$(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-arm64.sdk && sed -ie "s!^CFLAG=!CFLAG=-miphoneos-version-min=${MIN_IOS_VERSION} -isysroot ${DEVELOPER}/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS${SDKVERSION}.sdk !" "Makefile" && sed -ie "s!static volatile sig_atomic_t intr_signal;!static volatile intr_signal;!" "crypto/ui/ui_openssl.c" && $(MAKE) && $(MAKE) install && $(MAKE) clean ) > $(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-arm64.sdk/build-openssl-$(OPENSSL_VERSION).log 2>&1
	touch $@

# lipo it up

$(INSTALL_LIB_DIR)/libssl.a: $(CURRENTPATH)/bin/iPhoneSimulator$(SDKVERSION).sdk/lib/libssl.a $(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-armv7.sdk/lib/libssl.a $(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-armv7s.sdk/lib/libssl.a $(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-arm64.sdk/lib/libssl.a
	lipo -create $^ -output $@

$(INSTALL_LIB_DIR)/libcrypto.a: $(CURRENTPATH)/bin/iPhoneSimulator$(SDKVERSION).sdk/lib/libcrypto.a $(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-armv7.sdk/lib/libcrypto.a $(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-armv7s.sdk/lib/libcrypto.a $(CURRENTPATH)/bin/iPhoneOS$(SDKVERSION)-arm64.sdk/lib/libcrypto.a
	lipo -create $^ -output $@

all: $(INSTALL_LIB_DIR)/libssl.a $(INSTALL_LIB_DIR)/libcrypto.a

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
