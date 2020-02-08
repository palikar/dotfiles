add_executable(${PROJECT_NAME}_MODULE_NAME
    src/main.cpp
    )


target_include_directories(${PROJECT_NAME}_MODULE_NAME
    PUBLIC include
    PRIVATE src
    )

target_link_libraries(${PROJECT_NAME}_MODULE_NAME
    PRIVATE
    project_options
    project_warnings
    PUBLIC
    Threads::Threads
    fmt::fmt
    spdlog::spdlog
    )



install(TARGETS ${PROJECT_NAME}_main_app
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}/
    RUNTIME DESTINATION       ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION       ${CMAKE_INSTALL_LIBDIR}
    INCLUDES DESTINATION      ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}/
    ARCHIVE DESTINATION       ${CMAKE_INSTALL_SHAREDSTATEDIR}
    )





if(ENABLE_TESTING)
    add_subdirectory(tests)
endif()
