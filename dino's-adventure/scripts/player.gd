extends CharacterBody2D

var time_path
var save_path = "res://savegame.cfg"
@onready var timer2: Timer = $Timer2
var SPEED = 100.0
var parent
const JUMP_VELOCITY = -260.0
@onready var main: CharacterBody2D = $"."
var FIRE_BALL = preload("res://scenes/projectiles/fire_ball.tscn")
const FIRE_BALL_2 = preload("res://scenes/projectiles/fire_ball_2.tscn")
@onready var marker: Marker2D = $Spawn
@onready var fire_timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var jump: AudioStreamPlayer2D = $jump
@onready var death: AudioStreamPlayer2D = $death
@onready var hurt: AudioStreamPlayer2D = $hurt
@onready var shoot: AudioStreamPlayer2D = $shoot
@onready var timer3: Timer = $Timer3

var TYPE = "player"


var damageTaken = false
var hold = true
var can_fire: bool = true
var dir:int = 1
var muzzle_position
@export var fire_rate:float = 1.0
var health:int = 10
@export var hud: CanvasLayer= null
@export var health_handler:HealthHandler=null
var dead = true
var power = true
var done = true
var time
signal apply_damage(value:int)
signal get_health(value:int)
signal apply_power(value:int)
signal apply_finish(value:int)
signal set_time(value:float)

func _ready():
	set_time_path()
	set_time.connect(change_time)
	apply_power.connect(start_power)
	apply_damage.connect(check_damage)
	apply_finish.connect(complete)
	get_health.connect(set_hearts)
	fire_timer.connect("timeout",set_can_fire)
	fire_timer.wait_time=fire_rate
	timer2.connect("timeout",set_change)
	timer3.connect("timeout", set_power_off)
	timer2.wait_time=0.2
	muzzle_position=marker.position

func change_time(value:float)->void:
	time = value
func complete(value:int):
	var time_config = ConfigFile.new()
	var err = time_config.load(save_path)
	if value==0 and done:
		done = false
		get_tree().change_scene_to_file("res://scenes/menus/select_test.tscn")
	if value == 1 and done:
		done = false
		var temptime = time
		var coins = hud.get("score")
		time_config.set_value("level1", "last_time", temptime)
		if coins>int(time_config.get_value("level1","coins")):
			time_config.set_value("level1","coins",coins)
		var besttime = float(time_config.get_value("level1","best_time"))
		if temptime<besttime or besttime==0.0:
			time_config.set_value("level1","best_time",temptime)
		if !time_config.get_value("level1","completed"):
			time_config.set_value("level1","completed", true)
		reset_time()
		time_config.save(save_path)
		get_tree().change_scene_to_file("res://scenes/menus/select_level_1.tscn")
	if value == 2 and done:
		done = false
		var temptime = time
		var coins = hud.get("score")
		time_config.set_value("level2", "last_time", temptime)
		if coins>int(time_config.get_value("level1","coins")):
			time_config.set_value("level2","coins",coins)
		var besttime = float(time_config.get_value("level2","best_time"))
		if temptime<besttime or besttime==0.0:
			time_config.set_value("level2","best_time",temptime)
		if !time_config.get_value("level2","completed"):
			time_config.set_value("level2","completed", true)
		reset_time()
		reset_time()
		time_config.save(save_path)
		get_tree().change_scene_to_file("res://scenes/menus/select_level_2.tscn")
func start_power(value:int)->void:
	timer3.wait_time = float(value)
	fire_rate = 0.5
	fire_timer.wait_time = fire_rate
	SPEED = 120.0
	power=false
	timer3.start()

func set_power_off()->void:
	fire_rate = 1
	fire_timer.wait_time = fire_rate
	SPEED = 100.0
	power=true
	
func send_heal(value:int)->void:
	health_handler.apply_heal.emit(value)
	
func set_change()->void:
	hold=true

func fire_projectile()->void:
	if Input.is_action_just_pressed('fire') and can_fire==true:
		shoot.play()
		if power:
			var bullet_instance = FIRE_BALL.instantiate() as Node2D
			bullet_instance.global_position = marker.global_position
			bullet_instance.direction = dir
			get_parent().add_child(bullet_instance)
		else:
			var bullet_instance = FIRE_BALL_2.instantiate() as Node2D
			bullet_instance.global_position = marker.global_position
			bullet_instance.direction = dir
			get_parent().add_child(bullet_instance)
		can_fire=false
		fire_timer.start()

