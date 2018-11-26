cmake_minimum_required(VERSION 3.2 FATAL_ERROR)
project(%project_name% LANGUAGES CXX)

set(MODULE_LIST)




macro(add_project_module NAME DIRECTORY)
    list(APPEND MODULE_LIST "${NAME}")
    set(${NAME}_DIR "${DIRECTORY}")
endmacro(add_project_module)



macro(configure_modules )
    foreach(ARG ${MODULE_LIST})                         
        option(WITH_${ARG} "Module option" ON)
    endforeach()


    foreach(ARG ${MODULE_LIST})
        if(${WITH_${ARG}})
            message(STATUS "Adding direcotry: ${ARG}")
            add_subdirectory(${${ARG}_DIR})
        endif(${WITH_${ARG}})
    endforeach()
    
endmacro(configure_modules)



include(ModuleDefinitions.cmake)


configure_modules()
