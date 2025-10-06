extends Node2D

@onready var song_pos := $Label
var level_data: Dictionary
var beat_array: Array[Dictionary] = []
var beat_pressed := 0.0
# Called when the node enters the scene tree for the first time.
func initialize_data(data := {"json_path": ""}):
	var json_path = data["json_path"]
	level_data = Global.load_json_data(json_path)
	Global.new_level(load(level_data["song_path"]), level_data["bpm"])
	

func _physics_process(delta: float) -> void:
	song_pos.text = str(Global.beat_position)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("beat_1") or event.is_action_pressed("beat_2"):
		beat_pressed = Global.beat_position
	elif event.is_action_released("beat_1") or event.is_action_released("beat_2"):
		var beat_type: int = 1 if event.is_action_released("beat_1") else 2
		var press_type: String = "tap" if Global.beat_position - beat_pressed < 0.6 else "hold"
		var beat: float = snappedf(beat_pressed, 0.5)
		var duration: float = snappedf(Global.beat_position - beat_pressed, 0.5)
		beat_array.append({
			"beat_type": beat_type,
			"press_type": press_type,
			"height": 0,
			"beat": beat,
			"duration": duration
		  })
func _on_button_pressed() -> void:
	DisplayServer.clipboard_set(str(beat_array))
