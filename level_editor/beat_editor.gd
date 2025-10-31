extends Panel
class_name BeatEditor

enum {Beat1, Beat2, Rails}
var edit_mode = Beat1
var is_left_mouse_held := false
var is_right_mouse_held := false
var snapping := 1.0
var num_lanes: int = 4
var min_lane_height := 40.0
var lane_height := 100.0
var bottom_margin := 50.0
var top_margin := 50.0
var left_margin := 50.0
var right_margin := 50.0
var bar_width := 360.0
var beat_width := 0.0
var bar_position: float = 0.0
var beat_position := 0.0:
	set(value):
		beat_position = value
		bar_position = beat_position/beats_per_bar
var total_bars: int = 8
		
var beats_per_bar := 4

var beat_scene := preload("res://level_editor/editor_beat/editor_beat.tscn")
var beats: Array[EditorBeat] = []
var objects: Array[EditorRail]
var curr_held_beat
var curr_extended_beat

var rail_scene := preload("res://level_editor/editor_rail/editor_rail.tscn")

@onready var scroll := $HScrollBar
@export var beats_per_bar_text: LineEdit
@export var snapping_text: LineEdit
@export var total_bars_text: LineEdit
@export var level_editor: LevelEditor

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
	beats_per_bar_text.text = str(beats_per_bar)
	snapping_text.text = str(snapping)
	total_bars_text.text = str(total_bars)

func load_level(beat_data: Array, object_data: Array, b_per_bar: int, t_bars: int):
	beats_per_bar = b_per_bar
	beats_per_bar_text.text = str(beats_per_bar)
	total_bars = t_bars
	total_bars_text.text = str(total_bars)
	beat_width = bar_width / beats_per_bar
	scroll.max_value = total_bars * beats_per_bar
	bar_x_positions = []
	for b in beats:
		b.queue_free()
	beats = []
	for r in objects:
		r.queue_free()
	objects = []
	for data in beat_data:
		var b = add_beat(data)
		beats.append(b)
		b.update_line(beat_width)
	for data in object_data:
		var r = add_rail(data)
		objects.append(r)
		r.update_line(beat_width)
	for i in range(total_bars + 1):
		bar_x_positions.append(0.0)
	update_scroll_page()
	update_lanes()
	update_bars()
	update_beat_heights()
	update_beat_widths()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_local_mouse_position()
	if is_left_mouse_held:
		curr_held_beat.beat_data["height"] = snap_lane(mouse_pos)
		curr_held_beat.beat_data["beat"] = snap_beat(mouse_pos)
		update_single_beat(curr_held_beat)
	elif curr_extended_beat:
		curr_extended_beat.beat_data["duration"] = snap_beat(mouse_pos) - curr_extended_beat.beat_data["beat"]
		curr_extended_beat.update_line(beat_width)
	queue_redraw()

func update_lanes():
	lane_height = max(min_lane_height, (size.y - bottom_margin)/num_lanes)
	for i in range(num_lanes):
		lane_y_positions[i] = size.y - (i*lane_height) - bottom_margin

func update_bars():
	beat_position = scroll.value
	for i in range(total_bars + 1):
		bar_x_positions[i] = left_margin + (i - bar_position)*bar_width

func update_beat_heights():
	for b in beats:
		b.position.y = lane_y_positions[b.beat_data["height"]]
		b.visible = false if b.position.x < left_margin or b.position.x > size.x - right_margin or b.position.y < top_margin else true
	for o in objects:
		o.position.y = lane_y_positions[o.beat_data["height"]]
		o.visible = false if o.position.x < left_margin or o.position.x > size.x - right_margin or o.position.y < top_margin else true
		
func update_beat_widths():
	for b in beats:
		b.position.x = left_margin + (b.beat_data["beat"] - beat_position) * beat_width
		b.visible = false if b.position.x < left_margin or b.position.x > size.x - right_margin or b.position.y < top_margin else true
	for o in objects:
		o.position.x = left_margin + (o.beat_data["beat"] - beat_position) * beat_width
		o.visible = false if o.position.x < left_margin or o.position.x > size.x - right_margin or o.position.y < top_margin else true
	
func update_single_beat(beat):
	beat.position = Vector2(left_margin + (beat.beat_data["beat"] - beat_position) * beat_width, lane_y_positions[beat.beat_data["height"]])
	#beat.visible = false if beat.position.y < top_margin or beat.position.x < left_margin or beat.position.x > size.x - right_margin else true

func update_scroll_page():
	scroll.page = (size.x - left_margin - right_margin) / beat_width
	

