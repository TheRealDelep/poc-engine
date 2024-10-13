package editor

import "core:c"
import "core:strings"

import rl "vendor:raylib"
import rlgl "vendor:raylib/rlgl"
import im "../../../repos/odin-imgui"
import im_rl "../../../repos/odin-imgui/imgui_impl_raylib"

import "windows"
import game "../game/lib"

window_size : [2]c.int = {800, 450}

main :: proc() {
    rl.InitWindow(window_size.x, window_size.y, "POC Engine")
    defer rl.CloseWindow()

    im.CreateContext(nil)
    defer im.DestroyContext(nil)
    im_rl.init()
    defer im_rl.shutdown()

    im_rl.build_font_atlas()

    rl.SetWindowState({.WINDOW_RESIZABLE, .WINDOW_MAXIMIZED})
    io := im.GetIO()
    io.ConfigFlags |= {.DockingEnable}

    game.init()

    for !rl.WindowShouldClose() {
        im_rl.process_events()
        im_rl.new_frame()
        im.NewFrame()

        if (rl.IsWindowResized()) {
            window_size.x = rl.GetScreenWidth()
            window_size.y = rl.GetScreenHeight()
        }

        game.update()

        rl.BeginDrawing() 
        rl.ClearBackground(rl.WHITE)

        game.draw_world()

        im.DockSpaceOverViewport(viewport = im.GetMainViewport())
        windows.update_scene_window()
        windows.draw_properties_window()

        im.Render()
        im_rl.render_draw_data(im.GetDrawData())
        rl.EndDrawing()
    }
}
