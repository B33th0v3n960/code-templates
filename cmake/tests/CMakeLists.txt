add_library(unity STATIC unity/unity.c)
target_include_directories(unity PUBLIC unity/)

function(add_myproject_test test_name)
    add_executable(${test_name} ${test_name}.c ${ARGN})
    target_link_libraries(${test_name}
        PRIVATE
            ${PROJECT_NAME}_lib
            project_options
            unity
    )
    add_test(NAME ${test_name} COMMAND ${test_name})
endfunction()

# add_myproject_test(test_name)
