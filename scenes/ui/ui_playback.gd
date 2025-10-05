extends Node

var playback: AudioStreamPlaybackPolyphonic

func _enter_tree() -> void:
	var player = AudioStreamPlayer.new()
	add_child(player)

	var stream = AudioStreamPolyphonic.new()
	stream.polyphony = 32
	player.stream = stream
	player.play()
	playback = player.get_stream_playback()

	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node:Node) -> void:
	if node is Button:
		node.mouse_entered.connect(_play_hover)
		if !node.is_in_group("ignore_press_sfx"):
			node.pressed.connect(_play_pressed)
	if node is Slider: 
		node.mouse_entered.connect(_play_hover)
		node.changed.connect(_play_pressed)

func _play_hover() -> void:
	var playback_type = AudioServer.PlaybackType.PLAYBACK_TYPE_DEFAULT
	playback.play_stream(preload('res://scenes/ui/controls/switch13.ogg'), 0, 0, randf_range(0.9, 1), playback_type, &"Sound")


func _play_pressed() -> void:
	var playback_type = AudioServer.PlaybackType.PLAYBACK_TYPE_DEFAULT
	playback.play_stream(preload('res://scenes/ui/controls/click3.ogg'), 0, 0, 1, playback_type, &"Sound")

func play_sound(stream: AudioStream): 
	var playback_type = AudioServer.PlaybackType.PLAYBACK_TYPE_DEFAULT
	playback.play_stream(stream, 0, 0, 1, playback_type, &"Sound")

