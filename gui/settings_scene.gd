extends Control

func _ready():
	_update_text()

func _on_pl_pressed():
	Global.play_click()
	TranslationServer.set_locale("pl")
	_update_text()

func _on_en_pressed():
	Global.play_click()
	TranslationServer.set_locale("en")
	_update_text()

func _on_back_pressed():
	Global.play_click()
	get_tree().change_scene_to_file("res://gui/main_menu.tscn")

func _update_text():
	$VBoxContainer/BtnBack/Label.text = tr("BTN_BACK")
	$TitleLabel.text = tr("LBL_SETTINGS")
