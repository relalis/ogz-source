add_library(bullet INTERFACE)

find_library(BulletCollision_Debug_path NAMES BulletCollision PATHS lib/Debug)
find_library(LinearMath_Debug_path    NAMES LinearMath    PATHS lib/Debug)
find_library(BulletCollision_Release_path NAMES BulletCollision PATHS lib/Release)
find_library(LinearMath_Release_path    NAMES LinearMath    PATHS lib/Release)

# attach Debug libs only for Debug config, Release libs only for Release (and other non-Debug)
target_link_libraries(bullet INTERFACE
  $<$<CONFIG:Debug>:${BulletCollision_Debug_path}>
  $<$<CONFIG:Debug>:${LinearMath_Debug_path}>
  $<$<CONFIG:RelWithDebInfo>:${BulletCollision_Release_path}>
  $<$<CONFIG:RelWithDebInfo>:${LinearMath_Release_path}>
  $<$<CONFIG:Release>:${BulletCollision_Release_path}>
  $<$<CONFIG:Release>:${LinearMath_Release_path}>
)

message(STATUS "Bullet Debug paths: ${BulletCollision_Debug_path} ${LinearMath_Debug_path}")
message(STATUS "Bullet Release paths: ${BulletCollision_Release_path} ${LinearMath_Release_path}")