package scenes

import "core:fmt"
import "../../core"
import "../entities"

import rl "vendor:raylib"

playground := core.scene {
    init_proc           = init_playground,
    update_proc         = update_playground,
    draw_world_proc     = draw_playground,
    draw_screen_proc    = ui_playground,
    deinit              = deinit_playground
}

init_playground :: proc() {
    entities.init_player() 
    entities.player_position = {0, 0, 0}

    core.camera.target = entities.player_position
}

update_playground :: proc() {
    entities.update_player()
}

draw_playground :: proc() {
    rl.DrawPlane({0, 0, 0}, {25, 25}, rl.LIGHTGRAY)
    entities.draw_player()
}

ui_playground :: proc() {
    
}

deinit_playground :: proc() {

}
