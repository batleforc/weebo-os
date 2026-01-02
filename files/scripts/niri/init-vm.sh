#!/usr/bin/env bash

set -oue pipefail

# Create niri config directory if it doesn't exist
mkdir -p /etc/skel/.config/niri

# Create VM-optimized Niri configuration
cat > /etc/skel/.config/niri/config.kdl << 'EOF'
// VM-optimized Niri configuration
// This config forces software rendering for VM compatibility

// Use software rendering to avoid OpenGL issues in VMs
renderer {
    // Force software rendering
    rendering-driver "software"
    // Alternative: specify specific driver if needed
    // rendering-driver "llvmpipe"
}

// Basic input configuration
input {
    keyboard {
        xkb {
            layout "us"
        }
    }
    
    touchpad {
        tap
        dwt
        natural-scroll
    }
    
    mouse {
        natural-scroll false
    }
}

// Window management
window-rules {
    geometry-corner-radius 8
    border {
        width 2
        active-color 80 160 255 255
        inactive-color 128 128 128 255
    }
}

// Workspaces
workspaces {
    "1"
    "2" 
    "3"
    "4"
    "5"
}

// Keybindings
binds {
    // Launch terminal
    Mod+Return { spawn "ghostty"; }
    
    // Launch application launcher (if available)
    Mod+D { spawn "rofi" "-show" "drun"; }
    
    // Window management
    Mod+Q { close-window; }
    Mod+F { fullscreen-window; }
    
    // Workspace switching
    Mod+1 { focus-workspace 1; }
    Mod+2 { focus-workspace 2; }
    Mod+3 { focus-workspace 3; }
    Mod+4 { focus-workspace 4; }
    Mod+5 { focus-workspace 5; }
    
    // Move windows to workspaces
    Mod+Shift+1 { move-window-to-workspace 1; }
    Mod+Shift+2 { move-window-to-workspace 2; }
    Mod+Shift+3 { move-window-to-workspace 3; }
    Mod+Shift+4 { move-window-to-workspace 4; }
    Mod+Shift+5 { move-window-to-workspace 5; }
    
    // Layout management
    Mod+Shift+Left { move-window-left; }
    Mod+Shift+Right { move-window-right; }
    Mod+Shift+Up { move-window-up; }
    Mod+Shift+Down { move-window-down; }
    
    // Quit niri
    Mod+Shift+E { quit; }
}

// Screenshots and screen capture
screenshot-path "~/Pictures/Screenshots/%Y-%m-%d_%H-%M-%S.png"
EOF

# Also create a runtime environment setup script
cat > /usr/local/bin/niri-vm-env << 'EOF'
#!/bin/bash

# Environment variables for VM compatibility
export LIBGL_ALWAYS_SOFTWARE=1
export GALLIUM_DRIVER=llvmpipe
export MESA_GL_VERSION_OVERRIDE=3.3
export MESA_GLSL_VERSION_OVERRIDE=330

# Fallback to software rendering
export __GLX_VENDOR_LIBRARY_NAME=mesa
export MESA_LOADER_DRIVER_OVERRIDE=llvmpipe

# Start niri with software rendering
exec niri "$@"
EOF

chmod +x /usr/local/bin/niri-vm-env

# Create a systemd override for the niri session to use software rendering
mkdir -p /etc/systemd/user/niri.service.d
cat > /etc/systemd/user/niri.service.d/vm-override.conf << 'EOF'
[Service]
Environment="LIBGL_ALWAYS_SOFTWARE=1"
Environment="GALLIUM_DRIVER=llvmpipe" 
Environment="MESA_GL_VERSION_OVERRIDE=3.3"
Environment="MESA_GLSL_VERSION_OVERRIDE=330"
Environment="__GLX_VENDOR_LIBRARY_NAME=mesa"
Environment="MESA_LOADER_DRIVER_OVERRIDE=llvmpipe"
EOF