extends Node2D
@export var play_toggle: Button
@export var beat_editor: BeatEditor
@onready var player := $Player

enum PlayState {Play, Pause}
var curr_play_state: PlayState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_toggled(toggled_on: bool) -> void:
	if toggled_on:
		play_toggle.text = "Pause"
		curr_play_state = PlayState.Play
		
	else:
		play_toggle.text = "Play"
		curr_play_state = PlayState.Pause
