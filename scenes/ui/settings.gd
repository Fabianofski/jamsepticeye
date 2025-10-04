extends Control

@onready var music_bus = AudioServer.get_bus_index("Music")
@onready var sound_bus = AudioServer.get_bus_index("Sound")
@onready var sound_slider = $SoundSlider
@onready var music_slider = $MusicSlider

func _ready() -> void:
	sound_slider.value = AudioServer.get_bus_volume_linear(sound_bus)
	music_slider.value = AudioServer.get_bus_volume_linear(music_bus)

func on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(music_bus, value)


func on_audio_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(sound_bus, value)
