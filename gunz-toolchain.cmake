set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x86)

set(CMAKE_C_COMPILER clang-cl-19)
set(CMAKE_CXX_COMPILER clang-cl-19)
set(CMAKE_AR llvm-lib-19)
set(CMAKE_LINKER lld-link-19)
set(CMAKE_MT llvm-mt-19)
set(CMAKE_RC_COMPILER llvm-rc-19)

# Windows SDK root (set from env or cmake arg)
if(DEFINED ENV{WINDOWS_TOOLCHAIN_PATH})
    set(WINSDK_DIR "$ENV{WINDOWS_TOOLCHAIN_PATH}")
else()
    message(FATAL_ERROR "WINDOWS_TOOLCHAIN_PATH not set in environment!")
endif()

set(CMAKE_EXE_LINKER_FLAGS
    "/libpath:${WINSDK_DIR}/sdk/lib/um/x86 \
     /libpath:${WINSDK_DIR}/sdk/lib/ucrt/x86 \
     /libpath:${WINSDK_DIR}/crt/lib/x86")

set(CMAKE_LIB_FLAGS /machine:x86)
set(CMAKE_STATIC_LINKER_FLAGS "/machine:x86")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

add_definitions(-DBT_NO_SIMD_OPERATOR_OVERLOADS)
add_definitions(" --target=i686-pc-windows-msvc"
                "-vctoolsdir" "${WINSDK_DIR}/crt"
                "-winsdkdir" "${WINSDK_DIR}/sdk"
                "-fuse-ld=lld"
                "/EHsc"
                "-fms-runtime-lib=static")
add_compile_definitions(WIN32)
