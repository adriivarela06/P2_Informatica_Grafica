extends Node

func generarRevolucion(perfil: PackedVector2Array, copias: int, vertices: PackedVector3Array, triangulos: PackedInt32Array) -> void:
	# Generacion de los vertices rotados
	for i in range(copias):
		var angulo = (2.0 * PI / copias) * i
		var cos_a = cos(angulo)
		var sin_a = sin(angulo)

		for punto in perfil:
			var x_rotado = punto.x * cos_a
			var z_rotado = punto.x * sin_a
			vertices.append(Vector3(x_rotado, punto.y, z_rotado))

	var puntos_perfil = perfil.size()
	
	for s in range(copias):
		for p in range(puntos_perfil - 1):
			var actual = (s * puntos_perfil) + p
			var siguiente = actual + 1
			var indice_col_derecha = (s + 1) % copias
			var columna_derecha = (indice_col_derecha * puntos_perfil) + p
			var columna_derecha_siguiente = columna_derecha + 1

			# Esta parte del codigo hace que no se repitan los vertices de rotacion
			# y que no se dibuje ningun triangulo degenerado
			if perfil[p].x == 0.0:
				actual = p
				columna_derecha = p
				
			if perfil[p + 1].x == 0.0:
				siguiente = p + 1
				columna_derecha_siguiente = p + 1

			if perfil[p].x != 0.0:
				triangulos.append_array([actual, columna_derecha, siguiente])
				
			if perfil[p + 1].x != 0.0:
				triangulos.append_array([siguiente, columna_derecha, columna_derecha_siguiente])
