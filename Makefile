VERSION=$(shell git describe --abbrev=0 --tags)

all: clean
	@mkdir build
	@go build -o build/pwngrid cmd/pwngrid/*.go
	@ls -la build/pwngrid

install:
	@cp build/pwngrid /usr/local/bin/
	@mkdir -p /etc/systemd/system/
	@mkdir -p /etc/pwngrid/
	@cp env.example /etc/pwngrid/pwngrid.conf
	@systemctl daemon-reload

clean:
	@rm -rf build

restart:
	@service pwngrid restart

release_files: clean
	@mkdir build
	@echo building for linux/armv6l ...
	@CGO_ENABLED=1 GOARM=6 GOARCH=arm GOOS=linux go build -o build/pwngrid cmd/pwngrid/*.go
	@zip -j "build/pwngrid_linux_armv6l_$(VERSION).zip" build/pwngrid > /dev/null
	@rm -rf build/pwngrid
	@echo building for linux/armv7l
	@CGO_ENABLED=1 GOARM=7 GOARCH=arm GOOS=linux go build -o build/pwngrid cmd/pwngrid/*.go
	@zip -j "build/pwngrid_linux_armv7l_$(VERSION).zip" build/pwngrid > /dev/null
	@rm -rf build/pwngrid
	@echo building for linux/armv8l ...
	@CGO_ENABLED=1 GOARCH=arm64 GOOS=linux go build -o build/pwngrid cmd/pwngrid/*.go
	@zip -j "build/pwngrid_linux_aarch64_$(VERSION).zip" build/pwngrid > /dev/null
	@rm -rf build/pwngrid
	@openssl dgst -sha256 "build/pwngrid_linux_armv6l_$(VERSION).zip" > "build/pwngrid-hashes.sha256"
	@openssl dgst -sha256 "build/pwngrid_linux_armv7l_$(VERSION).zip" > "build/pwngrid-hashes.sha256"
	@openssl dgst -sha256 "build/pwngrid_linux_aarch64_$(VERSION).zip" > "build/pwngrid-hashes.sha256"
	@ls -la build
