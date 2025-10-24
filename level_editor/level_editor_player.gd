extends Node2D
@export var play_toggle: Button
@export var beat_editor: BeatEditor
@export var level_editor: Node2D
@onready var player := $Player
@export var editor_camera: Camera2D

enum PlayState {Play, Pause}
var curr_play_state: PlayState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.song_end.connect(func end_song(): play_toggle.button_pressed = false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_toggled(toggled_on: bool) -> void:
	if toggled_on:
		play_toggle.text = "Pause"
		curr_play_state = PlayState.Play
		player.set_baked_points(level_editor.baked_points_array)
		Global.play(beat_editor.beat_position)
		editor_camera.enabled = false
	else:
		play_toggle.text = "Play"
		curr_play_state = PlayState.Pause
		Global.pause()
		editor_camera.enabled = true
