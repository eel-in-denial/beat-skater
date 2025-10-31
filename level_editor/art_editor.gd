extends Panel
class_name GraphicsEditor

var graphics_panel = preload("res://level_editor/graphics_panel.tscn")
@export var level_editor: LevelEditor

@export var slope: Path2D
@onready var slope_color_picker = $VBoxContainer/HBoxContainer/SlopeColourPicker
@onready var bg_color_picker = $VBoxContainer/HBoxContainer/BackgroundColourPicker
@onready var flow_container := $VBoxContainer/HSplitContainer/ScrollContainer/HFlowContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dir = DirAccess.open("res://background_assets/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if "import" not in file_name:
				var instance = graphics_panel.instantiate()
				flow_container.add_child(instance)
				instance.set_texture(load(dir.get_current_dir() + "/" + file_name))
			file_name = dir.get_next()

func initialise(slope_color: Color, bg_color: Color):
	slope_color_picker.color = slope_color
	bg_color_picker.color = bg_color
	slope.set_color(slope_color)
	RenderingServer.set_default_clear_color(bg_color)
	level_editor.save_graphics()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_slope_colour_picker_color_changed(color: Color) -> void:
	slope.set_color(color)
	level_editor.save_graphics()


func _on_background_colour_picker_color_changed(color: Color) -> void:
	RenderingServer.set_default_clear_color(color)
	level_editor.save_graphics()
