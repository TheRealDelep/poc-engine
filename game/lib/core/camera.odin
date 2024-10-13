package core

import rl "vendor:raylib"

camera := rl.Camera3D {
    position = {0, 10, 1},
    target = {0, 0, 0},
    up = {0, 1, 0},
    fovy = 50,
    projection = .PERSPECTIVE
}
