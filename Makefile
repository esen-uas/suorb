
SHELL := /usr/bin/bash

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT


ifneq ($(VERBOSE),)
CMAKE_VERBOSE=--verbose
endif

default: test

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)
.PHONY: help

build:
	cmake -B build $(CMAKE_VERBOSE)
	cmake --build build $(CMAKE_VERBOSE)
.PHONY:build

build-clang:
	cmake -B build $(CMAKE_VERBOSE) -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/clang-cxx17.cmake .
	cmake --build build $(CMAKE_VERBOSE)
.PHONY:build

test: build
	cd build &&	ctest $(CMAKE_VERBOSE)
.PHONY:test

coverage-gcc: build
	cmake $(CMAKE_VERBOSE) -B build  -DENABLE_GCC_COVERAGE=ON .
	cmake $(CMAKE_VERBOSE) --build build
	cd build &&	ctest $(CMAKE_VERBOSE)
	cd build/test/CMakeFiles/suorb_test.dir/src && gcov -jkm *.o
.PHONY:coverage

docs:
	mkdir -p build/docs
	doxygen Doxyfile
	WARN_COUNT=$(cat build/doxy.err | wc -l)
	echo "Doxygen warning log size: ${WARN_COUNT}"
	exit ${WARN_COUNT}
.PHONY:docs

cpplint:
	cpplint --filter=-readability/nolint $$(find src include -iname \*.h -or -name \*.cc)
.PHONY:cpplint

clang-format:
	find src include -iname '*.h' -o -iname '*.cc' | xargs clang-format $(CMAKE_VERBOSE) -i -style=file
.PHONY:clang-format

format: clang-format
.PHONY:format

cppcheck:
	cppcheck src include
.PHONY:cppcheck

clang-tidy: build
	find src include -iname '*.h' -o -iname '*.cc' | xargs clang-tidy $(CMAKE_VERBOSE) -p build
.PHONY:clang-tidy

static-analysis: cppcheck clang-tidy
.PHONY:static-analysis

lwyu:
	cmake -B build -DCMAKE_LINK_WHAT_YOU_USE=TRUE
	cmake --build build
.PHONY:lwyu

iwyu:
	cmake -B build -DCMAKE_CXX_INCLUDE_WHAT_YOU_USE="/usr/local/bin/include-what-you-use"
	cmake --build build
.PHONY:iwyu

clean:
	rm -rf build/
.PHONY:clean
