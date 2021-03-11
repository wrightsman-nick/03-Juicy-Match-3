extends Node2D

export (String) var color
var is_matched
var is_counted
var selected = false
var target_position = Vector2(0,0)
var default_modulate = Color(1,1,1,1)
var highlight = Color(1,0.8,0,1)

var fall_speed = 1.0

var dying = false


onready var Explosion = load("res://Congrats/Explosion.tscn")
onready var Congrats = load("res://Congrats/Great.tscn")

func _ready():
	randomize()

func _physics_process(_delta):
	if dying and not $Tween.is_active():
		queue_free()
	if selected:
		$Selected.emitting = true
		$Select.show()
		z_index = 10
	else:
		$Selected.emitting = false
		$Select.hide()
		z_index = 1

func move_piece(change):
	target_position = position + change
	position = target_position

func die():
	var explosion = Explosion.instance()
	explosion.position = position
	get_node("/root/Game/Congrats").add_child(explosion)
	explosion.play()
	
	dying = true
	var target_color = $Sprite.modulate
	target_color.s = 1
	target_color.h = randf()
	target_color.a = 0.25
	var fall_duration = randf()*fall_speed + 1
	var rotate_amount = (randi() % 1440) - 720

	var target_pos = position
	target_pos.y = 1100
	$Tween.interpolate_property(self, "position", position, target_pos, fall_duration, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()
	$Tween.interpolate_property($Sprite, "modulate", $Sprite.modulate, target_color, fall_duration-0.25, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.start()
	$Tween.interpolate_property(self, "rotation_degrees", rotation_degrees, rotate_amount, fall_duration-0.25, Tween.TRANS_QUINT, Tween.EASE_IN)
	$Tween.start()

	if color == "Octagon":
		get_node("/root/Game/Break").playing = true
	if color == "Circle":
		get_node("/root/Game/Break2").playing = true
	if color == "Pentagon":
		get_node("/root/Game/Break3").playing = true
	if color == "Triangle":
		get_node("/root/Game/Break4").playing = true
