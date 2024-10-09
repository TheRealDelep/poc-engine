package main

import "lib"
import rl "vendor:raylib"

main :: proc() {
    rl.InitWindow(800, 450, "Game")
    defer rl.CloseWindow()

    for !rl.WindowShouldClose() {
        lib.update()

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.BeginMode3D(lib.camera)
        lib.draw()
        rl.EndMode3D()

        rl.EndDrawing()
    }
}
