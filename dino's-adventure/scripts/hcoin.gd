extends Area2D
@export var  temp_damage: int = 1
@onready var coin: AudioStreamPlayer2D = $coin
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	area_entered.connect(on_area_entered)

func on_area_entered(area:Area2D)->void:
	if area is HitBox:
		area.apply_heal.emit(temp_damage)
		animated_sprite_2d.queue_free()
		collision_shape_2d.queue_free()
		coin.play()
		await coin.finished
		queue_free()
