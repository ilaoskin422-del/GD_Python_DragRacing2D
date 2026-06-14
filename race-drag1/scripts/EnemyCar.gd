extends CharacterBody2D

var speed = 0.0
var max_speed = 360.0
var acceleration = 92.0
var race_active = false

var car_sprite: Sprite2D

func _ready():
	add_to_group("enemy")
	load_enemy_car()
	
	# Коллизия
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(55, 95)
	collision.shape = shape
	add_child(collision)
	
	print("🤖 Противник загружен!")

func load_enemy_car():
	car_sprite = Sprite2D.new()
	var texture_path = "res://EnemyCar.png"
	
	if ResourceLoader.exists(texture_path):
		var texture = load(texture_path)
		car_sprite.texture = texture
		car_sprite.scale = Vector2(0.5, 0.5)
		print("✅ Картинка противника загружена!")
	else:
		# Если картинки нет - рисуем красную машину
		print("⚠️ Картинка не найдена, рисую программно")
		draw_red_car()
	
	add_child(car_sprite)

# Резервная отрисовка
func draw_red_car():
	var image = Image.create(120, 160, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	for x in range(35, 85):
		for y in range(30, 140):
			var red = 0.6 + (y - 30) / 110.0 * 0.3
			image.set_pixel(x, y, Color(red, 0.1, 0.1, 1))
	car_sprite.texture = ImageTexture.create_from_image(image)
	car_sprite.scale = Vector2(0.9, 0.9)

func _physics_process(delta):
	if not race_active:
		speed = move_toward(speed, 0, 200 * delta)
		position.y -= speed * delta
		return
	
	speed += acceleration * delta
	if speed > max_speed:
		speed = max_speed
	
	position.y -= speed * delta

func start_race():
	race_active = true
	speed = 0
	position.y = 45.25

func finish_race():
	race_active = false
	speed = 0

func get_current_speed():
	return int(speed)
