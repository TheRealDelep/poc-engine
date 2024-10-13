package core

scene :: struct {
    init_proc           : Maybe(proc()),
    update_proc         : Maybe(proc()),
    draw_world_proc     : Maybe(proc()),
    draw_screen_proc    : Maybe(proc()),
    deinit              : Maybe(proc())
}
