APP_NAME:=bitcask

UPSTREAM_GIT:=git://github.com/cloudamqp/bitcask.git
UPSTREAM_REVISION:=1.6

ORIGINAL_VERSION:=1.6
RETAIN_ORIGINAL_VERSION:=true
DO_NOT_GENERATE_APP_FILE:=true
ORIGINAL_APP_FILE=$(CLONE_DIR)/src/bitcask.app.src

LIBRARY:=$(CLONE_DIR)/priv/bitcask.so

CONSTRUCT_APP_PREREQS:=$(LIBRARY)
define construct_app_commands
	mkdir -p $(APP_DIR)/priv
	cp $(LIBRARY) $(APP_DIR)/priv
endef

define package_rules

$(LIBRARY):
	cd $(CLONE_DIR); \
	make

$(PACKAGE_DIR)+clean::
	rm -rf $(LIBRARY)

# This is disgusting. Why can't I just depend on _and_ unpack
# $(EZ_FILE) ? Instead we have .done. targets to confuse matters...
# The reason for unpacking is that we can't dynamically load libraries
# that are within .ez files.
$(PACKAGE_DIR)+pre-run:: $(PACKAGE_DIR)/dist/.done.$(PACKAGE_VERSION)
	rm -rf $(PACKAGE_DIR)/dist/$(APP_NAME)-$(PACKAGE_VERSION)
	unzip $(PACKAGE_DIR)/dist/$(APP_NAME)-$(PACKAGE_VERSION).ez -d $(PACKAGE_DIR)/dist

$(PACKAGE_DIR)+pre-test:: $(PACKAGE_DIR)+pre-run

endef

