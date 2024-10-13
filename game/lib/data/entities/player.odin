package entities

import rl "vendor:raylib"
import "core:fmt"

player_position : [3]f32 = {0, .5, 0}
player_speed    : f32 = 10
player_model    : rl.Model
player_mesh     : rl.Mesh
player_material : rl.Material
player_shader   : rl.Shader

init_player :: proc() {
    player_model = rl.LoadModel("game/res/models/figurine.obj")
    fmt.println("loaded model success")

    // player_shader = rl.LoadShader(
    //     "C:/Users/sylva/projekt/engine-poc/game/res/shaders/lighting_vert.glsl", 
    //     "C:/Users/sylva/projekt/engine-poc/game/res/shaders/lighting_frag.glsl")

    // player_shader.locs[rl.ShaderLocationIndex.MATRIX_MVP]   = i32(rl.GetShaderLocation(player_shader, "mvp"))
	// player_shader.locs[rl.ShaderLocationIndex.VECTOR_VIEW]  = i32(rl.GetShaderLocation(player_shader, "viewPos"))
	// player_shader.locs[rl.ShaderLocationIndex.MATRIX_MODEL] = i32(rl.GetShaderLocationAttrib(player_shader, "instanceTransform"))

    // player_material = rl.LoadMaterialDefault()
    // player_material.shader = player_shader
}

update_player :: proc() {
    direction : [3]f32 = {0, 0, 0}

    if rl.IsKeyDown(.W) { direction.z -= 1}
    if rl.IsKeyDown(.S) { direction.z += 1}
    if rl.IsKeyDown(.A) { direction.x -= 1}
    if rl.IsKeyDown(.D) { direction.x += 1}

    direction = rl.Vector3Normalize(direction)
    player_position += direction * player_speed * rl.GetFrameTime()
}

draw_player :: proc() {
    pos_matrix := rl.MatrixTranslate(player_position.x, 0.5, player_position.z)
    rl.DrawModel(player_model, player_position, 5, rl.WHITE)
    // rl.DrawMesh(player_mesh, player_material, pos_matrix)
}
