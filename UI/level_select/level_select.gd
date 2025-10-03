extends Node2D

var level_card_file := preload("res://UI/level_select/level_card/level_card.tscn")

var level_info = [
	{"name": "Level 1", "json_path": "res://levels/level_1.json"},
	{"name": "Level 2"},
	{"name": "Level 3"}
]

var level_cards = []

var selected_level_index = 0

@onready var level_holder := $CanvasLayer/Control/Levels
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_level_cards()


func update_cards(init := false):
	var tween := get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	for i in range(level_cards.size()):
		var level_card = level_cards[i]
		var offset = i - selected_level_index
		
		# X position (centered, spread left/right)
		var x
		if offset == 0:
			x = 660
		elif offset > 0:
			x = offset * 440 - 210 + 960
		else:
			x = offset * 440 - 390 + 960

		# Scale (bigger in center)
		var scale = 1.0 if offset == 0 else 0.7
		scale = max(scale, 0.5)  # minimum size

		# Apply
		if init:
			level_card.position = Vector2(x, 0)
			level_card.scale = Vector2(scale, scale)
			level_card.modulate = Color(1, 1, 1, 1.0 if offset == 0 else 0.7)
		else:
			tween.parallel().tween_property(level_card, "position", Vector2(x, 0), 0.3)
			tween.parallel().tween_property(level_card, "scale", Vector2(scale, scale), 0.3)
			tween.parallel().tween_property(level_card, "modulate", Color(1, 1, 1, 1.0 if offset == 0 else 0.7), 0.3)


func create_level_cards():
	for lvl in level_info:
		var level_card = level_card_file.instantiate()
		level_cards.append(level_card)
		level_holder.add_child(level_card)
		level_card.init_data(lvl)
	update_cards(true)
		
		


func _on_prev_pressed() -> void:
	if selected_level_index >= 1:
		selected_level_index -= 1
		update_cards()


func _on_next_pressed() -> void:
	if selected_level_index < level_cards.size() - 1:
		selected_level_index += 1
		update_cards()


func _on_play_pressed() -> void:
	GameManager.change_scene("level_play", level_info[selected_level_index])
