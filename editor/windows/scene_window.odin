package windows

import "core:fmt"
import "core:c"
import rl "vendor:raylib"
import im "../../../../repos/odin-imgui"

import game "../../game/lib"

ED_CAM_SPEED :: 10
ED_CAM_ROT_SPEED :: 1

render_tex : rl.RenderTexture
win_size : [2]f32

Vector3 :: [3]f32

ed_camera := rl.Camera3D {
        position = {0, 10, 10}, 
        target = {0, 0, 0},
        up = {0, 1, 0},
        fovy = 50,
        projection = .PERSPECTIVE
}

update_scene_window :: proc() {
    if im.Begin("game") {
        size := im.GetWindowSize()

        if win_size != size {
            win_size = size
            rl.UnloadRenderTexture(render_tex)
            render_tex = rl.LoadRenderTexture(c.int(win_size.x), c.int(win_size.y))
        }

        if im.IsWindowFocused() {
            update_ed_camera(&ed_camera)
        }

        game.update()

        rl.BeginTextureMode(render_tex)

        rl.ClearBackground(rl.BLACK)

        rl.BeginMode3D(ed_camera)
        game.draw_world()

        rl.DrawGrid(10, 1)

        // GIZMOS
        rl.DrawLine3D({0, 0, 0}, {5, 0, 0}, rl.RED)
        rl.DrawLine3D({0, 0, 0}, {0, 5, 0}, rl.GREEN)
        rl.DrawLine3D({0, 0, 0}, {0, 0, 5}, rl.BLUE)

        rl.EndMode3D()

        rl.EndTextureMode()

        im.Image(&render_tex.texture, win_size, {0, 1}, {1, 0})
    }
    im.End()
}

update_ed_camera :: proc(cam: ^rl.Camera3D) {
    // Update Rotation
    if rl.IsMouseButtonDown(.RIGHT) {
        rot := -rl.GetMouseDelta() * rl.RAD2DEG * rl.GetFrameTime() * ED_CAM_ROT_SPEED
        cam_forward := rl.Vector3Normalize(cam.target - cam.position)

        if rot.y != 0 {
            cam_right := rl.Vector3CrossProduct(cam_forward, cam.up)
            cam.target = cam.position + rl.Vector3RotateByAxisAngle(cam_forward, cam_right, rot.y)
            cam.up = rl.Vector3RotateByAxisAngle(cam.up, cam_right, rot.y)
        }

        if rot.x != 0 {
            cam.target = cam.position + rl.Vector3RotateByAxisAngle(cam_forward, {0, 1, 0}, rot.x)
            cam.up = rl.Vector3RotateByAxisAngle(cam.up, {0, 1, 0}, rot.x)
        }
    }

    // Update Position
    movement : Vector3 = {cast(f32)u8(rl.IsKeyDown(.D)) - cast(f32)u8(rl.IsKeyDown(.A)), 0, 0}

    if rl.IsKeyDown(.LEFT_CONTROL) {
        movement.y = cast(f32)u8(rl.IsKeyDown(.W)) - cast(f32)u8(rl.IsKeyDown(.S))
    } else {
        movement.z = cast(f32)u8(rl.IsKeyDown(.W)) - cast(f32)u8(rl.IsKeyDown(.S))
    }

    cam_forward := rl.Vector3Normalize(cam.target - cam.position)
    cam_right := rl.Vector3CrossProduct(cam_forward, cam.up)

    translation := (cam_forward * movement.z) + {0, movement.y, 0} + (cam_right * movement.x)
    translation = rl.Vector3Normalize(translation) * rl.GetFrameTime() * ED_CAM_SPEED

    cam.position += translation
    cam.target += translation
}
