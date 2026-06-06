# Project Info
PROJECT_NAME 	:= template
PROJECT_VERSION := v0.0.1

# Compiler and flags
CC      := gcc
CFLAGS  := -Wall -Wextra -std=c11 -Iinclude
LDFLAGS :=
LDLIBS  :=
# MAKEFLAGS += -j$(shell nproc)

# Directories
SRC_DIR   := src
INC_DIR   := include
BUILD_DIR := build
BIN_DIR   := bin
TEST_DIR  := tests
UNITY_DIR := $(TEST_DIR)/unity

# Files
TARGET   := $(BIN_DIR)/app
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
all: $(TARGET)

# Link
$(TARGET): $(OBJS) | $(BIN_DIR)
	$(CC) $(LDFLAGS) $^ -o $@ $(LDLIBS)

# Compile each .c → .o
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Build unity object 
$(UNITY_OBJ): $(TEST_DIR)/unity/unity.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Build each test binary
$(BUILD_DIR)/%: $(TEST_DIR)/%.c $(LIB_OBJS) $(UNITY_OBJ) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@ $(LDLIBS)

$(BUILD_DIR) $(BIN_DIR):
	mkdir -p $@

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)

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

# Help message
.PHONY: help
help:
	@echo $(PROJECT_NAME) @ $(PROJECT_VERSION)
	@echo
	@echo "Target rules:"
	@echo "    all              - Compiles and generates binary file"
	@echo "    run              - Runs the compiled binary file"
	@echo "    tests            - Compile and run tests binary file"
	@echo "    compile_flags    - Creates the compile_flags.txt with the CFLAGS values"
	@echo "    debug            - Build with sanitizers and debug symbols"
	@echo "    release          - Build with optimizations"
	@echo "    clean            - Clean the project by removing binaries and object files"
	@echo "    help             - Prints a help message with target rules"
