cmake_minimum_required(VERSION 3.16)

project(Wolfenstein3D VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(MSVC)
    add_compile_options(/std:c++17 /Zc:__cplusplus /permissive-)
endif()

set(_sdl2_config_dir "${CMAKE_CURRENT_SOURCE_DIR}/third_party/SDL2-2.32.8/cmake")
set(_sdl2_image_config_dir "${CMAKE_CURRENT_SOURCE_DIR}/third_party/SDL2_image-2.8.8/cmake")

if(EXISTS "${_sdl2_config_dir}/sdl2-config.cmake")
    set(SDL2_DIR "${_sdl2_config_dir}" CACHE PATH "SDL2 CMake package directory")
endif()
if(EXISTS "${_sdl2_image_config_dir}/sdl2_image-config.cmake")
    set(SDL2_image_DIR "${_sdl2_image_config_dir}" CACHE PATH "SDL2_image CMake package directory")
endif()

find_package(SDL2 REQUIRED)
find_package(SDL2_image REQUIRED)

add_executable(wolf3d
    src/main.cpp
    src/Game.cpp
    src/Raycaster.cpp
    src/Player.cpp
    src/Map.cpp
)

target_include_directories(wolf3d PRIVATE include)
target_compile_features(wolf3d PRIVATE cxx_std_17)

if(TARGET SDL2::SDL2)
    target_link_libraries(wolf3d PRIVATE SDL2::SDL2)
else()
    target_link_libraries(wolf3d PRIVATE SDL2::SDL2-static)
endif()

if(TARGET SDL2_image::SDL2_image)
    target_link_libraries(wolf3d PRIVATE SDL2_image::SDL2_image)
elseif(TARGET SDL2_image::SDL2_image-static)
    target_link_libraries(wolf3d PRIVATE SDL2_image::SDL2_image-static)
endif()

if(TARGET SDL2::SDL2main)
    target_link_libraries(wolf3d PRIVATE SDL2::SDL2main)
endif()

add_custom_command(TARGET wolf3d POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "$<TARGET_FILE:SDL2::SDL2>"
        "$<TARGET_FILE_DIR:wolf3d>"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "$<TARGET_FILE:SDL2_image::SDL2_image>"
        "$<TARGET_FILE_DIR:wolf3d>"
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${CMAKE_CURRENT_SOURCE_DIR}/assets"
        "$<TARGET_FILE_DIR:wolf3d>/assets"
    COMMENT "Copy SDL runtime DLLs and assets next to wolf3d"
)
