extends Node

@export var label: Label
var beats_array := []:
	set(value):
		beats_array = value
		beat_index = 0
		next_beat = beats_array[beat_index]
var next_beat: Beat
var beat_index = 0
var last_beat_grade

func _process(delta: float) -> void:
	if Global.song_position > next_beat.time_pos + Global.miss_time_window:
		print("the fuck  ", Global.song_position, "   ",next_beat.time_pos)
		check_hit_grade(next_beat.time_pos)
		update_next_beat()

func _unhandled_input(event: InputEvent) -> void:
	if ((event.is_action_pressed("beat_1") and next_beat.beat_type == 1) or (event.is_action_pressed("beat_2") and next_beat.beat_type == 2)) and next_beat.press_type == "tap":
		check_hit_grade(next_beat.time_pos)
		update_next_beat()
	elif ((event.is_action_pressed("beat_1") and next_beat.beat_type == 1) or (event.is_action_pressed("beat_2") and next_beat.beat_type == 2)) and next_beat.press_type == "hold":
		next_beat.is_held = true
		next_beat.is_long_playing = true
		next_beat.hold_sprite.visible = true
		check_hit_grade(next_beat.time_pos)
	elif ((event.is_action_released("beat_1") and next_beat.beat_type == 1) or (event.is_action_released("beat_2") and next_beat.beat_type == 2)) and next_beat.press_type == "hold":
		next_beat.is_held = false
		next_beat.hold_sprite.visible = false
		check_hit_grade(next_beat.time_pos)
		update_next_beat()
	
func check_hit_grade(beat_time_pos):
	last_beat_grade = Global.check_is_on_beat(beat_time_pos)
	match last_beat_grade:
		Global.hit.Perfect:
			label.text = "perfect"
		Global.hit.Good:
			label.text = "good"
		Global.hit.OK:
			label.text = "ok"
		Global.hit.Miss:
			label.text = "miss"

func update_next_beat():
	print(last_beat_grade)
	if last_beat_grade != Global.hit.Miss:
		next_beat.queue_free()
	beat_index += 1
	next_beat = beats_array[beat_index]
