extends Control

@onready var items_list_res = $Panel/VBoxContainer/ItemListRes
@export var level_editor: LevelEditor
@export var edit_popup: Panel

var res_level_data: Array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	res_level_data = Global.load_json_data("res://levels/level_data/levels_res.json")
	edit_popup.save_song_data.connect(update_song_list)
	for level in res_level_data:
		items_list_res.add_item(level["title"])
	items_list_res.select(0)
	_on_item_list_res_item_selected(0)
			

func update_song_list(idx: int, data: Dictionary):
	print(data)
	if idx == -1:
		var level_save = {
		}
		var editor_save = {
			"bpm": data["body_info"]["bpm"],
			"init_player_speed": data["body_info"]["init_player_speed"],
			"beats": [],
			"curve_points": [],
			"beats_per_bar": 4,
			"total_bars": 8
		}
		data["path"] = "res://levels/level_data/" + data["header_info"]["title"] + ".json"
		data["editor_path"] = "res://levels/level_editor_data/" + data["header_info"]["title"] + "_editor.json"
		Global.save_json_data(data["path"], level_save)
		Global.save_json_data(data["editor_path"], editor_save)
		res_level_data.append(data["header_info"])
		items_list_res.add_item(data["title"])
		items_list_res.select(items_list_res.size - 1)
		_on_item_list_res_item_selected(items_list_res.size - 1)
	else:
		Global.rename_file(data["path"], "res://levels/level_data/" + data["header_info"]["title"] + ".json")
		Global.rename_file(data["editor_path"],"res://levels/level_editor_data/" + data["header_info"]["title"] + "_editor.json")
		data["path"] = "res://levels/level_data/" + data["header_info"]["title"] + ".json"
		data["editor_path"] = "res://levels/level_editor_data/" + data["header_info"]["title"] + "_editor.json"
		res_level_data[idx] = data["header_info"]
		
	Global.save_json_data("res://levels/level_data/levels_res.json", res_level_data)

func _on_item_list_res_item_selected(index: int) -> void:
	level_editor.level_json_path = res_level_data[index]["path"]
	level_editor.editor_json_path = res_level_data[index]["editor_path"]


func _on_new_level_pressed() -> void:
	get_tree().paused = true
	edit_popup.pop_up()
