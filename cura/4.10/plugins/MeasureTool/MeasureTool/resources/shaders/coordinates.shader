[shaders]
vertex =
    uniform highp mat4 u_modelMatrix;
    uniform highp mat4 u_viewMatrix;
    uniform highp mat4 u_projectionMatrix;

    attribute highp vec4 a_vertex;

    varying highp vec3 v_vertex;

    void main()
    {
        vec4 world_space_vert = u_modelMatrix * a_vertex;
        gl_Position = u_projectionMatrix * u_viewMatrix * world_space_vert;

        v_vertex = world_space_vert.xyz;
    }

fragment =
    uniform lowp int u_axisId;

    varying highp vec3 v_vertex;

    void main()
    {
        highp float coordinate = ((u_axisId == 0) ? v_vertex.x : (u_axisId == 1) ? v_vertex.y : v_vertex.z) * 1000.; // coordinate in micron
        coordinate += 8388608.; // offset coordinate to account for negative values (half of the coordinate-space: 128 * 256 * 256)

        highp vec3 encoded; // encode float into 3 8-bit channels; this gives a precision of a micron at a range of up to ~16 meter
        encoded.r = floor(coordinate / 65536.0);
        encoded.g = floor((coordinate - encoded.r * 65536.0) / 256.0);
        encoded.b = floor(coordinate - encoded.r * 65536.0 - encoded.g * 256.0);

        gl_FragColor.rgb = encoded / 255.;
        gl_FragColor.a = 1.0;
    }

vertex41core =
    #version 410
    uniform highp mat4 u_modelMatrix;
    uniform highp mat4 u_viewMatrix;
    uniform highp mat4 u_projectionMatrix;

    in highp vec4 a_vertex;

    out highp vec3 v_vertex;

    void main()
    {
        vec4 world_space_vert = u_modelMatrix * a_vertex;
        gl_Position = u_projectionMatrix * u_viewMatrix * world_space_vert;

        v_vertex = world_space_vert.xyz;
    }

fragment41core =
    #version 410
    uniform lowp int u_axisId;

    in highp vec3 v_vertex;

    out vec4 frag_color;

    void main()
    {
        highp float coordinate = ((u_axisId == 0) ? v_vertex.x : (u_axisId == 1) ? v_vertex.y : v_vertex.z) * 1000.; // coordinate in micron
        coordinate += 8388608.; // offset coordinate to account for negative values (half of the coordinate-space: 128 * 256 * 256)

        highp vec3 encoded; // encode float into 3 8-bit channels; this gives a precision of a micron at a range of up to ~16 meter
        encoded.r = floor(coordinate / 65536.0);
        encoded.g = floor((coordinate - encoded.r * 65536.0) / 256.0);
        encoded.b = floor(coordinate - encoded.r * 65536.0 - encoded.g * 256.0);

        frag_color.rgb = encoded / 255.;
        frag_color.a = 1.0;
    }

[defaults]

[bindings]
u_modelMatrix = model_matrix
u_viewMatrix = view_matrix
u_projectionMatrix = projection_matrix
u_normalMatrix = normal_matrix
u_viewPosition = view_position

[attributes]
a_vertex = vertex
