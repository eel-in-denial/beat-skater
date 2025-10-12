extends Area2D
class_name EditableNode

enum Index {In, Position, Out}
signal update_path(idx: int, pos: Vector2, in_pos: Vector2, out_pos: Vector2)

@onready var in_collision := $In
@onready var out_collision := $Out

var is_drag := false
var drag_index: int = 0

var index: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	if is_drag:
		if drag_index == Index.Position:
			global_position = mouse_pos
		elif drag_index == Index.In:
			in_collision.global_position = mouse_pos
			out_collision.global_position = 2 * global_position - mouse_pos
		elif drag_index == Index.Out:
			out_collision.global_position = mouse_pos
			in_collision.global_position = 2 * global_position - mouse_pos

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		is_drag = true
		drag_index = shape_idx
	elif event.is_action_released("left_click"):
		is_drag = false
		update_path.emit(index, global_position, in_collision.global_position, out_collision.global_position)
