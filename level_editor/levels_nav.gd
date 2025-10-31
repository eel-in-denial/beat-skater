extends Control

@onready var items_list_res = $Panel/VBoxContainer/ItemListRes
@export var level_editor: LevelEditor
@export var edit_popup: Panel
@onready var right_click_popup := $PopupPanel

var res_level_data: Array
var level_idx: int
var current_level: Dictionary
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	res_level_data = Global.load_json_data("res://levels/level_data/levels_res.json")
	edit_popup.save_song_data.connect(update_song_list)
	for level in res_level_data:
		items_list_res.add_item(level["title"])
	items_list_res.select(0)
	_on_item_list_res_item_clicked(0, Vector2.ZERO, MOUSE_BUTTON_LEFT)
			

func update_song_list(idx: int, data: Dictionary):
	print(data)
	var header_data = data["header"]
	var body_data = data["body"]
	if idx == -1:
		header_data["path"] = "res://levels/level_data/" + header_data["title"] + ".json"
		header_data["editor_path"] = "res://levels/level_editor_data/" + header_data["title"] + "_editor.json"
		header_data["graphics_path"] = "res://levels/level_graphics_data/" + header_data["title"] + "_graphics.json"
		var level_save = {
		}
		var editor_save = {
			"bpm": body_data["bpm"],
			"init_player_speed": body_data["init_player_speed"],
			"beats_per_bar": body_data["beats_per_bar"],
			"beats": [],
			"curve_points": [],
			"total_bars": 8
		}
		
		var graphics_save = {
			"bg_colour": "75a0bd",
			"slope_colour": "75a0bd",
			"sprites": []
		}
		
		Global.save_json_data(header_data["path"], level_save)
		Global.save_json_data(header_data["editor_path"], editor_save)
		Global.save_json_data(header_data["graphics_path"], graphics_save)
		res_level_data.append(header_data)
		items_list_res.add_item(header_data["title"])
		items_list_res.select(items_list_res.item_count - 1)
		_on_item_list_res_item_clicked(items_list_res.item_count - 1, Vector2.ZERO, MOUSE_BUTTON_LEFT)
	else:
		Global.rename_file(header_data["path"], "res://levels/level_data/" + header_data["title"] + ".json")
		Global.rename_file(header_data["editor_path"],"res://levels/level_editor_data/" + header_data["title"] + "_editor.json")
		Global.rename_file(header_data["graphics_path"],"res://levels/level_graphics_data/" + header_data["title"] + "_graphics.json")
		header_data["path"] = "res://levels/level_data/" + header_data["title"] + ".json"
		header_data["editor_path"] = "res://levels/level_editor_data/" + header_data["title"] + "_editor.json"
		res_level_data[idx] = header_data
		var editor_save = Global.load_json_data(header_data["editor_path"])
		editor_save["bpm"] = body_data["bpm"]
		editor_save["init_player_speed"] = body_data["init_player_speed"]
		editor_save["beats_per_bar"] = body_data["beats_per_bar"]
		items_list_res.set_item_text(idx, header_data["title"])
		Global.save_json_data(header_data["editor_path"], editor_save)
		
		
	Global.save_json_data("res://levels/level_data/levels_res.json", res_level_data)

func _on_new_level_pressed() -> void:
	get_tree().paused = true
	edit_popup.pop_up()

func _on_item_list_res_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index == MOUSE_BUTTON_RIGHT:
		get_tree().paused = true
		right_click_popup.popup(Rect2i(at_position.x, at_position.y, 164, 150))
		level_idx = index
	elif mouse_button_index == MOUSE_BUTTON_LEFT:
		level_editor.save_editor()
		if not res_level_data.is_empty():
			level_editor.level_json_path = res_level_data[index]["path"]
			level_editor.editor_json_path = res_level_data[index]["editor_path"]
			level_editor.graphics_json_path = res_level_data[index]["graphics_path"]
			current_level = res_level_data[index]


func _on_popup_panel_popup_hide() -> void:
	get_tree().paused = false

func _on_edit_pressed() -> void:
	right_click_popup.hide()
	var editor_data = Global.load_json_data(res_level_data[level_idx]["editor_path"])
	var data = {
		"header": res_level_data[level_idx],
		"body": {
			"bpm": editor_data["bpm"],
			"beats_per_bar": editor_data["beats_per_bar"],
			"init_player_speed": editor_data["init_player_speed"],
		},
		"community": false
	}
	edit_popup.pop_up(data, level_idx)
	get_tree().paused = true

func _on_delete_pressed() -> void:
	right_click_popup.hide()
	Global.delete_file(res_level_data[level_idx]["path"])
	print(res_level_data[level_idx]["editor_path"])
	Global.delete_file(res_level_data[level_idx]["editor_path"])
	res_level_data.pop_at(level_idx)
	items_list_res.remove_item(level_idx)
	Global.save_json_data("res://levels/level_data/levels_res.json", res_level_data)
	if items_list_res.is_selected(level_idx):
		items_list_res.select(max(level_idx-1, 0))
		_on_item_list_res_item_clicked(max(level_idx-1, 0), Vector2.ZERO, MOUSE_BUTTON_LEFT)
		
