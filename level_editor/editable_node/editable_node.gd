extends Area2D
class_name EditableNode

enum Type {In, Position, Out}
signal update_path
signal update_beat_track

@onready var polygon := $Polygon2D
var is_drag = false

var type: Type:
	set(value):
		type = value
		if type == Type.Position:
			polygon.color = Color(1.0, 1.0, 1.0)
		elif type == Type.In or type == Type.Out:
			polygon.color = Color(1.0, 0.0, 1.0)
var index: int = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_drag:
		global_position = get_global_mouse_position()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		is_drag = true
	elif event.is_action_released("left_click"):
		is_drag = false
		update_editor()

func update_editor():
	if type == Type.Position:
		update_path.emit()
