-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function () 

  -- Sincronizador de D-Bus y Systemd con Wayland
  hl.exec_cmd("dbus-update-actication-environment --systemd WAYLAND_DISPLAY XD_CURRENT_DESKTOP")
  hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XD_CURRENT_DESKTOP")

  hl.exec_cmd("waybar")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("udiskie")
  
  -- Demonio para elephant y walker
  hl.exec_cmd("elephant")
  hl.exec_cmd("walker --gapplication-service")
end)
