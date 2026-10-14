extends MeshInstance3D

func _ready() -> void:
	var vertices := PackedVector3Array()
	var triangulos := PackedInt32Array()
	var v_idx := 0

	# Definimos las 6 direcciones (normales) a las que miran las caras del cubo
	var caras = [
		Vector3(0, 0, 1), Vector3(0, 0, -1), # Frontal, Trasera
		Vector3(-1, 0, 0), Vector3(1, 0, 0), # Izquierda, Derecha
		Vector3(0, 1, 0), Vector3(0, -1, 0)  # Superior, Inferior
	]

	# Generación de los 24 vértices y sus triángulos
	for dir in caras:
		# Calculamos dos vectores perpendiculares a la dirección de la cara
		var eje_x = Vector3(dir.y, dir.z, dir.x) 
		var eje_y = dir.cross(eje_x)
		
		# Generamos las 4 esquinas de la cara actual a distancia 0.5 del centro
		vertices.append(dir * 0.5 - eje_x * 0.5 - eje_y * 0.5)
		vertices.append(dir * 0.5 + eje_x * 0.5 - eje_y * 0.5)
		vertices.append(dir * 0.5 + eje_x * 0.5 + eje_y * 0.5)
		vertices.append(dir * 0.5 - eje_x * 0.5 + eje_y * 0.5)
		
		# Formamos los dos triángulos de esta cara (sentido antihorario)
		triangulos.append_array([v_idx, v_idx+2, v_idx+1, v_idx, v_idx+3, v_idx+2])
		v_idx += 4 # Sumamos 4 al índice para la siguiente cara

	# Cálculo de normales
	var normales := Utilidades.calcNormales(vertices, triangulos)

	# Empaquetado de datos en las tablas
	var tablas : Array = []
	tablas.resize(Mesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_VERTEX] = vertices
	tablas[Mesh.ARRAY_INDEX] = triangulos
	tablas[Mesh.ARRAY_NORMAL] = normales

	# Creación de la malla final
	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas)

	# Creación y asignación del material con sombreado por píxel
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.3, 0.8, 0.7)
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
	material_override = mat
