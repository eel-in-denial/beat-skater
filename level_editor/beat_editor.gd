extends Panel

enum {Beat1, Beat2}
var edit_mode = Beat1
var is_left_mouse_held := false
var is_right_mouse_held := false
var snapping := 1.0
var num_lanes: int = 4
var min_lane_height := 40.0
var lane_height := 100.0
var bottom_margin := 100.0
var top_margin := 50.0
var left_margin := 50.0
var bar_width := 300.0
var beat_position := 0.0
var total_bars: int = 8

var lane_y_positions: Array[float] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(num_lanes):
		lane_y_positions.append(0.0)
	update_lanes()
	update_bars()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(lane_y_positions)
	queue_redraw()

func update_lanes():
	lane_height = max(min_lane_height, (size.y - bottom_margin)/num_lanes)
	for i in range(num_lanes):
		lane_y_positions[i] = size.y - (i*lane_height) - bottom_margin
	print(lane_y_positions)

func update_bars():
	pass

func _draw() -> void:
	for y_pos in lane_y_positions:
		if y_pos > top_margin:
			draw_line(Vector2(0, y_pos), Vector2(size.x, y_pos), Color.WHITE, 5)
	for i in range(ceil((size.x - left_margin*2)/bar_width)):
		var x = left_margin + (i + beat_position - int(beat_position))*bar_width
		draw_line(Vector2(x, 0), Vector2(x, size.y), Color.BURLYWOOD, 2)
func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		print(size)


func _on_v_split_container_dragged(offset: int) -> void:
	update_lanes()


func _on_h_scroll_bar_scrolling() -> void:
	update_bars()
