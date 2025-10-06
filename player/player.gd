extends CharacterBody2D
var on_beat: Beat
@onready var label := $Label
var gravity := 9.0
var jump_velocity := -500

func initialize_level():
	velocity.x = Global.player_speed
	Global.player_screen_position = position
	
func _physics_process(delta: float) -> void:
	move_and_slide()

func jump():
	pass

func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("beat_1"):
		#label.text = str(Global.check_is_on_beat_percent())
	if is_instance_valid(on_beat):
		if ((event.is_action_pressed("beat_1") and on_beat.beat_type == 1) or (event.is_action_pressed("beat_2") and on_beat.beat_type == 2)) and on_beat.press_type == "tap":
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
		elif ((event.is_action_pressed("beat_1") and on_beat.beat_type == 1) or (event.is_action_pressed("beat_2") and on_beat.beat_type == 2)) and on_beat.press_type == "hold":
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
		elif ((event.is_action_released("beat_1") and on_beat.beat_type == 1) or (event.is_action_released("beat_2") and on_beat.beat_type == 2)) and on_beat.press_type == "hold":
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
