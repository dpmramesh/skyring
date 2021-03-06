#
# Based on http://chrismckenzie.io/post/deploying-with-golang/
#

.PHONY: version all run dist clean
	
APP_NAME := skyring


ARCH := $(shell go env GOARCH)
GOOS := $(shell go env GOOS)
DIR=.

VERSION ="1.0"

# Go setup
GO=go
TEST=go test

# Sources and Targets
EXECUTABLES :=$(APP_NAME)
# Build Binaries setting main.version and main.build vars
LDFLAGS :=-ldflags "-X main.SKYRING_VERSION $(VERSION)"
# Package target
PACKAGE :=$(DIR)/dist/$(APP_NAME)-$(VERSION).$(GOOS).$(ARCH).tar.gz

.DEFAULT: all

all: build

# print the version
version:
	@echo $(VERSION)

# print the name of the app
name:
	@echo $(APP_NAME)

# print the package path
package:
	@echo $(PACKAGE)

build:
	$(GO) build $(LDFLAGS) -o $(APP_NAME)

run: build
	./$(APP_NAME)

test: 
	@$(TEST) -v ./...

clean:
	@echo Cleaning Workspace...
	rm -rf $(APP_NAME)
	rm -rf dist

$(PACKAGE): all
	@echo Packaging Binaries...
	@mkdir -p tmp/$(APP_NAME)
	@cp $(APP_NAME) tmp/$(APP_NAME)/
	@mkdir -p $(DIR)/dist/
	tar -czf $@ -C tmp $(APP_NAME);
	@rm -rf tmp
	@echo
	@echo Package $@ saved in dist directory

dist: $(PACKAGE)
