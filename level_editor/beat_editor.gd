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
var right_margin := 50.0
var bar_width := 360.0
var beat_width := 0.0
var bar_position: int = 0
var beat_position := 0.0:
	set(value):
		beat_position = value
		bar_position = floor(beat_position/beats_per_bar)
var total_bars: int = 8
		
var beats_per_bar := 4

var beat_scene := preload("res://level_editor/beat_editor_beat/beat_editor_beat.tscn")
var beats: Array[EditorBeat] = []
var curr_held_beat: EditorBeat

@onready var scroll := $HScrollBar

var lane_y_positions: Array[float] = []
var bar_x_positions: Array[float] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scroll.max_value = total_bars * beats_per_bar
	beat_width = bar_width / beats_per_bar
	await get_tree().process_frame
	for i in range(num_lanes):
		lane_y_positions.append(0.0)
	for i in range(total_bars + 1):
		bar_x_positions.append(0.0)
	update_lanes()
	update_bars()
	update_scroll_page()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_local_mouse_position()
	if is_left_mouse_held:
		curr_held_beat.beat_data["height"] = snap_lane(mouse_pos)
		curr_held_beat.beat_data["beat"] = snap_beat(mouse_pos)
		update_single_beat(curr_held_beat)
	queue_redraw()

func update_lanes():
	lane_height = max(min_lane_height, (size.y - bottom_margin)/num_lanes)
	for i in range(num_lanes):
		lane_y_positions[i] = size.y - (i*lane_height) - bottom_margin
	print(lane_y_positions)

func update_bars():
	beat_position = scroll.value
	print(beat_position)
	for i in range(total_bars + 1):
		bar_x_positions[i] = left_margin + (i - (bar_position))*bar_width
	print(lane_y_positions)

func update_beat_heights():
	for b in beats:
		b.position.y = lane_y_positions[b.beat_data["height"]]
		b.visible = false if b.position.y < top_margin else true
		
func update_beat_widths():
	for b in beats:
		b.position.x = left_margin + (b.beat_data["beat"] - beat_position) * beat_width
		b.visible = false if b.position.x < left_margin or b.position.x > size.x - right_margin else true

func update_single_beat(beat: EditorBeat):
	beat.position = Vector2(left_margin + (beat.beat_data["beat"] - beat_position) * beat_width, lane_y_positions[beat.beat_data["height"]])

func update_scroll_page():
	scroll.page = (size.x - left_margin - right_margin) / beat_width
	print((size.x - left_margin - right_margin) / bar_width)

func _draw() -> void:
	var top_lane: float
	for y_pos in lane_y_positions:
		if y_pos > top_margin:
			draw_line(Vector2(0, y_pos), Vector2(size.x, y_pos), Color.WHITE, 5)
			top_lane = y_pos
	for x_pos in bar_x_positions.slice(bar_position, bar_position + ceil(scroll.page)):
		if x_pos >= left_margin and x_pos <= size.x - right_margin:
			if x_pos == bar_x_positions[0]:
				draw_line(Vector2(x_pos, 0), Vector2(x_pos, size.y), Color.GREEN_YELLOW, 8)
			else:
				draw_line(Vector2(x_pos, 0), Vector2(x_pos, size.y), Color.BURLYWOOD, 4)
			if top_lane:
				for b in range(beats_per_bar):
					var x = x_pos + (b + 1) * bar_width / beats_per_bar
					if x <= size.x - right_margin:
						draw_line(Vector2(x, lane_y_positions[0]), Vector2(x, top_lane), Color.LEMON_CHIFFON, 2)
		elif x_pos >= left_margin - bar_width and x_pos <= size.x - right_margin:
			if top_lane:
				for b in range(beats_per_bar):
					var x = x_pos + (b + 1) * bar_width / beats_per_bar
					if x >= left_margin:
						draw_line(Vector2(x, lane_y_positions[0]), Vector2(x, top_lane), Color.LEMON_CHIFFON, 2)
func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		is_left_mouse_held = true
		create_beat()
	elif event.is_action_pressed("right_click"):
		is_right_mouse_held = true
	elif event.is_action_released("left_click"):
		is_left_mouse_held = false
	elif event.is_action_released("right_click"):
		is_right_mouse_held = false

func create_beat():
	var new_beat: EditorBeat = beat_scene.instantiate()
	curr_held_beat = new_beat
	add_child(new_beat)
	var mouse_pos = get_local_mouse_position()
	var height = snap_lane(mouse_pos)
	var beat = snap_beat(mouse_pos)
	var data = {
		"beat_type": 1 if edit_mode == Beat1 else 2,
		"press_type": "tap",
		"height": height,
		"beat": beat,
		"duration": 0
	}
	new_beat.initialise(data)
	new_beat.position = Vector2(left_margin + (beat - beat_position) * beat_width, lane_y_positions[height])
	beats.append(new_beat)

func snap_lane(mouse_pos: Vector2):
	var height: int = 0
	if mouse_pos.y > lane_y_positions[0]:
		height = 0
	elif mouse_pos.y < lane_y_positions[-1]:
		height = num_lanes -1
	else:
		for y_pos in lane_y_positions:
			if abs(y_pos - mouse_pos.y) <= lane_height / 2:
				break
			height += 1
	return height

func snap_beat(mouse_pos: Vector2):
	var beat: float = 0.0
	beat = (mouse_pos.x - left_margin) / beat_width
	beat = snappedf(beat, snapping)
	return beat

func _on_v_split_container_dragged(offset: int) -> void:
	update_lanes()
	update_beat_heights()

func _on_h_scroll_bar_scrolling() -> void:
	update_bars()
	update_beat_widths()

func _on_beat_1_button_toggled(toggled_on: bool) -> void:
	edit_mode = Beat1

func _on_beat_2_button_toggled(toggled_on: bool) -> void:
	edit_mode = Beat2
