cmake_minimum_required(VERSION 3.5.1)
set(CMAKE_CXX_STANDARD 17)
set(PROJECT_NAME Client)
set(TARGET_NAME ${PROJECT_NAME})
project(${PROJECT_NAME} C CXX)


IF(APPLE)
    SET (PROJECT_OS_MACOS TRUE BOOL INTERNAL)
ENDIF (APPLE)
IF(WIN32)
    SET (PROJECT_OS_WIN32 TRUE BOOL INTERNAL)
ENDIF (WIN32)
if(UNIX AND NOT APPLE) 
    SET (PROJECT_OS_LINUX TRUE BOOL INTERNAL)
ENDIF (UNIX AND NOT APPLE)


add_subdirectory(third_party/anyoption)
add_subdirectory(third_party/poco)
add_subdirectory(Server)
add_subdirectory(Client)


set(CMAKE_INSTALL_PREFIX ${PROJECT_BINARY_DIR}/install)
