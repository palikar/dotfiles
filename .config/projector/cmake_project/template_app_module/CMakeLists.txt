cmake_minimum_required(VERSION 3.2 FATAL_ERROR)




set(MODULE_NAME "%module_name%")
set(SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src")
set(INCL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/include")
set(INCL_DIR_PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/include")
set(BIN_NAME "${PROJECT_NAME}_${MODULE_NAME}")

message(STATUS "New module creted with name ${MODULE_NAME} and binary ${BIN_NAME}")
message(STATUS "Source directory:  ${SRC_DIR}")


SET(MODULE_SRC
  ${SRC_DIR}/${PROJECT_NAME}/${MODULE_NAME}/main.cpp
  )




#You don't really hava to touch that
add_executable(${BIN_NAME} ${MODULE_SRC})
target_include_directories(${BIN_NAME} PUBLIC ${INCL_DIR})
target_include_directories(${BIN_NAME} PRIVATE ${INCL_DIR_PRIVATE})
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wpedantic -Wextra")


#If other specific features are required, add them here
target_compile_features(${BIN_NAME}
    PUBLIC cxx_auto_type
    PUBLIC cxx_variadic_templates
    PUBLIC cxx_constexpr
    PUBLIC cxx_generic_lambdas
    PUBLIC cxx_nullptr
    PUBLIC cxx_noexcept
    PUBLIC cxx_static_assert
    PUBLIC cxx_variable_templates)

install(
  TARGETS ${BIN_NAME} DESTINATION "bin"
  ) 


install(
  DIRECTORY "${INCL_DIR}/${PROJECT_NAME}"
  DESTINATION include
  FILES_MATCHING PATTERN "*.h*"
  )
      


  ###########################################
  ####         Libraries                 ####
  ###########################################

  #Add and link against libraries(3rd party OR other modules) here

  #target_link_libraries(${BIN_NAME} PUBLIC lib)




