extends Node2D
var game_scene_files = {}

var game_manager: Node2D

var curr_game_scene: Array[Node2D]
var curr_sub_scene: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_scene_files["title_screen"] = {"title_screen": load("res://UI/title_screen/title_screen.tscn")}
	game_scene_files["levels"] = {
		"level_select": load("res://UI/level_select/level_select.tscn"),
		"level_play": load("res://levels/level_player.tscn")
		}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_scene(new_scene := "", new_sub := ""):
	if game_scene_files.find_key(new_scene):
		for sub_scene in curr_game_scene:
			sub_scene.queue_free()
		curr_game_scene.clear()
		for sub_scene_file: PackedScene in game_scene_files["new_scene"]:
			curr_game_scene.append(sub_scene_file.instantiate())
			game_manager.add_child()
		curr_game_scene = game_scenes[new_scene]
		curr_game_scene = game_scenes[new_scene]
	else:
		print("Error, scene not found")
	
	game_manager.add_child(curr_game_scene)
	
func change_sub_scene(new_sub := ""):
	pass
