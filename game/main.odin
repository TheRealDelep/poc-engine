package main

import "lib"
import "lib/core"
import rl "vendor:raylib"

main :: proc() {
    rl.InitWindow(800, 450, "Game")
    defer rl.CloseWindow()

    lib.init()
    defer lib.deinit()

    for !rl.WindowShouldClose() {
        lib.update()

        rl.BeginDrawing()
        rl.ClearBackground(rl.WHITE)

        rl.BeginMode3D(core.camera)
        lib.draw_world()

        rl.EndMode3D()
        rl.EndDrawing()
    }
}
