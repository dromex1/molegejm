extends Node

var btn_player: AudioStreamPlayer
var music_player: AudioStreamPlayer

func _ready():
	btn_player = AudioStreamPlayer.new()
	btn_player.stream = load("res://btnclick.mp3")
	add_child(btn_player)
	
	music_player = AudioStreamPlayer.new()
	var music_stream = load("res://Track 7 (My Farm).wav")
	music_player.stream = music_stream
	music_player.volume_db = -4.4
	music_player.autoplay = true
	add_child(music_player)
	music_player.finished.connect(_on_music_finished)
	
	var pl = Translation.new()
	pl.locale = "pl"
	pl.add_message("BTN_PLAY", "GRAJ")
	pl.add_message("BTN_SETTINGS", "USTAWIENIA")
	pl.add_message("BTN_BACK", "WRÓĆ")
	pl.add_message("LBL_TITLE", "WHACK-A-MOLE")
	pl.add_message("LBL_SETTINGS", "USTAWIENIA JĘZYKA")
	pl.add_message("LBL_SCORE", "Wynik: ")
	pl.add_message("LBL_BEST", "Top: ")
	TranslationServer.add_translation(pl)

	var en = Translation.new()
	en.locale = "en"
	en.add_message("BTN_PLAY", "PLAY")
	en.add_message("BTN_SETTINGS", "SETTINGS")
	en.add_message("BTN_BACK", "BACK")
	en.add_message("LBL_TITLE", "WHACK-A-MOLE")
	en.add_message("LBL_SETTINGS", "LANGUAGE SETTINGS")
	en.add_message("LBL_SCORE", "Score: ")
	en.add_message("LBL_BEST", "Best: ")
	TranslationServer.add_translation(en)
	
	TranslationServer.set_locale("pl")

func play_click():
	if btn_player and btn_player.stream:
		btn_player.play()

func _on_music_finished():
	music_player.play()
