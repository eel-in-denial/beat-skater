# Zoom towards mouse using global mouse pos (Godot 3.x/4.x)
extends Camera2D

@export var zoom_step := 0.1
@export var min_zoom := 0.1
@export var max_zoom := 5.0

var pressed_local_mouse: Vector2
var pressed_global_pos: Vector2

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_WHEEL_UP  or event.button_index == MOUSE_BUTTON_WHEEL_DOWN) and event.pressed:
			var before := get_global_mouse_position()
			var z := zoom.x
			var factor := (1.0 - zoom_step) if (event.button_index == MOUSE_BUTTON_WHEEL_DOWN) else (1.0 + zoom_step)
			var new_z: float = clamp(z * factor, min_zoom, max_zoom)
			zoom = Vector2(new_z, new_z)

			var after := get_global_mouse_position()
			global_position += before - after
