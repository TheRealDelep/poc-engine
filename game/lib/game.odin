package game

import "core:c"
import "core:fmt"
import rl "vendor:raylib"

import scene_data "data"

camera := rl.Camera3D {
    position = {0, 10, 1},
    target = {0, 0, 0},
    up = {0, 1, 0},
    fovy = 50,
    projection = .PERSPECTIVE
}

init :: proc() {
}

update :: proc() {
    // rl.UpdateCamera(&camera, .FIRST_PERSON) 
}

draw :: proc() {
    rl.DrawCubeV(scene_data.the_cube.position, scene_data.the_cube.size, scene_data.the_cube.color)
}
