extends Control
@onready var title := $VBoxContainer/Title

func init_data(data: Dictionary):
	title.text = data["title"]
