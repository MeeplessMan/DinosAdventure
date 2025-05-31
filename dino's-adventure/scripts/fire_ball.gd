extends AnimatedSprite2D

var speed:int = 200
var direction:int
@onready var timer: Timer = $Timer
const PCOIN = preload("res://scenes/entities/pcoin.tscn")

func _ready():
	timer.start()
	timer.connect("timeout", kill)
	
func _physics_process(delta: float) -> void:
	if direction>0:
		flip_h=false
	elif direction<0:
		flip_h=true
	move_local_x(delta*speed*direction)


func kill()->void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	var rng = RandomNumberGenerator.new()
	var random_number = rng.randf_range(0,100)
	if random_number<10:
		var bullet_instance = PCOIN.instantiate() as Node2D
		bullet_instance.global_position = global_position
		get_parent().add_child(bullet_instance)
	queue_free()
