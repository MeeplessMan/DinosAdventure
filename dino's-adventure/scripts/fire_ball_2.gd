extends AnimatedSprite2D

var speed:int = 250
var direction:int
@onready var timer: Timer = $Timer

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
	queue_free()
