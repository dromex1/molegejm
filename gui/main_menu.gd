extends Control

func _ready():
	$VBoxContainer/BtnPlay/Label.text = tr("BTN_PLAY")
	$VBoxContainer/BtnSettings/Label.text = tr("BTN_SETTINGS")
	$TitleLabel.text = tr("LBL_TITLE")

func _on_play_pressed():
	Global.play_click()
	get_tree().change_scene_to_file("res://game_scene.scn")

func _on_settings_pressed():
	Global.play_click()
	get_tree().change_scene_to_file("res://gui/settings_scene.tscn")
