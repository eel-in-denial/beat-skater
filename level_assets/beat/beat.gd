extends Area2D
class_name Beat

var beat_type :=  1
var press_type := "tap"
var height := 0
var time_pos := 0.0
var hold_time := 0.0
var hold_position := 0.0
var hold_beat: CollisionShape2D
var hold_line: Line2D
var is_held = false
var is_long_playing = false

func _process(delta: float) -> void:
	if is_long_playing:
		hold_position -= Global.player_speed * delta
		if hold_position >= 0:
			hold_beat.position.x = -hold_position
			hold_line.set_point_position(1, Vector2(-hold_position, 0))
		else:
			is_long_playing = false
			hold_beat.visible = false
			hold_line.clear_points()
		

func initialise(
	pos: Vector2,
	data := {"beat_type": 1, "press_type": "tap", "height": 0, "beat": 9, "duration": 4},
	length_array := []
):
	beat_type = data["beat_type"]
	time_pos = data["beat"] * Global.sec_per_beat 
	height = data["height"]
	press_type = data["press_type"]
	
	position = pos + Vector2(0, -100)
	if beat_type == 1:
		modulate = Color(1.0, 1.0, 1.0)
	elif beat_type == 2:
		modulate = Color(1.0, 0.0, 0.0)
	if press_type == "hold":
		hold_initialise(pos, data, length_array)
func hold_initialise(
	pos: Vector2,
	data := {"beat_type": 1, "press_type": "tap", "height": 0, "beat": 9, "duration": 4},
	length_array := []
):
	hold_time = data["duration"] * Global.sec_per_beat
	hold_beat = $HoldBeat
	hold_line = $HoldLine
	hold_beat.position.x = -hold_position
	hold_position = length_array[-1]
	position.x += hold_position
	for point in length_array:
		hold_line.add_point(Vector2(point, 0))
	
	hold_beat.visible = true