func player_muzzle_position():
	if dir>0:
		marker.position.x = muzzle_position.x
	elif dir < 0:
		marker.position.x = -muzzle_position.x
func set_can_fire()->void:
	can_fire=true
	
func _physics_process(delta: float) -> void:
	var idle;
	var run;
	var ump;
	var eath;
	if power:
		idle = "idle"
		run = "run"
		ump = "jump"
		eath = "death"
	else:
		idle = "p_idle"
		run = "p_run"
		ump = "p_jump"
		eath = "p_death"
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed(" jump") and is_on_floor():
		jump.play()
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("escape"):
		reset_time()
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction != 0:
		dir = direction
	player_muzzle_position()
	fire_projectile()
	if direction>0:
		animated_sprite_2d.flip_h = false
	elif direction<0:
		animated_sprite_2d.flip_h = true
	if hold and dead:	
		if is_on_floor():
			if direction == 0:
				animated_sprite_2d.play(idle)
			else:
				animated_sprite_2d.play(run)
		else:
			if true:
				animated_sprite_2d.play(ump)
		if damageTaken:
			damageTaken=false
			hold=false
			animated_sprite_2d.play(eath)
			timer2.start()
	if !collision_shape_2d and dead:
		save_temp_time()
		dead=false
		death.play()
		animated_sprite_2d.play(eath)
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func set_time_path()->void:
	var parent = get_parent().name
	if parent == "Level1":
		time_path = "res://lvl/lvl1.cfg"
	elif parent == "Level2":
		time_path = "res://lvl/lvl2.cfg"

func save_temp_time()->void:
	var parent = get_parent().name
	if parent != "Game":
		var time_config = ConfigFile.new()
		var err = time_config.load(time_path)

		if parent == "Level1":
			time_config.set_value("level1","temptime",time)
		elif parent == "Level2":
			time_config.set_value("level2","temptime",time)
		time_config.save(time_path)

func reset_time():
	var parent = get_parent().name
	if parent != "Game":
		var time_config = ConfigFile.new()
		var err = time_config.load(time_path)
		if parent == "Level1":
			time_config.set_value("level1","temptime",0.0)
		elif parent == "Level2":
			time_config.set_value("level2","temptime",0.0)
		time_config.save(time_path)
func check_damage(value:int)->void:
	hurt.play()
	damageTaken=true

func set_hearts(value:int)->void:
	health = value
	if health==0:
		death.play()
	var h1:AnimatedSprite2D = hud.get_node("Hearts").get_node("Heart1")
	var h2:AnimatedSprite2D = hud.get_node("Hearts").get_node("Heart2")
	var h3:AnimatedSprite2D = hud.get_node("Hearts").get_node("Heart3")
	var h4:AnimatedSprite2D = hud.get_node("Hearts").get_node("Heart4")
	var h5:AnimatedSprite2D = hud.get_node("Hearts").get_node("Heart5")
	
	if value==0:
		h1.play("empty")
		h2.play("empty")
		h3.play("empty")
		h4.play("empty")
		h5.play("empty")
	if value==1:
		h1.play("half")
		h2.play("empty")
		h3.play("empty")
		h4.play("empty")
		h5.play("empty")
	if value==2:
		h1.play("full")
		h2.play("empty")
		h3.play("empty")
		h4.play("empty")
		h5.play("empty")
	if value==3:
		h1.play("full")
		h2.play("half")
		h3.play("empty")
		h4.play("empty")
		h5.play("empty")
	if value==4:
		h1.play("full")
		h2.play("full")
		h3.play("empty")
		h4.play("empty")
		h5.play("empty")
	if value==5:
		h1.play("full")
		h2.play("full")
		h3.play("half")
		h4.play("empty")
		h5.play("empty")
	if value==6:
		h1.play("full")
		h2.play("full")
		h3.play("full")
		h4.play("empty")
		h5.play("empty")
	if value==7:
		h1.play("full")
		h2.play("full")
		h3.play("full")
		h4.play("half")
		h5.play("empty")
	if value==8:
		h1.play("full")
		h2.play("full")
		h3.play("full")
		h4.play("full")
		h5.play("empty")
	if value==9:
		h1.play("full")
		h2.play("full")
		h3.play("full")
		h4.play("full")
		h5.play("half")
	if value==10:
		h1.play("full")
		h2.play("full")
		h3.play("full")
		h4.play("full")
		h5.play("full")
