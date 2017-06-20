project (com.github.keyilan.swatches)
cmake_minimum_required (VERSION 2.6)

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/src)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

set (PKGDATADIR "${DATADIR}/com.github.keyilan.swatches")

set (EXEC_NAME "com.github.keyilan.swatches")
set (RELEASE_NAME "Swatches")
set (VERSION "0.1")
set (VERSION_INFO "Initial build")

find_package(PkgConfig)

pkg_check_modules(DEPS REQUIRED
    gtk+-3.0
    granite
    glib-2.0
)

add_definitions(${DEPS_CFLAGS})
link_libraries(${DEPS_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS})

find_package(Vala REQUIRED)
include(ValaVersion)
ensure_vala_version("0.16" MINIMUM)

include(ValaPrecompile)
vala_precompile(VALA_C ${EXEC_NAME}
    src/Application.vala
    src/MainWindow.vala
    src/Stylesheet.vala

PACKAGES
    granite
    gtk+-3.0
    glib-2.0
)

add_executable(${EXEC_NAME} ${VALA_C})
target_link_libraries(com.github.keyilan.swatches m)

install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.keyilan.swatches.desktop DESTINATION ${DATADIR}/applications/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/32/com.github.keyilan.swatches.svg DESTINATION share/icons/hicolor/32x32/apps)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/48/com.github.keyilan.swatches.svg DESTINATION share/icons/hicolor/48x48/apps)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/64/com.github.keyilan.swatches.svg DESTINATION share/icons/hicolor/64x64/apps)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/128/com.github.keyilan.swatches.svg DESTINATION share/icons/hicolor/128x128/apps)

include (GSettings)
add_schema ("data/com.github.keyilan.swatches.gschema.xml")

#translation files
set (GETTEXT_PACKAGE "${CMAKE_PROJECT_NAME}")
add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
add_subdirectory (po)
