extends Node2D

@export var level_json_path: String:
	set(value):
		level_json_path = value
		init_level()

@export_group("Song Details")
@export var title := ""
@export var artist := ""
@export var bpm := 100
@export var song: AudioStreamOggVorbis

@export_group("Player Presets")
@export var player_initial_speed := 0.0
@export var player_jump_height := 500
@export var player_screen_position := Vector2(480.0, 0)
@export var gravity := Vector2(0, 980)

@export_group("Editor Details")
@export var beat_snapping := 1.0

@onready var level := $Level
@onready var path: Path2D = $Level/LevelPath

var beats_array := []
var curve_points_array := []

var is_panning = false
var curr_mouse_position := Vector2.ZERO
var prev_mouse_position := Vector2.ZERO

var editable_node = preload("res://level_editor/editable_node/editable_node.tscn")
var init_in_vector := Vector2(-100, 0)
var init_out_vector := Vector2(100, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

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

func edit_curve_point(idx: int, pos: Vector2, in_pos: Vector2, out_pos: Vector2):
	pos = pos - path.global_position
	in_pos = in_pos - path.global_position
	out_pos = out_pos - path.global_position
	path.curve.set_point_position(idx, pos)
	path.curve.set_point_in(idx, in_pos - pos)
	path.curve.set_point_out(idx, out_pos - pos)
	path.generate_graphics()

func add_edditable_node(position: Vector2, index: int):
	var new_point: EditableNode = editable_node.instantiate()
	level.add_child(new_point)
	new_point.global_position = position
	new_point.index = index
	new_point.update_path.connect(edit_curve_point)

func load_level():
	pass

func _on_bake_pressed() -> void:
	var level_save = {
		"title": title,
		"artist": artist,
		"bpm": bpm,
		"player_initial_speed": player_initial_speed,
		"song_path": level_json_path,
		"beats": beats_array,
		"curve_points": curve_points_array
	}
