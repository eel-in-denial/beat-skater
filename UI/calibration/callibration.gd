extends Node2D
@onready var offset_label := $offset
@onready var offset_avg_label := $offsetavg
@onready var polygon := $Polygon2D
@onready var countdown_label := $Label2
@onready var beat_label := $"beat position"
@export var music: AudioStreamOggVorbis
@export var bpm := 100
var offset_list = []
var ofst_avg := 0.0
var countdown_timer := 0.0
var countdown := 5
var hit_time := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.new_level(music, bpm)
	countdown_timer = Global.sec_per_beat * 4
	hit_time = Global.sec_per_beat * 8

func _physics_process(delta: float) -> void:
	beat_label.text = str(Global.beat_position)
	if Global.song_position >= countdown_timer and countdown > 0:
		countdown -= 1
		countdown_label.text = str(countdown)
		countdown_timer += Global.sec_per_beat
		if countdown == 0:
			countdown_label.text = "Go!"
		
	if polygon.scale.x > 1.0:
		polygon.scale -= Vector2(0.01, 0.01)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("beat_1") or event.is_action_pressed("beat_2"):
		var ofst: float = Global.song_position - hit_time
		hit_time += Global.sec_per_beat
		offset_list.append(ofst)
		ofst_avg = 0.0
		for o in offset_list:
			ofst_avg += o
		ofst_avg /= offset_list.size()
		offset_label.text = "Offset: " + str(ofst)
		offset_avg_label.text = "Offset Average: " + str(ofst_avg)
		polygon.scale = Vector2(1.5, 1.5)
	


func _on_button_pressed() -> void:
	Global.input_offset = ofst_avg
	GameManager.change_scene("level_select")
	
