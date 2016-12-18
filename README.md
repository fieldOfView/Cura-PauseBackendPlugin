# PauseBackendPlugin
A plugin/hack to pause and resume autoslicing in Cura.
When paused, the save area will say Cura is "Unable to Slice", and you cannot save or print the gcode.

Note: this plugin illegally accesses a private member of the CuraEngineBackend plugin, and may break at any time.

Installation
----
  - Make sure your Cura version is 2.2 or newer
  - Download or clone the repository into [Cura installation folder]/plugins/PauseBackendPlugin
    or in the plugins folder inside the configuration folder. The configuration folder can be
    found via Help -> Show Configuration Folder inside Cura.
    NB: The folder of the plugin itself *must* be ```PauseBackendPlugin```
