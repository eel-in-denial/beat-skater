extends Node2D
@export var music: AudioStreamOggVorbis
@export var bpm := 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.init_song(music, bpm)
	Global.play_background()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_pressed() -> void:
	if Global.is_calibrated:
		GameManager.change_scene("level_select")
	else:
		GameManager.change_scene("calibrate")

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_exit_2_pressed() -> void:
	pass # Replace with function body.


func _on_level_creator_pressed() -> void:
	GameManager.change_scene("level_editor")
