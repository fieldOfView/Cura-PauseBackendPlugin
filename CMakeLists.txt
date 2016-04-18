project(PostProcessingPlugin)

cmake_minimum_required(VERSION 2.8.12)

find_package(PythonInterp 3.4.0 REQUIRED)

install(FILES
    __init__.py
    PauseBackend.py
    PauseBackend.qml
    pause.svg
    play.svg
    LICENSE
    README.md
    DESTINATION lib/cura/plugins/PauseBackendPlugin
)
