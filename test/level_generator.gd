extends Node2D

var background = preload("res://test/background.tscn")
var beat = preload("res://test/beat.tscn")
#var floor = preload("")
var beat_distance := 0.0
var player_position := 480.0

@onready var backgrouds: Array[Sprite2D] = [$Background]
var beats: Array[Beat] = []

var level_1_beats = [[1, 3, 1], [2, 5, 1], [11, 7, 1, 7, 4], 
[1, 9, 1], [1, 9, 2.5], [11, 9, 4, 10, 4], [2, 11, 1], [2, 11, 2.5], [22, 11, 4, 12, 4], [1, 13, 1], [1, 13, 2.5], [11, 13, 4, 14, 2], [1, 14, 3], [2, 14, 3.5], [11, 14, 4.5, 16, 1],
[2, 17, 1], [1, 17, 2.5], [22, 17, 4, 18, 3], [1, 19, 1], [2, 19, 2.5], [11, 19, 4, 20, 3], [2, 21, 1], [1, 21, 2.5], [22, 21, 4, 22, 2], [2, 22, 3], [1, 22, 3.5], [22, 22, 4.5, 24, 4],
[1, 25, 1], [2, 25, 2.5], [11, 25, 4, 26, 2], [2, 26, 3], [1, 26, 3.5], [2, 26, 4], [1, 26, 4.5], [2, 27, 1], [1, 27, 2.5], [22, 27, 4, 28, 2], [1, 28, 2.5], [2, 28, 3.5], [1, 28, 4], [2, 28, 4.5]]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.song_end.connect(transition_to_score)
	Global.speed = 700.0
	Global.new_level(load("res://music/roulette round 2 slow.ogg"),100)
	beat_distance = Global.speed * Global.sec_per_beat
	load_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for b in beats:
		if is_instance_valid(b):
			b.position.x -= Global.speed * delta
			if b.position.x < -100:
				beats.erase(b)
				b.queue_free()
	for b in backgrouds:
		b.position.x -= Global.speed * delta
		if b.position.x < -8000:
			backgrouds.erase(b)
			b.queue_free()
	if backgrouds[-1].position.x < -4000:
		var new_b = background.instantiate()
		new_b.position.x = backgrouds[-1].position.x + 7680.0
		add_child(new_b)
		backgrouds.append(new_b)
	
func load_level():
	for b in level_1_beats:
		var new_beat: Beat = beat.instantiate()
		var time_pos: float = Global.sec_per_beat * ((b[1] - 1) * 4 + b[2] - 1)
		var hold_time := 0.0
		if b[0] == 11 or b[0] == 22:
			hold_time = Global.sec_per_beat * (((b[3] - 1) * 4 + b[4] - 1) - ((b[1] - 1) * 4 + b[2] - 1))
		new_beat.initialise(
			b[0], 0, time_pos, 
			Vector2(player_position + time_pos*Global.speed, 670), hold_time)
		add_child(new_beat)
		beats.append(new_beat)

func transition_to_score():
	get_tree().change_scene_to_file("res://test/title_screen.tscn")
