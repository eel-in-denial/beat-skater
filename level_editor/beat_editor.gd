extends Panel

enum {Beat1, Beat2}
var edit_mode = Beat1
var is_left_mouse_held := false
var is_right_mouse_held := false
var snapping := 1.0
var num_lanes: int = 4
var min_lane_height := 50.0
var lane_height := 100.0
var bottom_margin := 100.0
var top_margin := 50.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lane_height = maxf((size.y - bottom_margin - top_margin - 10) / (num_lanes - 1), min_lane_height)
	queue_redraw()

func _draw() -> void:
	for i in range(num_lanes):
		if size.y - (i*lane_height) - bottom_margin > top_margin:
			draw_line(Vector2(0, size.y - (i*lane_height) - bottom_margin), Vector2(size.x, size.y - (i*lane_height) - bottom_margin), Color.WHITE, 5)
func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		print(size)
