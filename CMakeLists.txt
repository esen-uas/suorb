cmake_minimum_required(VERSION 3.14)

project(suorb)


option(ENABLE_GCC_COVERAGE "Enable gcc coverage" OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

file(GLOB_RECURSE src CONFIGURE_DEPENDS "src/*.cc")

add_library(${PROJECT_NAME} ${src})

target_include_directories(${PROJECT_NAME} PUBLIC include)

# target_link_libraries(${PROJECT_NAME} PUBLIC

# )

set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 17)

if(ENABLE_GCC_COVERAGE)
  add_compile_options(--coverage)
  target_link_libraries(${PROJECT_NAME} PRIVATE gcov)
endif()

install(TARGETS ${PROJECT_NAME}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

enable_testing()
add_subdirectory(test)
