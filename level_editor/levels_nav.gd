extends Control

@onready var items_list_res = $Panel/VBoxContainer/ItemListRes
@export var level_editor: LevelEditor
var res_level_data: Array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	res_level_data = Global.load_json_data("res://levels/level_data/levels_res.json")["array"]
	for level in res_level_data:
		items_list_res.add_item(level["title"])
	items_list_res.select(0)
	_on_item_list_res_item_selected(0)
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_item_list_res_item_selected(index: int) -> void:
	level_editor.level_json_path = res_level_data[index]["editor_path"]
