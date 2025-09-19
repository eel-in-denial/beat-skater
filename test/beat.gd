extends Area2D
class_name Beat

var beat_type :=  1
#var is_long_beat := false
var height := 0
var time_pos := 0.0
var hold_time := 0.0
var hold_position := 0.0
var hold_sprite: CollisionShape2D
var hold_line: Line2D
var is_held = false
var is_long_playing = false

func _process(delta: float) -> void:
	if is_long_playing:
		hold_position -= Global.speed * delta
		if hold_position >= 0:
			hold_sprite.position.x = -hold_position
			hold_line.set_point_position(1, Vector2(-hold_position, 0))
		else:
			is_long_playing = false
			hold_sprite.visible = false
			hold_line.clear_points()
		

func initialise(
	beat_type_set := 1,  height_set := 0, time_pos_set := 0.0, 
	position_set := Vector2.ZERO, hold_time_pos_set := 0.0
):
	beat_type = beat_type_set
	time_pos = time_pos_set
	position = position_set
	#is_long_beat = is_long_beat_set
	if beat_type == 1 or beat_type == 11:
		modulate = Color(1.0, 1.0, 1.0)
	elif beat_type == 2 or beat_type == 22:
		modulate = Color(1.0, 0.0, 0.0)
	if beat_type == 11 or beat_type == 22:
		hold_time = hold_time_pos_set
		hold_position = hold_time * Global.speed
		position.x += hold_position
		hold_sprite = $HoldBeat
		hold_line = $HoldLine
		hold_line.add_point(Vector2(-hold_position, 0))
		hold_sprite.position.x = -hold_position
		hold_sprite.visible = true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.on_beat = self
		

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and not is_long_playing:
		body.on_beat = null


func _on_area_entered(area: Area2D) -> void:
	if (beat_type == 11 or beat_type == 22) and area.is_in_group("hold_area") and not is_held:
		hold_sprite.visible = false
		is_long_playing = true
