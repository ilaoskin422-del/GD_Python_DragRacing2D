extends Node2D

func _ready():
	create_sky()
	create_buildings()
	create_stars()

func create_sky():
	# Ночное небо
	var sky = ColorRect.new()
	sky.size = Vector2(2000, 1200)
	sky.position = Vector2(-500, -100)
	sky.color = Color(0.05, 0.05, 0.15)
	add_child(sky)
	
	# Луна
	var moon = ColorRect.new()
	moon.size = Vector2(50, 50)
	moon.position = Vector2(900, 80)
	moon.color = Color(0.95, 0.9, 0.7)
	add_child(moon)
	
	# Свечение луны
	var glow = ColorRect.new()
	glow.size = Vector2(100, 100)
	glow.position = Vector2(875, 55)
	glow.color = Color(0.95, 0.9, 0.7, 0.3)
	add_child(glow)

func create_buildings():
	# Цвета зданий
	var colors = [
		Color(0.1, 0.1, 0.2),
		Color(0.12, 0.12, 0.22),
		Color(0.08, 0.08, 0.18),
		Color(0.15, 0.15, 0.25)
	]
	
	# 25 зданий
	for i in range(25):
		var building = ColorRect.new()
		var width = randf_range(35, 80)
		var height = randf_range(120, 400)
		var x_pos = randf_range(0, 1150)
		
		building.size = Vector2(width, height)
		building.position = Vector2(x_pos, 1080 - height)
		building.color = colors[randi() % colors.size()]
		add_child(building)
		
		# Окна
		add_windows(building, width, height)
		
		# Антенна на каждом 3 здании
		if i % 3 == 0:
			add_antenna(building, width)

func add_windows(building, width, height):
	var window_color = Color(1, 0.85, 0.4, 0.7)
	
	for x in range(8, int(width) - 5, 14):
		for y in range(10, int(height) - 10, 18):
			if randf() > 0.3:  # Не все окна светятся
				var window = ColorRect.new()
				window.size = Vector2(6, 9)
				window.position = Vector2(x, y)
				window.color = window_color
				window.color.a = randf_range(0.4, 0.9)
				building.add_child(window)

func add_antenna(building, _width):
	var antenna = ColorRect.new()
	antenna.size = Vector2(2, 20)
	antenna.position = Vector2(building.size.x / 2 - 1, -20)
	antenna.color = Color(0.5, 0.5, 0.5)
	building.add_child(antenna)
	
	# Красный огонёк
	var light = ColorRect.new()
	light.size = Vector2(3, 3)
	light.position = Vector2(building.size.x / 2 - 1, -23)
	light.color = Color(1, 0.2, 0.2)
	building.add_child(light)

func create_stars():
	for i in range(200):
		var star = ColorRect.new()
		var size = randf_range(1, 2.5)
		star.size = Vector2(size, size)
		star.position = Vector2(randf_range(0, 1150), randf_range(0, 500))
		star.color = Color(1, 1, 0.9, randf_range(0.3, 0.8))
		add_child(star)
