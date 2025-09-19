extends Node

@onready var bg_music = $BGM

signal song_end

var bpm := 120
var sec_per_beat := 60.0 / 100

var song_position := 0.0
var beat_position := 0.0

var audio_offset := 0.0
var visual_offset := 0.0
var input_offset := 0.0

var current_song: AudioStreamOggVorbis

var enabled = false

enum hit {Perfect, Good, OK, Miss}

var speed = 0.0
	

func _ready() -> void:
	new_level(load("res://music/roulette round 2 slow.ogg"),100)
	audio_offset = AudioServer.get_output_latency()
	current_song = bg_music.stream
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enabled:
		song_position = bg_music.get_playback_position() + AudioServer.get_time_since_last_mix() - audio_offset + visual_offset
		beat_position = song_position / sec_per_beat

			
	

func new_level(new_song: Resource, new_bpm: int):
	bg_music.stream = new_song
	bpm = new_bpm
	sec_per_beat = 60.0 / bpm
	bg_music.play()
	enabled = true
	current_song = bg_music.stream

func reset():
	bg_music.stop()
	enabled = false

func check_is_on_beat(time_pos := 0.0):
	var diff: float = abs(song_position - time_pos)
	if diff <= 0.03:
		return hit.Perfect
	elif diff <= 0.6:
		return hit.Good
	elif diff <= 0.1:
		return hit.OK
	return hit.Miss


func _on_bgm_finished() -> void:
	song_end.emit()
