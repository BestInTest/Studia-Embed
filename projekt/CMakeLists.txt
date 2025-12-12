cmake_minimum_required(VERSION 3.20)

set(CMAKE_SYSTEM_NAME Generic)

# Ścieżka do kompilatora
set(CMAKE_C_COMPILER "/home/bowii/Desktop/embed/sdcc/bin/sdcc")

project(zegarek C)

set(CMAKE_C_OUTPUT_EXTENSION .rel)

set(CMAKE_C_FLAGS "")
set(CMAKE_C_FLAGS_DEBUG "")
set(CMAKE_C_FLAGS_RELEASE "")
set(CMAKE_EXE_LINKER_FLAGS "")

set(CMAKE_C_COMPILE_OBJECT "${CMAKE_C_COMPILER} -mmcs51 -c <SOURCE> -o <OBJECT>")
set(CMAKE_C_LINK_EXECUTABLE "${CMAKE_C_COMPILER} -mmcs51 <OBJECTS> -o <TARGET>")

add_executable(firmware zegarek.c)