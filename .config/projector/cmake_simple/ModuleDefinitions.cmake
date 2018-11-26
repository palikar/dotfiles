cmake_minimum_required(VERSION 3.2 FATAL_ERROR)


set(SRC_DIR "src")
set(INCL_DIR "include")
set(INCL_DIR_PRIVATE "include_private")
set(BIN_NAME "{{main_file}}")

set(MODULE_SRC
    ${SRC_DIR}/{{main_file}}.cpp
    )
#######################################
########Executable setup###############
######################################
add_executable(${BIN_NAME} ${MODULE_SRC})
target_include_directories(${BIN_NAME} PUBLIC ${INCL_DIR})
target_include_directories(${BIN_NAME} PRIVATE ${INCL_DIR_PRIVATE})
target_compile_features(${BIN_NAME}
    PUBLIC cxx_auto_type
    PUBLIC cxx_variadic_templates
    PUBLIC cxx_constexpr
    PUBLIC cxx_generic_lambdas
    PUBLIC cxx_nullptr
    PUBLIC cxx_noexcept
    PUBLIC cxx_static_assert
    PUBLIC cxx_variable_templates
    )
set_target_properties(${BIN_NAME} PROPERTIES
    CXX_STANDARD 17
    CXX_EXTENSIONS OFF
    )
install(TARGETS ${BIN_NAME} DESTINATION "bin")
install(
    DIRECTORY "${INCL_DIR}/${PROJECT_NAME}"
    DESTINATION include
    FILES_MATCHING PATTERN "*.h*"
    )

#           Dependencies             #
######################################

#find_package(Boost COMPONENTS program_options system filesystem REQUIRED)
#target_link_libraries(${BIN_NAME} ${Boost_LIBRARIES} )

#find_package(OpenCV REQUIRED)
#target_link_libraries(${BIN_NAME} ${OpenCV_LIBS} )




