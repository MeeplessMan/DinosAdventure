extends Node2D
@onready var hurt: AudioStreamPlayer2D = $hurt
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var frog: Node2D = $"."
@onready var timer: Timer = $Timer
@onready var timer2: Timer = $Timer2
@onready var timer3: Timer = $Timer3
@onready var marker: Marker2D = $Spawn
const WISP_BALL = preload("res://scenes/projectiles/wisp_ball.tscn")
@export var fire_rate:float = 2.5
const HCOIN = preload("res://scenes/entities/hcoin.tscn")
var shoot:bool = true
var damageTaken=false
var health=5
var change=true
const speed = 40
@export var direction = 1
var marker_position

signal apply_damage(value:int)
signal get_health(value:int)

func _ready():
	apply_damage.connect(check_damage)
	get_health.connect(check_health)
	timer.connect("timeout", set_change)
	timer2.connect("timeout", set_death)
	timer3.connect("timeout", set_cooldown)
	timer.wait_time = 0.2
	timer2.wait_time = 2.0
	timer3.wait_time = fire_rate
	marker_position = marker.position

func set_cooldown()->void:
	shoot=true

func fire_projectile()->void:
	if shoot:
		var bullet_instance = WISP_BALL.instantiate() as Node2D
		bullet_instance.global_position = marker.global_position
		bullet_instance.direction = direction
		get_parent().add_child(bullet_instance)
		shoot=false
		timer3.start()
		
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
			fire_projectile()
			animated_sprite.play("idle")

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
