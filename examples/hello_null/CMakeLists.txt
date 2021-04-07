project(hello_null)
cmake_minimum_required(VERSION 3.19)
set(CMAKE_CXX_STANDARD 14)

include_directories(../../src)

add_executable(hello_null
    ../../src/qtnative_null.cpp
    main.cpp
)
