
project(suorb_test)

include(FetchContent)
FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG        e2239ee6043f73722e7aa812a459f54a28552929 # release-1.11.0
)
FetchContent_MakeAvailable(googletest)

file(GLOB src CONFIGURE_DEPENDS src/*.cc)
add_executable(${PROJECT_NAME} ${src})

target_link_libraries(${PROJECT_NAME} gmock gtest_main suorb pthread)

include(GoogleTest)
gtest_discover_tests(${PROJECT_NAME})
