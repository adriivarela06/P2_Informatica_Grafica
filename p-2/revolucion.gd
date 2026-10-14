extends MeshInstance3D

func _ready() -> void:
	var perfil := PackedVector2Array([
		Vector2(0.0, 0.0),   # Base del jarron
		Vector2(0.6, 0.0),   # Borde exterior de la base del jarron
		Vector2(0.3, 0.3),   # Cuello de la base
		Vector2(0.7, 0.6),   # Comienzo del ancho del jarron
		Vector2(0.8, 0.9),   # Parte más ancha del jarron
		Vector2(0.4, 1.4),   # Comienzo del cuello del jarron
		Vector2(0.2, 1.7),   # Cuello del jarron
		Vector2(0.2, 1.9),   # Final del cuello del jarron
		Vector2(0.35, 2.0),  # Borde inferior de la boca del jarron
		Vector2(0.0, 2.0)    # Borde superior de la boca del jarron
	])

	var copias := 128 # Numero de revoluciones que hacemos
	
	var vertices := PackedVector3Array()
	var triangulos := PackedInt32Array()

	# Llamada al script GeneradorMallas
	GeneradorMallas.generarRevolucion(perfil, copias, vertices, triangulos)

	# Calculo de normales con el script Utilidades
	var normales = Utilidades.calcNormales(vertices, triangulos)

	# Empaquetado de datos en las tablas
	var tablas := []
	tablas.resize(Mesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_VERTEX] = vertices
	tablas[Mesh.ARRAY_INDEX] = triangulos
	tablas[Mesh.ARRAY_NORMAL] = normales

	# Creación de la malla final
	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas)

	# Creación y asignación del material con sombreado por píxel
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.8, 0.2, 0.4) 
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
	material_override = mat
