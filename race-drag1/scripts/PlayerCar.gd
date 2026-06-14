extends CharacterBody2D

var speed = 0.0
var max_speed = 400.0
var acceleration = 100.0
var race_active = false

var exhaust: GPUParticles2D

func _ready():
	add_to_group("player")
	add_exhaust_effect()
	
	# Загружаем картинку в существующий Sprite2D из сцены
	load_car_texture()
	
	# Коллизия (если нет в сцене)
	if not has_node("CollisionShape2D"):
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.size = Vector2(55, 95)
		collision.shape = shape
		add_child(collision)
	
	print("🚗 Игрок загружен!")

func load_car_texture():
	# Ищем Sprite2D который уже есть в сцене
	var car_sprite = get_node_or_null("Sprite2D")
	
	if not car_sprite:
		# Если нет - создаём новый
		car_sprite = Sprite2D.new()
		car_sprite.name = "Sprite2D"
		add_child(car_sprite)
	
	var texture_path = "res://images.jpg"
	
	if ResourceLoader.exists(texture_path):
		var texture = load(texture_path)
		car_sprite.texture = texture
		car_sprite.scale = Vector2(0.5, 0.5)
		print("✅ Картинка игрока загружена!")
	else:
		print("⚠️ Картинка не найдена: ", texture_path)

func add_exhaust_effect():
	exhaust = GPUParticles2D.new()
	exhaust.position = Vector2(-25, 65)
	exhaust.amount = 8
	exhaust.lifetime = 0.3
	
	var mat = ParticleProcessMaterial.new()
	mat.direction = Vector3(-0.8, 0, 0)
	mat.spread = 25
	mat.initial_velocity_min = 30
	mat.initial_velocity_max = 70
	mat.scale_min = 0.2
	mat.scale_max = 0.5
	mat.color = Color(0.4, 0.4, 0.45, 0.4)
	exhaust.process_material = mat
	exhaust.emitting = false
	add_child(exhaust)

func _physics_process(delta):
	if not race_active:
		speed = move_toward(speed, 0, 300 * delta)
		position.y -= speed * delta
		return
	
	if Input.is_action_pressed("ui_up"):
		speed += acceleration * delta
		if speed > max_speed:
			speed = max_speed
		exhaust.emitting = true
	else:
		speed *= 0.98
		exhaust.emitting = false
	
	position.y -= speed * delta

func start_race():
	race_active = true
	speed = 0
	position.y = 1000
	print("🏁 СТАРТ!")

func finish_race():
	race_active = false
	speed = 0
	exhaust.emitting = false

func get_current_speed():
	return int(speed)
