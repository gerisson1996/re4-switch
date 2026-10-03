ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment. export DEVKITPRO=<path to>/devkitpro")
endif

TOPDIR ?= $(CURDIR)
include $(DEVKITPRO)/libnx/switch_rules

TARGET      := re4-switch
BUILD       := build
SOURCES     := source source/gxvk
DATA        :=
INCLUDES    := include

# Path produced by HayatoG/switch-nvk/package-nvk.sh.
# Example: make NVK_SWITCH=/opt/switch-nvk/nvk-switch
NVK_SWITCH ?= $(CURDIR)/external/nvk-switch

ARCH        := -march=armv8-a+crc+crypto -mtune=cortex-a57 -mtp=soft -fPIE
CFLAGS      := -g -Wall -O2 -ffunction-sections $(ARCH) $(DEFINES)
CFLAGS      += $(INCLUDE) -D__SWITCH__
CXXFLAGS    := $(CFLAGS) -fno-rtti -fno-exceptions -std=gnu++17
ASFLAGS     := -g $(ARCH)
LDFLAGS     = -specs=$(DEVKITPRO)/libnx/switch.specs -g $(ARCH) -Wl,-Map,$(notdir $*.map)
LIBS        := -lvulkan -lnx
LIBDIRS     := $(NVK_SWITCH) $(PORTLIBS) $(LIBNX)

ifneq ($(BUILD),$(notdir $(CURDIR)))
export OUTPUT := $(CURDIR)/$(TARGET)
export TOPDIR := $(CURDIR)
export VPATH  := $(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) $(foreach dir,$(DATA),$(CURDIR)/$(dir))
export DEPSDIR := $(CURDIR)/$(BUILD)

CFILES   := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
SFILES   := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
BINFILES := $(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.*)))

export LD := $(CXX)
export OFILES_BIN := $(addsuffix .o,$(BINFILES))
export OFILES_SRC := $(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o)
export OFILES := $(OFILES_BIN) $(OFILES_SRC)
export HFILES_BIN := $(addsuffix .h,$(subst .,_,$(BINFILES)))
export INCLUDE := $(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
                  -I$(NVK_SWITCH)/include \
                  $(foreach dir,$(PORTLIBS) $(LIBNX),-I$(dir)/include) \
                  -I$(CURDIR)/$(BUILD)
export LIBPATHS := -L$(NVK_SWITCH)/lib $(foreach dir,$(PORTLIBS) $(LIBNX),-L$(dir)/lib)

.PHONY: all clean check-nvk
all: check-nvk $(BUILD)

check-nvk:
	@test -f "$(NVK_SWITCH)/lib/libvulkan.a" || (echo "ERROR: $(NVK_SWITCH)/lib/libvulkan.a not found"; echo "Build/package HayatoG/switch-nvk first, then set NVK_SWITCH=<path>/nvk-switch"; exit 1)
	@test -f "$(NVK_SWITCH)/include/vulkan/vulkan.h" || (echo "ERROR: Vulkan headers not found in $(NVK_SWITCH)/include"; exit 1)

$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

clean:
	@echo clean ...
	@rm -fr $(BUILD) $(TARGET).nro $(TARGET).nacp $(TARGET).elf

else
DEPENDS := $(OFILES:.o=.d)

$(OUTPUT).nro: $(OUTPUT).elf
$(OUTPUT).elf: $(OFILES)

-include $(DEPENDS)
endif
