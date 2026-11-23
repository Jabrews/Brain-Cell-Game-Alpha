shader_type spatial;
render_mode unshaded, cull_disabled;

void vertex() {
	// make object face camera
	mat3 cam_basis = mat3(INV_VIEW_MATRIX);

	vec3 right = cam_basis[0];
	vec3 up = cam_basis[1];

	vec3 local = VERTEX;

	VERTEX = (right * local.x) + (up * local.y);
}
