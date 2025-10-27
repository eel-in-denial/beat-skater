extends Area2D
class_name Beat

var beat_data: Dictionary
var beat_type :=  1
var press_type := "tap"
var height := 0
var time_pos := 0.0
var hold_time := 0.0
var hold_position := 0.0
@onready var hold_beat := $HoldBeat
@onready var hold_line: Line2D= $HoldLine
@onready var beat_sprite := $Beat
var is_held = false
var is_long_playing = false
var length_array = []

func _process(delta: float) -> void:
	if is_long_playing:
		var updated_array = length_array.slice(floor((Global.song_position - time_pos)/0.01))
		hold_line.points = updated_array
		if updated_array:
			beat_sprite.position = updated_array[0]
		else:
			beat_sprite.visible = false
		

func initialise(
	point_data: Dictionary,
	data := {"beat_type": 1, "press_type": "tap", "height": 0, "beat": 9, "duration": 4},
	l_a := []
):
	beat_data = data
	beat_type = data["beat_type"]
	time_pos = data["beat"] * Global.sec_per_beat 
	height = data["height"]
	press_type = data["press_type"]
	hold_beat.visible = false
	hold_line.visible = false
	length_array = l_a
	hold_line.clear_points()
	position = point_data["pos"] + point_data["tangent"].orthogonal() * (400 * height + 100)
	if beat_type == 1:
		modulate = Color(1.0, 1.0, 1.0)
	elif beat_type == 2:
		modulate = Color(1.0, 0.0, 0.0)
	if press_type == "hold":
		hold_initialise(point_data["pos"], data, l_a)
func hold_initialise(
	pos: Vector2,
	data := {"beat_type": 1, "press_type": "tap", "height": 0, "beat": 9, "duration": 4},
	l_a := []
):
	hold_time = data["duration"] * Global.sec_per_beat

	hold_beat.visible = true
	hold_line.visible = true
	if l_a:
		hold_line.points = l_a
		hold_beat.position = l_a[-1]
