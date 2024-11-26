shader_type spatial;

void vertex() {

}

void fragment() {
	vec3 color;
	METALLIC = 60.0 + sin(TIME);
	color.r = tan(TIME);
	color.b = 6.0+tan(TIME);
	color.g = cos(TIME);
	ALBEDO = color;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
