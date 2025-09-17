extends CharacterBody2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	position.x = Global.song_position * 500

	move_and_slide()
