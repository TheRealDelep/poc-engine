package game

import "core:c"
import "core:fmt"
import rl "vendor:raylib"

import "core"
import scenes "data/scenes"

current_scene   : core.scene

init :: proc() {
    core.camera = {
        position = {2, 4, 6},
        target = {0, .5, 0},
        up = {0, 1, 0},
        fovy = 45,
        projection = .PERSPECTIVE
    }

    current_scene = scenes.playground
    init_proc, implemented := current_scene.init_proc.?
    if implemented do init_proc()
}

update :: proc() {
    update_proc, implemented := current_scene.update_proc.?
    if implemented do update_proc()
}

draw_world :: proc() {
    draw_proc, implemented := current_scene.draw_world_proc.?
    if implemented do draw_proc()
}

draw_screen :: proc() {
    draw_proc, implemented := current_scene.draw_screen_proc.?
    if implemented do draw_proc()
}

deinit :: proc() {
}
