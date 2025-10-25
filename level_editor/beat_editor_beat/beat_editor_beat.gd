extends Control
class_name EditorBeat

signal delete(beat: EditorBeat)
signal selected(beat: EditorBeat)
signal dropped
signal extending_selected(beat: EditorBeat)
signal extending_unselected(beat: EditorBeat)

@onready var panel := $Beat
@onready var line := $line
@onready var draggable := $Draggable

var beat_type :=  1
var press_type := "tap"
var height := 0
var time_pos := 0.0
var hold_time := 0.0
var hold_position := 0.0

var beat_data: Dictionary

var is_extending
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draggable.visible = false
	line.visible = false

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

func _on_beat_gui_input(event: InputEvent) -> void:
	if event.is_action("right_click"):
		delete.emit(self)
		queue_free()
	elif event.is_action_pressed("left_click"):
		selected.emit(self)
		draggable.visible = true
		line.visible = true
	elif event.is_action_released("left_click"):
		dropped.emit()


func _on_draggable_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		extending_selected.emit(self)
		is_extending = true
	elif event.is_action_released("left_click"):
		is_extending = false
		extending_unselected.emit(self)
	elif event.is_action_pressed("right_click"):
		reset_to_tap()

func update_line(beat_width: float):
	if beat_data["duration"] > 0:
		line.size.x = beat_width * beat_data["duration"]
		draggable.position.x = beat_width * beat_data["duration"] - 7
		draggable.visible = true
		line.visible = true
	else:
		draggable.position.x = 18
		line.size.x = 20
	if beat_data["duration"]:
		beat_data["press_type"] = "hold"
	else:
		beat_data["press_type"] = "tap"

func reset_to_tap():
	line.visible = false
	draggable.visible = false
	beat_data["press_type"] = "tap"
	beat_data["duration"] = 0
