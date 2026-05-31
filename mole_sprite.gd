#https://github.com/lulersoft/godot_mole_game
#Godot QQ Group: 302924317 
#Author:xiaolu (QQ2604904)
extends AnimatedSprite2D

var status=0
var live=0

var speed=0
var original
var to

var tween : Tween

var mouse_in = false

var hit_player: AudioStreamPlayer

signal hit_on_one_mole(obj)
signal missing_one_mole(obj)

func _ready():
	hit_player = AudioStreamPlayer.new()
	hit_player.stream = load("res://molehit.mp3")
	add_child(hit_player)
	
	original=position
	to=Vector2(original.x,original.y-60)	

func _input(e):
	if mouse_in && (e is InputEventMouseButton):
		if e.pressed:
			onClick()

func gamestart():
	live=0
	status=0
	position=original
	
func gameover():
	if tween:
		tween.kill()

func onClick():	
	if live==0:
		return	
	live=0	
	
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_callback(comIn).set_delay(0.5)
	
	get_node("anim").play("die")
	if hit_player and hit_player.stream:
		hit_player.play()
	hit_on_one_mole.emit(self)	
	
func comeOut():
	status=1
	live=1
	
	get_node("anim").play("run")
	var t=0.3	
	
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", to, t).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_callback(onOutcomplete)
	
func onOutcomplete():	
	comIn()
	
func comIn():
	var t=0.3
	var delay=0.5
	
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_interval(delay)
	tween.tween_property(self, "position", original, t).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_callback(onIncomplete)
	
func onIncomplete():	
	status=0
	if live==1:
		missing_one_mole.emit(self)
		
func _on_Area2D_mouse_entered():
	mouse_in = true

func _on_Area2D_mouse_exited():
	mouse_in = false	