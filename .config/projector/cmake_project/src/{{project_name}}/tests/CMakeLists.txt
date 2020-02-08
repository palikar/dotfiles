add_executable({{project_name}}_test
    {{project_name}}_test.cpp
    )

target_include_directories({{project_name}}_test
    PUBLIC ../include
    PRIVATE ../src
    )


target_link_libraries({{project_name}}_test
    PRIVATE
    project_options
    project_warnings
    PUBLIC
    rang::rang
    Threads::Threads
    fmt::fmt
    spdlog::spdlog
    absl::strings
    Catch2::Catch2)


include(CTest)
include(Catch)

catch_discover_tests({{project_name}}_test)
