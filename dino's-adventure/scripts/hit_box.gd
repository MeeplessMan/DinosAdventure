class_name HitBox
extends Area2D

@export var health_handler: HealthHandler=null
@export var parent:Node2D=null
signal apply_hit(damage:int)
signal apply_heal(value:int)
signal apply_power(value:int)
signal apply_finish(value:int)
func _ready():
	apply_hit.connect(on_apply_hit)
	apply_heal.connect(on_apply_heal)
	apply_power.connect(on_apply_power)
	apply_finish.connect(on_finish)
func on_apply_hit(damage:int)->void:
	if health_handler==null:
		print("ERROR: HEALH_HANDLER UN-ASSIGNED")
		return
	
	health_handler.apply_damage.emit(damage)
	parent.apply_damage.emit(damage)

func on_apply_heal(value:int)->void:
	health_handler.apply_heal.emit(value)

func on_apply_power(value:int):
	if parent.name == "Player":
		parent.apply_power.emit(value)

func on_finish(value:int)->void:
	if parent.name == "Player":
		parent.apply_finish.emit(value)
