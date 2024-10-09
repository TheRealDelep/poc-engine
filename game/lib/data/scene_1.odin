package data

import rl "vendor:raylib"

cube :: struct {
    position : rl.Vector3,
    size : rl.Vector3,
    color : rl.Color
}

the_cube := cube {
    position = {0, .5, 0},
    size = {1, 1, 1},
    color = rl.RED
}
