
add_executable({{project_name}}
    src/{{project_name}}.cpp
    )


target_include_directories({{project_name}}
    PUBLIC include
    PRIVATE src
    )

target_link_libraries({{project_name}}
    PRIVATE
    project_options
    project_warnings
    PUBLIC
    clara::clara
    rang::rang
    Threads::Threads
    fmt::fmt
    spdlog::spdlog
    )



install(TARGETS {{project_name}}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}/
    RUNTIME DESTINATION       ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION       ${CMAKE_INSTALL_LIBDIR}
    INCLUDES DESTINATION      ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}/
    ARCHIVE DESTINATION       ${CMAKE_INSTALL_SHAREDSTATEDIR}
    )


if(ENABLE_TESTING)
    add_subdirectory(tests)
endif()
