extends Node2D

@onready var hurt: AudioStreamPlayer2D = $hurt
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var frog: Node2D = $"."
@onready var timer: Timer = $Timer
@onready var timer2: Timer = $Timer2
const HCOIN = preload("res://scenes/entities/hcoin.tscn")

var damageTaken=false
var health=5
var change=true
const speed = 40
var direction = 1

signal apply_damage(value:int)
signal get_health(value:int)

func _ready():
	apply_damage.connect(check_damage)
	get_health.connect(check_health)
	timer.connect("timeout", set_change)
	timer2.connect("timeout", set_death)
	timer.wait_time = 0.2
	timer2.wait_time = 2.0

func _process(delta: float) -> void:
	if damageTaken:
		damageTaken=false
		change=false
		animated_sprite.play("hurt")
		timer.start()
	if health<=0:
		if animated_sprite.animation != "death":
			animated_sprite.play("death")
			timer2.start()
	else:
		if change:
			animated_sprite.play("run")
			if ray_cast_right.is_colliding():
				direction = -1
				animated_sprite.flip_h = true
			if ray_cast_left.is_colliding():
				direction = 1
				animated_sprite.flip_h = false
		position.x += direction*speed*delta

func check_damage(value:int)->void:
	hurt.play()
	damageTaken=true

func check_health(value:int)->void:
	health=value

func set_change()->void:
	change=true

func set_death()->void:
	var rng =  RandomNumberGenerator.new()
	var random_num = rng.randf_range(0,10)
	if random_num<3:
		var bullet_instance = HCOIN.instantiate() as Node2D
		bullet_instance.global_position = global_position
		get_parent().add_child(bullet_instance)
	queue_free()
	
