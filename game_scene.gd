#https://github.com/lulersoft/godot_mole_game
#Godot QQ Group: 302924317 
#Author:xiaolu (QQ2604904)
extends Node

var moleArr=[]
var timer
var hp=100
var point=0
var maxpoint=0
var gameOver=true
var save_file="user://savedata.bin"
var arrlen=0
var score_str="LBL_SCORE"
var maxscore_str="LBL_BEST"
var level=0
var ambient_player: AudioStreamPlayer
var ambient_timer: Timer

func _ready():
	randomize()
	for i in range(3):
		moleArr.push_back(get_node("bg"+str(i)+"/mole0"))
		moleArr.push_back(get_node("bg"+str(i)+"/mole1"))
		moleArr.push_back(get_node("bg"+str(i)+"/mole2"))	
	
	arrlen=moleArr.size()
	
	for i in range(arrlen):		
		moleArr[i].hit_on_one_mole.connect(onHit)
		moleArr[i].missing_one_mole.connect(onMiss)	
		
	maxpoint=read()
	
	var ui_score = get_node("score")
	ui_score.text = tr(score_str)+str(point)
	ui_score.position = Vector2(100, 30)
	
	var ui_maxscore = get_node("maxscore")
	ui_maxscore.text = tr(maxscore_str)+str(maxpoint)
	ui_maxscore.position = Vector2(100, 70)
	
	var ui_hp = get_node("hp")
	ui_hp.position = Vector2(25, 410)
	ui_hp.size = Vector2(270, 30)

	var ui_panel = get_node("Panel")
	ui_panel.position = Vector2(0, 0)
	ui_panel.size = Vector2(320, 480)
	
	for child in ui_panel.get_children():
		if child is Button or child is TextureButton:
			child.position = Vector2(80, 200)
			child.size = Vector2(160, 60)
			if not child.pressed.is_connected(_on_startButton_pressed):
				child.pressed.connect(_on_startButton_pressed)
	
	timer=Timer.new()
	timer.timeout.connect(onTimer)
	timer.one_shot = false
	timer.wait_time = speed()
	
	add_child(timer)	
	set_process(true)
	
	ambient_player = AudioStreamPlayer.new()
	ambient_player.stream = load("res://sound.mp3")
	add_child(ambient_player)
	
	ambient_timer = Timer.new()
	ambient_timer.wait_time = randf_range(3.0, 8.0)
	ambient_timer.autostart = true
	ambient_timer.timeout.connect(_on_ambient_timeout)
	add_child(ambient_timer)

func _on_ambient_timeout():
	if not gameOver and ambient_player and ambient_player.stream:
		ambient_player.play()
	ambient_timer.wait_time = randf_range(3.0, 8.0)

func _process(_delta):
	if(Input.is_action_pressed("ui_cancel")):
		get_tree().quit()
		
func speed():
	return (10.0-level)/10.0

func change_speed():
	level=level+1
	if (level>=5):
		level=5
	timer.wait_time = speed()
	print("change game level "+str(speed()))
	
func onHit(_obj):
	point=point+1
	get_node("score").text = tr(score_str)+str(point)
	if maxpoint<point:
		maxpoint=point
		save()
	get_node("maxscore").text = tr(maxscore_str)+str(maxpoint)
	
	if (point>0 and point%25==0):
		change_speed()

func onMiss(_obj):
	hp=hp-10
	if hp<0:
		hp=0
	get_node("hp").value = hp	
	if hp==0:
		gameOver=true
		get_node("Panel").show()
		timer.stop()
		for i in range(moleArr.size()):
			moleArr[i].gameover()

func onTimer():
	if gameOver==false:
		moleComeOut()		

func moleComeOut():	
	var idx = randi() % arrlen
	var mole=moleArr[idx]
	if gameOver==false:
		if mole.status==1:
			get_tree().create_timer(0.1).timeout.connect(moleComeOut)
		else:
			mole.comeOut()

func _on_startButton_pressed():
	Global.play_click()
	get_node("Panel").hide()
	gameOver=false
	hp=100
	point=0
	level=0
	
	for i in range(moleArr.size()):
		moleArr[i].gamestart()
	
	get_node("hp").value = hp	
	get_node("score").text = tr(score_str)+str(point)
	timer.wait_time = speed()
	timer.start()
	
func save():
	var f = FileAccess.open_encrypted_with_pass(save_file, FileAccess.WRITE, "godot")
	if f:
		f.store_64(maxpoint)
		f.close()
	
func read():
	var v=0
	if FileAccess.file_exists(save_file):
		var f = FileAccess.open_encrypted_with_pass(save_file, FileAccess.READ, "godot")
		if f:
			v=f.get_64()
			f.close()	
	return v