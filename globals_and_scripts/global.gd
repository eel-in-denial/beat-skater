extends Node

@onready var bg_music := $BGM

signal song_end
signal hit_accuracy(value: float)

var bpm := 120
var sec_per_beat := 60.0 / 100

var time_begin := 0.0

var song_position := 0.0
var beat_position := 0.0
var song_duration := 0.0

var perfect_time_window := 0.05
var good_time_window := 0.12
var ok_time_window := 0.2
var miss_time_window := 0.4

var audio_offset := 0.0
var visual_offset := 0.0
var input_offset := 0.0

var current_song: AudioStreamOggVorbis

var enabled := false

enum hit {Perfect, Good, OK, Miss}

var is_calibrated := false

	

func _ready() -> void:
	current_song = bg_music.stream
	var persist_dir := DirAccess.open("user://")
	if persist_dir:
		if persist_dir.dir_exists("levels"):
			# method that will load saves
			pass
		else:
			persist_dir.make_dir("levels")
			persist_dir.make_dir("levels/level_data")
			persist_dir.make_dir("levels/level_editor_data")
			persist_dir.make_dir("levels/music")
			save_json_data("user://levels/levels_community.json", [])
	else:
		printerr("An error occurred trying to open persistent user:// directory. Error: ", DirAccess.get_open_error())

# Called every frame. 'delta' is the elapsed time since the = frame.
func _process(delta: float) -> void:
	if enabled:
		song_position = (Time.get_ticks_usec() - time_begin) / 1000000.0 - audio_offset + input_offset
		beat_position = song_position/sec_per_beat

func new_level(new_song: Resource, new_bpm: int):
	time_begin = Time.get_ticks_usec()
	audio_offset = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	bg_music.stream = new_song
	bpm = new_bpm
	sec_per_beat = 60.0 / bpm
	bg_music.play()
	enabled = true
	current_song = bg_music.stream
	song_duration = bg_music.stream.get_length()

func init_editor(new_song: Resource, new_bpm: int):
	bg_music.stream = new_song
	bpm = new_bpm
	sec_per_beat = 60.0 / bpm
	current_song = bg_music.stream
	song_duration = bg_music.stream.get_length()
	

func reset():
	bg_music.stop()
	enabled = false

func check_is_on_beat(time_pos := 0.0):
	var diff: float = abs(song_position - time_pos)
	hit_accuracy.emit(song_position - time_pos)
	if diff <= perfect_time_window:
		return hit.Perfect
	elif diff <= good_time_window:
		return hit.Good
	elif diff <= ok_time_window:
		return hit.OK
	return hit.Miss

func check_is_on_beat_percent():
	return beat_position
func _on_bgm_finished() -> void:
	song_end.emit()
	
	
# json
func load_json_data(path: String):
	if not FileAccess.file_exists(path):
		print("Error: JSON file not found at path:", path)
		return {}
	
	var file = FileAccess.open(path, FileAccess.READ)
	
	var content = file.get_as_text()
	file.close()
	
	var parsed_json = JSON.parse_string(content)
	
	if parsed_json is Dictionary or parsed_json is Array:
		return parsed_json
	else:
		print("Error parsing JSON: Invalid format or content in", path)
		return {}
func save_json_data(path: String, data):
	var file = FileAccess.open(path, FileAccess.WRITE)
	var data_json_string = JSON.stringify(data, "\t")
	file.store_string(data_json_string)
	file.close()
	print("✅ Saved data to: ", ProjectSettings.globalize_path(path))

func rename_file(old_path: String, new_path: String):
	var dir = DirAccess.open("res://")
	if dir:
		var error = dir.rename(old_path, new_path)
		if error == OK:
			print("File renamed successfully!")
		else:
			print("Error renaming file: ", error)
	else:
		print("Old file does not exist.")

func delete_file(path: String):
	var dir = DirAccess.open(path.get_base_dir())
	if dir:
		var error = dir.remove(path.get_file())
		if error == OK:
			print("file deleted")
		else:
			print("error deleting file")
	else:
		print("not a valid directory")
