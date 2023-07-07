.DEFAULT_GOAL := build

DOWNLOAD_DIR := download
OUTPUT_BIN := er605v2_openwrt_recovery.bin

.PHONY: build
build: $(OUTPUT_BIN)

$(OUTPUT_BIN): recovery_image/model.json recovery_image/model_files
	cd recovery_image; qemu-mipsel -L ../$(DOWNLOAD_DIR)/mipsel-linux-muslsf-native ../$(DOWNLOAD_DIR)/er605v2_gpl/staging_dir/host/bin/dkmgt_firmware_make -b -m model.json; rm ER605v2_*_flash.bin; mv ER605v2_*_up.bin $(OUTPUT_BIN); mv $(OUTPUT_BIN) ../

.PHONY: clean
clean:
	rm -f $(OUTPUT_BIN)

.PHONY: download
download:
	cd $(DOWNLOAD_DIR);wget -O - https://static.tp-link.com/upload/gpl-code/2022/202209/20220908/er605v2_gpl.tar.gz | tar zxf -
	cd $(DOWNLOAD_DIR);wget -O - https://musl.cc/mipsel-linux-muslsf-native.tgz | tar zxf -
	rm $(DOWNLOAD_DIR)/mipsel-linux-muslsf-native/lib/ld-musl-mipsel-sf.so.1
	cd $(DOWNLOAD_DIR)/mipsel-linux-muslsf-native/lib;ln -s libc.so ld-musl-mipsel-sf.so.1

.PHONY: clean
clean_download:
	rm -fr $(DOWNLOAD_DIR)/*

