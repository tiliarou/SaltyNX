#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment. export DEVKITPRO=<path to>/devkitpro")
endif

TOPDIR ?= $(CURDIR)
include $(DEVKITPRO)/devkitA64/base_rules

all: libnx_min/nx/lib/libnx_min.a sdcard_out/SaltySD/saltysd_core.elf sdcard_out/SaltySD/saltysd_proc.elf sdcard_out/atmosphere/titles/0100000000534C56/exefs.nsp saltysd_plugin_example/saltysd_plugin_example.elf

libnx_min/nx/lib/libnx_min.a:
	@cd libnx_min && make

saltysd_spawner/saltysd_spawner.nsp:
	@cd saltysd_spawner && make

saltysd_proc/saltysd_proc.elf: saltysd_proc/data/saltysd_bootstrap.elf
	@cd saltysd_proc && make

saltysd_bootstrap/saltysd_bootstrap.elf:
	@cd saltysd_bootstrap && make

saltysd_core/saltysd_core.elf: libnx_min/nx/lib/libnx_min.a
	@cd saltysd_core && make

saltysd_plugin_example/saltysd_plugin_example.elf: libnx_min/nx/lib/libnx_min.a
	@cd saltysd_plugin_example && make

saltysd_proc/data/saltysd_bootstrap.elf: saltysd_bootstrap/saltysd_bootstrap.elf
	@mkdir -p saltysd_proc/data/
	@cp $< $@

sdcard_out/SaltySD/saltysd_core.elf: saltysd_core/saltysd_core.elf
	@mkdir -p sdcard_out/SaltySD/
	@cp $< $@

sdcard_out/SaltySD/saltysd_proc.elf: saltysd_proc/saltysd_proc.elf
	@mkdir -p sdcard_out/SaltySD/
	@cp $< $@

sdcard_out/atmosphere/titles/0100000000534C56/exefs.nsp: saltysd_spawner/saltysd_spawner.nsp
	@mkdir -p sdcard_out/atmosphere/titles/0100000000534C56/flags
	@cp $< $@
	@touch sdcard_out/atmosphere/titles/0100000000534C56/flags/boot2.flag

clean:
	@rm -f saltysd_proc/data/*
	@rm -f saltysd_spawner/data/*
	@cd libnx_min && make clean
	@cd saltysd_core && make clean
	@cd saltysd_bootstrap && make clean
	@cd saltysd_proc && make clean
	@cd saltysd_spawner && make clean
	@cd saltysd_plugin_example && make clean
