extends Control
@onready var title := $VBoxContainer/Title

func init_data(data := {"name": "", "level_file": ""}):
	title.text = data["name"]
