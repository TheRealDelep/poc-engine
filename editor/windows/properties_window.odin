package windows

import rl "vendor:raylib"
import im "../../../../repos/odin-imgui"
import rl_im "../../../../repos/odin-imgui/imgui_impl_raylib"
import fmt "core:fmt"
import "core:reflect"
import "core:strings"
import "base:runtime"
import "core:c"

import data "../../game/lib/data"

test_vec := rl.Color {1, 2, 3, 255}

draw_properties_window :: proc() {
    if im.Begin("Properties") {
        im.Text("TheCube")

        // draw_item_prop(&data.the_cube.position, "position")
        // draw_item_prop(&data.the_cube.size, "size")
        // draw_item_prop(&data.the_cube.color, "color")
        // draw_item_prop(&data.the_cube, "The cube")

        inspect_prop(&data.the_cube, "The cube")
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

draw_item_prop :: proc(item: any, label: cstring) {
    t_infos := type_info_of(item.id)

    pointer_infos : reflect.Type_Info_Pointer
    #partial switch t in t_infos.variant {
    case reflect.Type_Info_Pointer:
        pointer_infos = t
    case: panic("need to pass a pointer bro")
    }

    #partial switch t in pointer_infos.elem.variant {
    case reflect.Type_Info_Float:
        switch v in item {
        case ^f32: im.InputFloat(label, v)
        case ^f64: im.InputDouble(label, v)
        } 
    case reflect.Type_Info_Integer:
        switch v in item {
        case ^u8 : im.InputScalar(label, im.DataType.U8, v)
        case ^i8 : im.InputScalar(label, im.DataType.S8, v)
        case ^u16 : im.InputScalar(label, im.DataType.U16, v)
        case ^i16 : im.InputScalar(label, im.DataType.S16, v)
        case ^u32 : im.InputScalar(label, im.DataType.U32, v)
        case ^i32 : im.InputScalar(label, im.DataType.S32, v)
        case ^u64 : im.InputScalar(label, im.DataType.U64, v)
        case ^i64 : im.InputScalar(label, im.DataType.S64, v)
        }
    case reflect.Type_Info_Array:
        switch v in item {
        case ^[2]i32 : im.InputInt2(label, v)
        case ^[3]i32 : im.InputInt3(label, v)
        case ^[4]i32 : im.InputInt4(label, v)
        case ^[2]f32 : im.InputFloat2(label, v)
        case ^[3]f32 : im.InputFloat3(label, v)
        case ^[4]f32 : im.InputFloat4(label, v)
        }
    case reflect.Type_Info_Named:
        #partial switch b in t.base.variant {
        case reflect.Type_Info_Array:
            switch v in item{
            case ^rl.Color:
                im_color := rl_im.to_imgui_color(v^)
                im.ColorPicker4(label, &im_color)
                v^ = rl_im.to_rl_color(im_color)
            }
        case reflect.Type_Info_Struct :
            count := reflect.struct_field_count(t.base.id)

            for i in 0..<count {
                field := reflect.struct_field_at(t.base.id, i)
                val := reflect.struct_field_value(item, field)
                
                builder := strings.builder_make_none()
                strings.write_string(&builder, field.name)
                c_name := strings.to_cstring(&builder)

                p, res := reflect.as_pointer(item)
                adress := uintptr(p) + field.offset
                p = rawptr(adress)

                // draw_item_prop(any{p, typeid(runtime.Typeid_Kind.Pointer)}, c_name)
                draw_item_prop(any{p, (typeid)(item.id)}, c_name)
                // draw_item_prop(^^runtime.Type_Info)(v.data)^
            }
        }
    case: 
        fmt.panicf("Serialization of %v is not supported", t)
    }
}
}
