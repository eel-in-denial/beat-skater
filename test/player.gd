extends CharacterBody2D
var on_beat: Beat
@onready var label := $Label

#func _process(delta: float) -> void:
	#if is_instance_valid(on_beat):
		#print(on_beat)

func _unhandled_input(event: InputEvent) -> void:
	if is_instance_valid(on_beat):
		if event.is_action_pressed("beat_1") and on_beat.beat_type == 1:
			match Global.check_is_on_beat(on_beat.time_pos):
				Global.hit.Perfect:
					label.text = "perfect"
					on_beat.queue_free()
				Global.hit.Good:
					label.text = "good"
					on_beat.queue_free()
				Global.hit.OK:
					label.text = "ok"
					on_beat.queue_free()
				Global.hit.Miss:
					label.text = "miss"
		elif event.is_action_pressed("beat_2") and on_beat.beat_type == 2:
			match Global.check_is_on_beat(on_beat.time_pos):
				Global.hit.Perfect:
					label.text = "perfect"
					on_beat.queue_free()
				Global.hit.Good:
					label.text = "good"
					on_beat.queue_free()
				Global.hit.OK:
					label.text = "ok"
					on_beat.queue_free()
				Global.hit.Miss:
					label.text = "miss"
		elif event.is_action_pressed("beat_1") and on_beat.beat_type == 11:
			on_beat.is_held = true
			on_beat.is_long_playing = true
			on_beat.hold_sprite.visible = true
			match Global.check_is_on_beat(on_beat.time_pos):
				Global.hit.Perfect:
					label.text = "perfect"
				Global.hit.Good:
					label.text = "good"
				Global.hit.OK:
					label.text = "ok"
				Global.hit.Miss:
					label.text = "miss"
		elif event.is_action_pressed("beat_2") and on_beat.beat_type == 22:
			on_beat.is_held = true
			on_beat.is_long_playing = true
			on_beat.hold_sprite.visible = true
			match Global.check_is_on_beat(on_beat.time_pos):
				Global.hit.Perfect:
					label.text = "perfect"
				Global.hit.Good:
					label.text = "good"
				Global.hit.OK:
					label.text = "ok"
				Global.hit.Miss:
					label.text = "miss"
		elif event.is_action_released("beat_1") and on_beat.beat_type == 11:
			on_beat.is_held = false
			on_beat.hold_sprite.visible = false
			match Global.check_is_on_beat(on_beat.time_pos + on_beat.hold_time):
				Global.hit.Perfect:
					label.text = "perfect"
					on_beat.queue_free()
				Global.hit.Good:
					label.text = "good"
					on_beat.queue_free()
				Global.hit.OK:
					label.text = "ok"
					on_beat.queue_free()
				Global.hit.Miss:
					label.text = "miss"
		elif event.is_action_released("beat_2") and on_beat.beat_type == 22:
			on_beat.is_held = false
			on_beat.hold_sprite.visible = false
			match Global.check_is_on_beat(on_beat.time_pos  + on_beat.hold_time):
				Global.hit.Perfect:
					label.text = "perfect"
					on_beat.queue_free()
				Global.hit.Good:
					label.text = "good"
					on_beat.queue_free()
				Global.hit.OK:
					label.text = "ok"
					on_beat.queue_free()
				Global.hit.Miss:
					label.text = "miss"
