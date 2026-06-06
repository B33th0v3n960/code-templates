#!/bin/bash
set -e  # exit on first failure

BUILD_DIR="build"
FAILED=0

for t in "$BUILD_DIR"/test_*; do
    echo "Running $t..."
    if ! ./"$t"; then
        echo "FAILED: $t"
        FAILED=1
    fi
done

if [ $FAILED -eq 0 ]; then
    echo "All tests passed."
else
    echo "Some tests FAILED."
    exit 1
fi
