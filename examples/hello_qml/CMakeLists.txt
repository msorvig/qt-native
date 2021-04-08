project(hello_qml)
cmake_minimum_required(VERSION 3.19)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_AUTOMOC ON)

find_library(APP_KIT AppKit)
find_library(AV_FOUNDATION AVFoundation)
find_library(AV_KIT AVKit)

include_directories(../../src)

find_package(Qt6 COMPONENTS Core Gui Quick)

qt_add_resources(SOURCES hello.qrc)

add_executable(hello_qml
    MACOSX_BUNDLE
    ../../src/qtnative_mac.mm
    ../../src/qtnative_qml.cpp
    main.cpp
    ${SOURCES}
)
target_link_libraries(hello_qml ${APP_KIT} ${AV_FOUNDATION} ${AV_KIT} Qt6::Quick)

