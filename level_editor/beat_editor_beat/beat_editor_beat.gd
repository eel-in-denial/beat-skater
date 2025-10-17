extends Control
class_name EditorBeat

@onready var panel := $Beat
var beat_type :=  1
var press_type := "tap"
var height := 0
var time_pos := 0.0
var hold_time := 0.0
var hold_position := 0.0

var beat_data: Dictionary
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func initialise(
	data := {"beat_type": 1, "press_type": "tap", "height": 0, "beat": 9, "duration": 4},
	length_array := []
):
	beat_data = data
	beat_type = data["beat_type"]
	time_pos = data["beat"] * Global.sec_per_beat 
	height = data["height"]
	press_type = data["press_type"]
	
	if data["beat_type"] == 1:
		modulate = Color(0.38, 0.361, 1.0)
	elif data["beat_type"] == 2:
		modulate = Color(1.0, 0.294, 0.525)
	#if press_type == "hold":
		#hold_initialise(pos, data, length_array)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
