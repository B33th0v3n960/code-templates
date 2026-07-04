add_library(lib${PROJECT_NAME}
    main.c
)

target_include_directories(lib${PROJECT_NAME}
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(lib${PROJECT_NAME} PRIVATE project_options)

# buildin the main executable
add_executable(${PROJECT_NAME} main.c)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        lib${PROJECT_NAME} 
        project_options
)

