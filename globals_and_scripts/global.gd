extends Node

@onready var bg_music = $BGM

var bpm := 120
var sec_per_beat := 60.0 / 100

var song_position := 0.0

var audio_offset := 0.0
var visual_offset := 0.0
var input_offset := 0.0

var current_song: AudioStreamOggVorbis

var enabled = false
var speed

enum hit {Perfect, Good, OK, Miss}

var tile_size = 64
	

func _ready() -> void:
	new_level(load("res://music/roulette round 2 slow.ogg"),100)
	audio_offset = AudioServer.get_output_latency()
	current_song = bg_music.stream
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enabled:
		song_position = bg_music.get_playback_position() + AudioServer.get_time_since_last_mix() - audio_offset + visual_offset


			
	

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

#func check_is_on_beat(beat := 0.0):
	#var diff: float = abs(beat_percent - beat)
	#diff = minf(diff, 1.0 - diff)
	#if diff <= 0.15:
		#return hit.Perfect
	#elif diff <= 0.3:
		#return hit.Good
	#elif diff <= 0.45:
		#return hit.OK
	#return hit.Miss
