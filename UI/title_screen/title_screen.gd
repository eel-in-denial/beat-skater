extends Node2D
@export var music: AudioStreamOggVorbis
@export var bpm := 100

@onready var buttons = [$Play, $Settings, $LevelEditor]
var button_positions = []

var current_button_idx := 0:
	set(value):
		change_button(current_button_idx, value)
		current_button_idx = value
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for b in buttons:
		button_positions.append(b.position)
	var tween := get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(buttons[0], "position", button_positions[0] - Vector2(300, 0), 0.3)
	Global.init_song(music)
	Global.bpm = bpm
	Global.play_background(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		current_button_idx = current_button_idx - 1 if current_button_idx > 0 else 2
	elif event.is_action_pressed("down"):
		current_button_idx = current_button_idx + 1 if current_button_idx < 2 else 0
	elif event.is_action_pressed("select"):
		buttons[current_button_idx].button_pressed = true
		print("akshdf")

func change_button(prev_idx, next_idx):
	var tween := get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(buttons[prev_idx], "position", button_positions[prev_idx], 0.3)
	tween.parallel().tween_property(buttons[next_idx], "position", button_positions[next_idx] - Vector2(300, 0), 0.3)
	

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_play_toggled(toggled_on: bool) -> void:
	if Global.is_calibrated:
		GameManager.change_scene("level_select")
	else:
		GameManager.change_scene("calibrate")


func _on_settings_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.


func _on_level_editor_toggled(toggled_on: bool) -> void:
	GameManager.change_scene("level_editor")
