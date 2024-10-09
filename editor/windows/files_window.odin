package windows

import rl "vendor:raylib"
import im "../../../../repos/odin-imgui"
import rl_im "../../../../repos/odin-imgui/imgui_impl_raylib"

draw_files_window :: proc() {
    if im.Begin("Files") {
    }
    im.End()
}
