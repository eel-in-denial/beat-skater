extends Node2D
var game_scene_files = {}

var game_manager: Node2D

var curr_game_scene: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_scene_files = {
		"title_screen": load("res://UI/title_screen/title_screen.tscn"),
		"level_select": load("res://UI/level_select/level_select.tscn"),
		"level_play": load("res://levels/level_player.tscn")
		}
	change_scene("title_screen")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_scene(new_scene := "", data := {}):
	if game_scene_files.has(new_scene):
		if curr_game_scene:
			curr_game_scene.queue_free()
		curr_game_scene = game_scene_files[new_scene].instantiate()
		if data:
			curr_game_scene.initialize_data(data)
		add_child(curr_game_scene)
	else:
		print("Error, scene not found")
	
