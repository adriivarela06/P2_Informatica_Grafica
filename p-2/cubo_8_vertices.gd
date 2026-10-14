extends MeshInstance3D

func _ready() -> void:
	# Generación de los 8 vértices
	var vertices := PackedVector3Array()
	for z in [-0.5, 0.5]:
		for y in [-0.5, 0.5]:
			for x in [-0.5, 0.5]:
				vertices.append(Vector3(x, y, z))

	# Definición de los triángulos
	var triangulos := PackedInt32Array([
		# Cara frontal
		4, 5, 7,   4, 7, 6,
		# Cara trasera
		1, 0, 2,   1, 2, 3,
		# Cara izquierda
		0, 4, 6,   0, 6, 2,
		# Cara derecha
		5, 1, 3,   5, 3, 7,
		# Cara superior
		6, 7, 3,   6, 3, 2,
		# Cara inferior
		0, 1, 5,   0, 5, 4
	])

	# Cálculo de normales
	var normales := Utilidades.calcNormales(vertices, triangulos)

	# Empaquetado y creación de la malla
	var tablas : Array = []
	tablas.resize(Mesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_VERTEX] = vertices
	tablas[Mesh.ARRAY_INDEX] = triangulos
	tablas[Mesh.ARRAY_NORMAL] = normales

	# Creación de la malla final
	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas)

	# Creación del material con sombreado por píxel
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.2, 0.6, 0.8)	
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
	material_override = mat
