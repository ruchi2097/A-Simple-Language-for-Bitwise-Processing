# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.27

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /ece566/projects/p1/C++

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /ece566/projects/p1/C++/build

# Include any dependencies generated for this target.
include tests/CMakeFiles/test_8.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include tests/CMakeFiles/test_8.dir/compiler_depend.make

# Include the progress variables for this target.
include tests/CMakeFiles/test_8.dir/progress.make

# Include the compile flags for this target's objects.
include tests/CMakeFiles/test_8.dir/flags.make

tests/test_8.bc.o: tests/test_8.bc
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/ece566/projects/p1/C++/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Generating test_8.bc.o"
	cd /ece566/projects/p1/C++/build/tests && clang-17 -c -o /ece566/projects/p1/C++/build/tests/test_8.bc.o /ece566/projects/p1/C++/build/tests/test_8.bc

tests/test_8.bc: p1
tests/test_8.bc: /ece566/projects/p1/C++/tests/test_8.p1
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/ece566/projects/p1/C++/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Generating test_8.bc"
	cd /ece566/projects/p1/C++/build/tests && ../p1 /ece566/projects/p1/C++/tests/test_8.p1 /ece566/projects/p1/C++/build/tests/test_8.bc

tests/CMakeFiles/test_8.dir/test_8.c.o: tests/CMakeFiles/test_8.dir/flags.make
tests/CMakeFiles/test_8.dir/test_8.c.o: /ece566/projects/p1/C++/tests/test_8.c
tests/CMakeFiles/test_8.dir/test_8.c.o: tests/CMakeFiles/test_8.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/ece566/projects/p1/C++/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building C object tests/CMakeFiles/test_8.dir/test_8.c.o"
	cd /ece566/projects/p1/C++/build/tests && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT tests/CMakeFiles/test_8.dir/test_8.c.o -MF CMakeFiles/test_8.dir/test_8.c.o.d -o CMakeFiles/test_8.dir/test_8.c.o -c /ece566/projects/p1/C++/tests/test_8.c

tests/CMakeFiles/test_8.dir/test_8.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/test_8.dir/test_8.c.i"
	cd /ece566/projects/p1/C++/build/tests && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /ece566/projects/p1/C++/tests/test_8.c > CMakeFiles/test_8.dir/test_8.c.i

tests/CMakeFiles/test_8.dir/test_8.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/test_8.dir/test_8.c.s"
	cd /ece566/projects/p1/C++/build/tests && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /ece566/projects/p1/C++/tests/test_8.c -o CMakeFiles/test_8.dir/test_8.c.s

# Object files for target test_8
test_8_OBJECTS = \
"CMakeFiles/test_8.dir/test_8.c.o"

# External object files for target test_8
test_8_EXTERNAL_OBJECTS = \
"/ece566/projects/p1/C++/build/tests/test_8.bc.o"

tests/test_8: tests/CMakeFiles/test_8.dir/test_8.c.o
tests/test_8: tests/test_8.bc.o
tests/test_8: tests/CMakeFiles/test_8.dir/build.make
tests/test_8: tests/CMakeFiles/test_8.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/ece566/projects/p1/C++/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Linking C executable test_8"
	cd /ece566/projects/p1/C++/build/tests && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/test_8.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tests/CMakeFiles/test_8.dir/build: tests/test_8
.PHONY : tests/CMakeFiles/test_8.dir/build

tests/CMakeFiles/test_8.dir/clean:
	cd /ece566/projects/p1/C++/build/tests && $(CMAKE_COMMAND) -P CMakeFiles/test_8.dir/cmake_clean.cmake
.PHONY : tests/CMakeFiles/test_8.dir/clean

tests/CMakeFiles/test_8.dir/depend: tests/test_8.bc
tests/CMakeFiles/test_8.dir/depend: tests/test_8.bc.o
	cd /ece566/projects/p1/C++/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /ece566/projects/p1/C++ /ece566/projects/p1/C++/tests /ece566/projects/p1/C++/build /ece566/projects/p1/C++/build/tests /ece566/projects/p1/C++/build/tests/CMakeFiles/test_8.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : tests/CMakeFiles/test_8.dir/depend

