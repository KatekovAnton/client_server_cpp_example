cmake_minimum_required(VERSION 3.5.1)
set(CMAKE_CXX_STANDARD 17)
set(PROJECT_NAME Server)
set(TARGET_NAME ${PROJECT_NAME})



IF(APPLE)
    SET (PROJECT_OS_MACOS TRUE BOOL INTERNAL)
ENDIF (APPLE)
IF(WIN32)
    SET (PROJECT_OS_WIN32 TRUE BOOL INTERNAL)
ENDIF (WIN32)
if(UNIX AND NOT APPLE) 
    SET (PROJECT_OS_LINUX TRUE BOOL INTERNAL)
ENDIF (UNIX AND NOT APPLE)



project(${PROJECT_NAME} C CXX)



include_directories("${PROJECT_SOURCE_DIR}")
include_directories("${PROJECT_SOURCE_DIR}/../third_party/anyoption")



file(GLOB_RECURSE PROJECT_SOURCES 
    ${PROJECT_SOURCE_DIR}/*.*
)



if(CMAKE_GENERATOR STREQUAL Xcode)

    set(CMAKE_OSX_DEPLOYMENT_TARGET "10.14")
    add_executable(${PROJECT_NAME} 
        ${PROJECT_SOURCES})

elseif(PROJECT_OS_MACOS)

    set(CMAKE_OSX_DEPLOYMENT_TARGET "10.14")
    add_executable(${PROJECT_NAME} MACOSX_BUNDLE 
        ${PROJECT_SOURCES})

    add_custom_command(TARGET ${PROJECT_NAME} 
        POST_BUILD COMMAND 
        ${CMAKE_INSTALL_NAME_TOOL} -add_rpath "@executable_path/../../Frameworks/"
        $<TARGET_FILE:${PROJECT_NAME}>)

elseif(WIN32)

    add_executable(${PROJECT_NAME} WIN32 
        ${PROJECT_SOURCES})
        
else ()

    add_executable(${PROJECT_NAME} ${PROJECT_SOURCES})
    
endif()



if (PROJECT_OS_MACOS)

    list(APPEND SRE_INCLUDE_DIRS /System/Library/Frameworks)
    
    target_link_libraries(${PROJECT_NAME} "-framework Cocoa")
    target_link_libraries(${PROJECT_NAME} "-lc")
    
endif()

target_link_libraries(${PROJECT_NAME} anyoption)
target_link_libraries(${PROJECT_NAME} Poco::Net Poco::Util Poco::JSON)
