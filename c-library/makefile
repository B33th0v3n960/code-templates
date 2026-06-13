# Project Info
PROJECT_NAME 	:= template
PROJECT_VERSION := v0.0.1

# Compiler and flags
CC      := gcc
CFLAGS  := -Wall -Wextra -std=c11 -Iinclude -fPIC
LDFLAGS := 
LDLIBS  := # -lm
# MAKEFLAGS += -j$(shell nproc)

# Directories
SRC_DIR   	:= src
INC_DIR   	:= include
BUILD_DIR 	:= build
BIN_DIR   	:= bin
TEST_DIR  	:= tests
UNITY_DIR 	:= $(TEST_DIR)/unity
DIST_DIR  	:= dist/
PACKAGE_DIR := $(DIST_DIR)/$(PROJECT_NAME)-$(PROJECT_VERSION)


# Files
TARGET    := $(BIN_DIR)/$(PROJECT_NAME)
STATIC    := $(BUILD_DIR)/lib$(PROJECT_NAME).a
SHARED    := $(BUILD_DIR)/lib$(PROJECT_NAME).so

SRCS     := $(wildcard $(SRC_DIR)/*.c)
OBJS     := $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRCS))
LIB_OBJS := $(filter-out $(BUILD_DIR)/main.o, $(OBJS))


# find all test files → produce a binary for each
TEST_SRCS   := $(wildcard $(TEST_DIR)/test_*.c)
TEST_BINS   := $(patsubst $(TEST_DIR)/%.c, $(BUILD_DIR)/%, $(TEST_SRCS))
TEST_CFLAGS := $(CFLAGS) -I$(UNITY_DIR)

# unity object
UNITY_OBJ := $(BUILD_DIR)/unity.o

.PHONY: all
all: $(TARGET) static shared

# Link
$(TARGET): $(OBJS) | $(BIN_DIR)
	$(CC) $(LDFLAGS) $^ -o $@ $(LDLIBS)

.PHONY: static
static: $(STATIC)

$(STATIC): $(LIB_OBJS) | $(BUILD_DIR)
	ar rcs $@ $^

.PHONY: shared
shared: $(SHARED)

$(SHARED): $(LIB_OBJS) | $(BUILD_DIR)
	$(CC) -shared -o $@ $^ $(LDLIBS)

# Compile each .c → .o
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Build unity object 
$(UNITY_OBJ): $(TEST_DIR)/unity/unity.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Build each test binary
$(BUILD_DIR)/%: $(TEST_DIR)/%.c $(LIB_OBJS) $(UNITY_OBJ) | $(BUILD_DIR)
	$(CC) $(TEST_CFLAGS) $(LDFLAGS) $^ -o $@ $(LDLIBS)

$(BUILD_DIR) $(BIN_DIR):
	mkdir -p $@

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR) $(DIST_DIR)

.PHONY: run
run: all
	./$(TARGET)

.PHONY: debug
debug: CFLAGS  += -g -DDEBUG -fsanitize=address,undefined -fno-omit-frame-pointer
debug: LDFLAGS += -fsanitize=address,undefined
debug: all

.PHONY: release
release: CFLAGS += -O2 -DNDEBUG
release: all

.PHONY: test
test: $(TEST_BINS)
	@bash scripts/run_tests.sh

.PHONY: compile_flags
compile_flags:
	@printf '%s\n' $(CFLAGS) > compile_flags.txt

.PHONY: compile_flags_test
compile_flags_test:
	@printf '%s\n' $(TEST_CFLAGS) > compile_flags.txt

.PHONY: package
package: release
	mkdir -p $(PACKAGE_DIR)/lib $(PACKAGE_DIR)/include
	cp $(STATIC) $(SHARED) $(PACKAGE_DIR)/lib/
	cp $(INC_DIR)/*.h      $(PACKAGE_DIR)/include/
	tar -czf $(DIST_DIR)/$(PROJECT_NAME)-$(PROJECT_VERSION).tar.gz -C $(DIST_DIR) $(PROJECT_NAME)-$(PROJECT_VERSION)
	@echo "Packaged → $(DIST_DIR)/$(PROJECT_NAME)-$(PROJECT_VERSION).tar.gz"

# Help message
.PHONY: help
help:
	@echo $(PROJECT_NAME) @ $(PROJECT_VERSION)
	@echo
	@echo "Target rules:"
	@echo "    all                  - Compiles and generates binary file"
	@echo "    run                  - Runs the compiled binary file"
	@echo "    static               - Build static library"
	@echo "    shared               - Build shared library"
	@echo "    tests                - Compile and run tests binary file"
	@echo "    compile_flags        - Creates the compile_flags.txt with the CFLAGS values"
	@echo "    compile_flags_test   - Creates the compile_flags.txt with the TEST_CFLAGS values"
	@echo "    package              - Bundle lib/ and include/ into a tarball"
	@echo "    debug                - Build with sanitizers and debug symbols"
	@echo "    release              - Build with optimizations"
	@echo "    clean                - Clean the project by removing binaries and object files"
	@echo "    help                 - Prints a help message with target rules"