func _draw() -> void:
	var top_lane: float
	for y_pos in lane_y_positions:
		if y_pos > top_margin:
			draw_line(Vector2(0, y_pos), Vector2(size.x, y_pos), Color.WHITE, 5)
			top_lane = y_pos
	for x_pos in bar_x_positions.slice(floor(bar_position), bar_position + ceil(scroll.page)):
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
		var mouse_pos = get_local_mouse_position()
		var height = snap_lane(mouse_pos)
		var beat = snap_beat(mouse_pos)
		curr_held_beat = is_object_clicked(height, beat)
		if not curr_held_beat:
			if edit_mode == Rails:
				place_rail(height, beat)
			else:
				place_beat(height, beat)
	elif event.is_action_pressed("right_click"):
		is_right_mouse_held = true
		print("askjdf")
	elif event.is_action_released("left_click"):
		is_left_mouse_held = false
		level_editor.bake()
		level_editor.save_editor()
	elif event.is_action_released("right_click"):
		is_right_mouse_held = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("editor_num_1"):
		_on_beat_1_button_toggled(true)
	elif event.is_action_pressed("editor_num_2"):
		_on_beat_2_button_toggled(true)

func is_object_clicked(height: int, beat: float):
	for b in beats:
		if b.height == height and b.beat_data["beat"] == beat:
			return b
	for o in objects:
		if o.height == height and o.beat_data["beat"] == beat:
			return o
	return null

func place_rail(height: int, beat: float):
	var data = {
		"object_type": "rail",
		"height": height,
		"beat": beat,
		"duration": 0
	}
	curr_held_beat = add_rail(data)
	objects.append(curr_held_beat)

func add_rail(data: Dictionary) -> EditorRail:
	var new_rail: EditorRail = rail_scene.instantiate()
	add_child(new_rail)
	new_rail.initialise(data)
	new_rail.delete.connect(delete_rail)
	new_rail.selected.connect(selected_beat)
	new_rail.dropped.connect(drop_rail)
	new_rail.extending_selected.connect(extended_selected)
	new_rail.extending_unselected.connect(extended_unselected)
	new_rail.position = Vector2(left_margin + (data["beat"] - beat_position) * beat_width, lane_y_positions[data["height"]])
	return new_rail

func place_beat(height: int, beat: float):
	var data = {
		"beat_type": 1 if edit_mode == Beat1 else 2,
		"press_type": "tap",
		"height": height,
		"beat": beat,
		"duration": 0
	}
	curr_held_beat = add_beat(data)
	beats.insert(beats.bsearch_custom(curr_held_beat, sort_by_beat), curr_held_beat)

func add_beat(data: Dictionary) -> EditorBeat:
	var new_beat: EditorBeat = beat_scene.instantiate()
	add_child(new_beat)
	new_beat.initialise(data)
	new_beat.delete.connect(delete_beat)
	new_beat.selected.connect(selected_beat)
	new_beat.dropped.connect(drop_beat)
	new_beat.extending_selected.connect(extended_selected)
	new_beat.extending_unselected.connect(extended_unselected)
	new_beat.position = Vector2(left_margin + (data["beat"] - beat_position) * beat_width, lane_y_positions[data["height"]])
	return new_beat

func extended_selected(b):
	curr_extended_beat = b
	
	selected_beat(b)
	print("skjdsf")

func extended_unselected(b):
	curr_extended_beat = null
	level_editor.bake()
	level_editor.save_editor()

func selected_beat(b):
	if curr_held_beat and curr_held_beat != curr_extended_beat:
		if curr_held_beat.beat_data["duration"] == 0:
			curr_held_beat.reset_to_tap()
			
	curr_held_beat = b

func delete_beat(beat: EditorBeat):
	level_editor.beats_array.pop_back().queue_free()
	beats.erase(beat)
	level_editor.bake()
	level_editor.save_editor()

func delete_rail(rail: EditorRail):
	level_editor.rails_array.pop_back().queue_free()
	objects.erase(rail)
	level_editor.bake()
	level_editor.save_editor()

func drop_beat():
	level_editor.bake()
	level_editor.save_editor()

func drop_rail():
	level_editor.bake()
	level_editor.save_editor()

func sort_by_beat(a: EditorBeat, b: EditorBeat):
	if a.beat_data["beat"] < b.beat_data["beat"]:
		return true
	return false

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
	beat = (mouse_pos.x - left_margin) / beat_width + beat_position
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

func _on_rails_toggled(toggled_on: bool) -> void:
	edit_mode = Rails

func _on_beats_per_bar_text_changed(new_text: String) -> void:
	if int(new_text) > 0:
		beats_per_bar = int(new_text)
		beat_width = bar_width / beats_per_bar
		scroll.max_value = total_bars * beats_per_bar
		update_beat_widths()
	level_editor.save_editor()
	
func _on_snapping_text_changed(new_text: String) -> void:
	if float(new_text) > 0:
		snapping = float(new_text)

func _on_total_bars_text_changed(new_text: String) -> void:
	if int(new_text) > 0:
		var old_total_bars = total_bars
		total_bars = int(new_text)
		if total_bars - old_total_bars > 0:
			for i in range(total_bars - old_total_bars):
				bar_x_positions.append(0.0)
		else:
			for i in range(old_total_bars - total_bars):
				bar_x_positions.pop_back()
		scroll.max_value = total_bars * beats_per_bar
		update_scroll_page()
	level_editor.save_editor()
