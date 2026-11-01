#!/bin/bash
# PortMaster launch script - Ikemen GO (arm64)

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source "$controlfolder/control.txt"
[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"
get_controls

GAMEDIR="/$directory/ports/ikemen"
cd "$GAMEDIR" || exit 1

> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1

# Librerias incluidas (SDL2) + controles
export LD_LIBRARY_PATH="$GAMEDIR/lib:$LD_LIBRARY_PATH"
export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"
export SDL_VIDEODRIVER="${SDL_VIDEODRIVER:-kmsdrm}"

chmod +x "$GAMEDIR/Ikemen_GO.arm64"

# Hotkey de salida (Select+Start) via gptokeyb
$GPTOKEYB "Ikemen_GO.arm64" &

type pm_platform_helper >/dev/null 2>&1 && pm_platform_helper "$GAMEDIR/Ikemen_GO.arm64"

./Ikemen_GO.arm64

pm_finish
