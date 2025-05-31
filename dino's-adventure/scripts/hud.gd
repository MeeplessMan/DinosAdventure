extends CanvasLayer

var master = AudioServer.get_bus_index("Master")
var score = 0
@onready var score_label: Label = $ScoreLabel
@export var player:CharacterBody2D = null
@onready var timer: Label = $timer

signal set_time(value:String)

func _ready():
	set_time.connect(label_time)

func label_time(value:String)->void:
	timer.text = value
	
func add_point():
	score+=1
	score_label.text = str(score)

func _on_sound_pressed() -> void:
	AudioServer.set_bus_mute(master,not AudioServer.is_bus_mute(master))
