cmake_minimum_required(VERSION 3.15)
project(iphony)
set(CMAKE_CXX_STANDARD 17)

find_package(Taglib REQUIRED)
include_directories(${TAGLIB_INCLUDE_DIRS})

add_executable(iphony iphony.cpp)
target_link_libraries(iphony ${TAGLIB_LIBRARIES})
