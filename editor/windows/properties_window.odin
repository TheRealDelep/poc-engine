package windows

import rl "vendor:raylib"
import im "../../../../repos/odin-imgui"
import rl_im "../../../../repos/odin-imgui/imgui_impl_raylib"
import fmt "core:fmt"
import "core:reflect"
import "core:strings"
import "base:runtime"
import "core:c"

import "../../game/lib/data/scenes"
import "../../game/lib/"

test_vec := rl.Color {1, 2, 3, 255}

draw_properties_window :: proc() {
    if im.Begin("Properties") {
        im.Text("Player")
        im.InputFloat3("position", &scenes.player.position)

        im.Text("Shader")
        im.InputFloat3("shader position", &lib.shader_pos)
    }
    im.End()
}

inspect_prop :: proc(prop: any, label: cstring) {
    switch v in prop {
    case ^f32       : im.InputFloat(label, v); return;
    case ^f64       : im.InputDouble(label, v); return;
    case ^u8        : im.InputScalar(label, im.DataType.U8, v); return;
    case ^i8        : im.InputScalar(label, im.DataType.S8, v); return;
    case ^u16       : im.InputScalar(label, im.DataType.U16, v); return;
    case ^i16       : im.InputScalar(label, im.DataType.S16, v); return;
    case ^u32       : im.InputScalar(label, im.DataType.U32, v); return;
    case ^i32       : im.InputScalar(label, im.DataType.S32, v); return;
    case ^u64       : im.InputScalar(label, im.DataType.U64, v); return;
    case ^i64       : im.InputScalar(label, im.DataType.S64, v); return;
    case ^[2]i32    : im.InputInt2(label, v); return;
    case ^[3]i32    : im.InputInt3(label, v); return;
    case ^[4]i32    : im.InputInt4(label, v); return;
    case ^[2]f32    : im.InputFloat2(label, v); return;
    case ^[3]f32    : im.InputFloat3(label, v); return;
    case ^[4]f32    : im.InputFloat4(label, v); return;
    }

    ptr_infos : reflect.Type_Info_Pointer 
    #partial switch t in type_info_of(prop.id).variant {
    case reflect.Type_Info_Pointer: ptr_infos = t
    case: fmt.panicf("Prop %v must be a pointer in order to be binded", prop)
    }

    #partial switch variant in ptr_infos.elem.variant {
    case reflect.Type_Info_Named:
        p, _ := reflect.as_pointer(prop)
        inspect_prop(any {p, variant.base.id}, label)
    case reflect.Type_Info_Struct: 
        count := reflect.struct_field_count(ptr_infos.elem.id)

        for i in 0..<count {
            field := reflect.struct_field_at(ptr_infos.elem.id, i)
            val := reflect.struct_field_value(prop, field)
            
            builder := strings.builder_make_none()
            strings.write_string(&builder, field.name)
            c_name := strings.to_cstring(&builder)

            p, _:= reflect.as_pointer(prop)
            p = rawptr(uintptr(p) + field.offset)

            inspect_prop(any {p, field.type.id}, c_name)
        }
    }
}
