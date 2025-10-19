extends Node2D
class_name LevelEditor

var beat_file = preload("res://level_assets/beat/beat.tscn")

@export var level_json_path: String:
	set(value):
		level_json_path = value
		init_level()
@export var beat_editor: BeatEditor

@export_group("Song Details")
@export var title := ""
@export var artist := ""
@export var bpm := 100
@export var song: AudioStreamOggVorbis

@export_group("Player Presets")
@export var player_initial_speed := 50.0
@export var player_jump_height := 500
@export var player_screen_position := Vector2(480.0, 0)
@export var gravity := Vector2(0, 980)

@export_group("Editor Details")
@export var beat_snapping := 1.0

@onready var level := $Level
@onready var path: Path2D = $Level/LevelPath



var beats_array: Array[Beat] = []
var baked_points_array := []
var path_nodes_array: Array[EditableNode] = []

var is_panning = false
var curr_mouse_position := Vector2.ZERO
var prev_mouse_position := Vector2.ZERO

var editable_node = preload("res://level_editor/editable_node/editable_node.tscn")
var init_in_vector := Vector2(-100, 0)
var init_out_vector := Vector2(100, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.init_editor(load("res://songs/roulette round 2 slow.ogg"), 100)

func init_level():
	print("level_loading...")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	prev_mouse_position = curr_mouse_position
	curr_mouse_position = get_global_mouse_position()
	if is_panning:
		level.global_position += curr_mouse_position - prev_mouse_position

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pan"):
		is_panning = true
		print("panning on")
	elif event.is_action_released("pan"):
		is_panning = false
		print("panning off")
	elif event.is_action_pressed("right_click"):
		place_curve_point()

func place_curve_point():
	add_edditable_node(curr_mouse_position, path.curve.point_count)
	path.curve.add_point(curr_mouse_position - path.global_position, init_in_vector, init_out_vector)
	path.generate_graphics()
	bake()

func edit_curve_point(idx: int, pos: Vector2, in_pos: Vector2, out_pos: Vector2):
	path.curve.set_point_position(idx, pos)
	path.curve.set_point_in(idx, in_pos - pos)
	path.curve.set_point_out(idx, out_pos - pos)
	path.generate_graphics()
	bake()

func add_edditable_node(position: Vector2, index: int):
	var new_point: EditableNode = editable_node.instantiate()
	level.add_child(new_point)
	new_point.global_position = position
	new_point.index = index
	new_point.update_path.connect(edit_curve_point)
	path_nodes_array.append(new_point)

func load_new():
	for b in beats_array:
		b.queue_free()
	beats_array = []
	for node in path_nodes_array:
		node.queue_free()
	path_nodes_array = []
	path.curve.clear_points()
	beat_editor.load_new()
	
func bake():
	baked_points_array = []
	var time = 0.0
	var distance = 0.0
	var time_interval := 0.01
	var total_length = path.curve.get_baked_length()
	var speed = player_initial_speed
	var i := 0
	var next_beat: float = beat_editor.beats[0].beat_data["beat"] * Global.sec_per_beat if not beat_editor.beats.is_empty() else Global.song_duration
	var num_of_beats: int = beat_editor.beats.size()
	var curr_hold_beat: Beat
	print(beat_editor.beats)
	while time < Global.song_duration:
		var p_1: Vector2 = path.curve.sample_baked(distance)
		var p_2: Vector2 = path.curve.sample_baked(distance + 0.1)
		var tangent = (p_2 - p_1).normalized()
		var acceleration = gravity.dot(tangent)
		speed += acceleration * time_interval
		distance += speed * time_interval
		distance = clamp(distance, 0.0, total_length)
		
		baked_points_array.append({"time": time, "pos": p_1, "speed": speed, "tangent": tangent})
		
		if abs(time - next_beat) < time_interval and i < num_of_beats:
			if i >= beats_array.size():
				var new_beat: Beat = beat_file.instantiate()
				new_beat.initialise(p_1, beat_editor.beats[i].beat_data)
				level.add_child(new_beat)
				beats_array.append(new_beat)
				print("num_of_beats: ", num_of_beats, ",  beats_array size: ", beats_array.size(), ",  i:", i)
			else:
				print(i, '  ', beats_array.size())
				beats_array[i].initialise(p_1, beat_editor.beats[i].beat_data)
			i += 1
			if i < beat_editor.beats.size():
				next_beat = beat_editor.beats[i].beat_data["beat"] * Global.sec_per_beat
		time += time_interval

func _on_save_pressed() -> void:
	var beats_data_array = []
	var path_nodes_data_array = []
	
	for beat in beats_array:
		beats_data_array.append(beat.beat_data)
		
	for node in path_nodes_array:
		path_nodes_data_array.append({
			"pos": node.position,
			"in_pos": node.position + node.in_collision.position, 
			"out_pos": node.position + node.out_collision.position
		})
	
	var level_save = {
		"title": title,
		"artist": artist,
		"bpm": bpm,
		"player_initial_speed": player_initial_speed,
		"song_path": level_json_path,
		"beats": beats_data_array,
		"curve_points": path_nodes_data_array
	}
	print("level path: ", level_json_path)
	Global.save_json_data(level_json_path, level_save)

	
