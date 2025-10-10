extends Control
var game_scene_files = {}

var curr_game_scene: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_scene_files = {
		"title_screen": load("res://UI/title_screen/title_screen.tscn"),
		"level_select": load("res://UI/level_select/level_select.tscn"),
		"level_play": load("res://levels/level_player.tscn"),
		"calibrate": load("res://UI/calibration/callibration.tscn"),
		"level_create": load("res://level_editor/level_create.tscn"),
		"level_editor": load("res://level_editor/level_editor.tscn"),
		"test" : load("res://test/slope_test.tscn")
		}
	curr_game_scene = get_tree().current_scene


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
		get_tree().root.add_child(curr_game_scene)
	else:
		print("Error, scene not found")
	
