extends Node2D
@onready var offset := $offset
@onready var offset_avg := $offsetavg
@onready var polygon := $Polygon2D
@export var music: AudioStreamOggVorbis
@export var bpm := 100
var offset_list = []
var ofst_avg := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.new_room(music, bpm)
	

func _physics_process(delta: float) -> void:
	if polygon.scale.x > 1.0:
		polygon.scale -= Vector2(0.01, 0.01)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		var ofst := 0.0
		if Global.beat_percent > 0.5:
			ofst = Global.beat_percent - 1
		else:
			ofst = Global.beat_percent
		offset_list.append(ofst)
		ofst_avg = 0.0
		for o in offset_list:
			ofst_avg += o
		ofst_avg /= offset_list.size()
		offset.text = "Offset: " + str(ofst)
		offset_avg.text = "Offset Average: " + str(ofst_avg)
		polygon.scale = Vector2(1.5, 1.5)
	


func _on_button_pressed() -> void:
	Global.input_offset = 0 #ofst_avg
	get_tree().change_scene_to_file("res://environments/general/overworld.tscn")
	
