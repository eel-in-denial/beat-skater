extends Node

@export var label: Label
var beats_array := []:
	set(value):
		beats_array = value
		next_beat = beats_array[0]
var beats_in_range: Array[Beat]
var last_beat_grade
var last_beat_not_hit: bool = true
var next_beat_idx := 0
var next_beat: Beat
@export var player: Player

func _process(delta: float) -> void:
	for beat in beats_in_range:
		if Global.song_position > beat.time_pos + beat.hold_time + Global.ok_time_window:
			check_hit_grade(beat.time_pos)
			beats_in_range.erase(beat)
	if Global.song_position > next_beat.time_pos - Global.ok_time_window:
		beats_in_range.append(next_beat)
		next_beat_idx += 1
		next_beat = beats_array[next_beat_idx] if next_beat_idx < beats_array.size() else null

func _unhandled_input(event: InputEvent) -> void:
	for beat in beats_in_range:
		if ((event.is_action_pressed("beat_1") and beat.beat_type == 1) or (event.is_action_pressed("beat_2") and beat.beat_type == 2)) and beat.press_type == "tap" and player.height == beat.height:
			check_hit_grade(beat.time_pos)
			beat.queue_free()
			beats_in_range.erase(beat)
			print("askjdsfbjksdfbhkdsfbhkdsfs")
			break
		elif ((event.is_action_pressed("beat_1") and beat.beat_type == 1) or (event.is_action_pressed("beat_2") and beat.beat_type == 2)) and beat.press_type == "hold" and player.height == beat.height:
			beat.is_held = true
			beat.is_long_playing = true
			beat.beat_sprite.visible = true
			check_hit_grade(beat.time_pos)
			break
		elif ((event.is_action_released("beat_1") and beat.beat_type == 1) or (event.is_action_released("beat_2") and beat.beat_type == 2)) and beat.press_type == "hold" and player.height == beat.height:
			beat.is_held = false
			beat.beat_sprite.visible = false
			if check_hit_grade(beat.time_pos + beat.hold_time) != Global.hit.Miss:
				beat.queue_free()
				beats_in_range.erase(beat)
			break
	
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
	return last_beat_grade
