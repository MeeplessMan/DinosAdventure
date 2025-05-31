class_name HealthHandler
extends Node2D


@export var parent:Node2D =  null
@export var base_health_max: int = 10
@export var death_handler: DeathHandler = null
@export var animated_sprite:AnimatedSprite2D = null

var current_health : int = 0

signal apply_damage(value:int)
signal apply_heal(value:int)

func _ready():
	apply_damage.connect(on_apply_damage)
	apply_heal.connect(on_heal_damage)
	current_health = base_health_max

func handle_health() -> void:
	if current_health>base_health_max:
		current_health==base_health_max
	if current_health>0:
		parent.get_health.emit(current_health)
		return
	if current_health<=0:
		current_health=0
		if parent.name != "Player":
			if parent.get_node("Hurt_Box") != null:
				parent.get_node("Hurt_Box").queue_free()
			if parent.get_node("Hit_Box") != null:
				parent.get_node("Hit_Box").queue_free()
		parent.get_health.emit(current_health)
		if death_handler==null:
			print("ERROR: DEATH_HANDLER UN-ASSIGNED")
			return
		death_handler.handle_death.emit()

func calc_damage(value:int)->void:
	current_health -=value
func on_apply_damage(value:int)->void:
	animated_sprite.play("death")
	handle_health()
	if value > 0:
		calc_damage(value)
		handle_health()
func on_heal_damage(value:int)->void:
	handle_health()
	if value > 0:
		calc_damage(-value)
		handle_health()
