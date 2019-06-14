// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Fireball_01"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.16
		_NoiseTexture_Ucoord("NoiseTexture_Ucoord", Float) = 0.2
		_NoiseTexture_Vcoord("NoiseTexture_Vcoord", Float) = 0.2
		_Noise_Speed("Noise_Speed", Float) = 1
		_Noise_Intensity("Noise_Intensity", Float) = 1
		_CloudNoise01("CloudNoise01", 2D) = "white" {}
		_CloudNoise02("CloudNoise02", 2D) = "black" {}
		_Trail_U_Scale("Trail_U_Scale", Float) = 1
		_Trail_V_Scale("Trail_V_Scale", Float) = 1
		_Trail_U_Move("Trail_U_Move", Float) = 0
		_Trail_V_Move("Trail_V_Move", Float) = 0
		[ToggleOff(_NOISE_USE_OFF)] _Noise_Use("Noise_Use", Float) = 1
		_UpLine_V_Move("UpLine_V_Move", Float) = 0
		_UpLine_U_Scale("UpLine_U_Scale", Float) = 1
		_UpLine_V_Scale("UpLine_V_Scale", Float) = 1
		_UpLine_U_Move("UpLine_U_Move", Float) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_UpLine_Trail_Color("UpLine_Trail_Color", Color) = (1,1,1,1)
		[ToggleOff(_UPLINE_TRAIL_USE_OFF)] _UpLine_Trail_Use("UpLine_Trail_Use", Float) = 1
		_ParticleColor("Particle Color", Color) = (1,1,1,1)
		_Trail_Tex_Intensity("Trail_Tex_Intensity", Float) = 1
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_Alpha_Intensity("Alpha_Intensity", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _UPLINE_TRAIL_USE_OFF
		#pragma shader_feature _NOISE_USE_OFF
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _TextureSample1;
		uniform float _UpLine_U_Scale;
		uniform float _UpLine_V_Scale;
		uniform float _UpLine_U_Move;
		uniform float _UpLine_V_Move;
		uniform sampler2D _CloudNoise01;
		uniform float _Noise_Speed;
		uniform float _NoiseTexture_Ucoord;
		uniform float _NoiseTexture_Vcoord;
		uniform sampler2D _CloudNoise02;
		uniform float _Noise_Intensity;
		uniform float4 _UpLine_Trail_Color;
		uniform sampler2D _TextureSample0;
		uniform float _Trail_U_Scale;
		uniform float _Trail_V_Scale;
		uniform float _Trail_U_Move;
		uniform float _Trail_V_Move;
		uniform float _Trail_Tex_Intensity;
		uniform float4 _ParticleColor;
		uniform sampler2D _TextureSample2;
		uniform float4 _TextureSample2_ST;
		uniform float _Alpha_Intensity;
		uniform float _Cutoff = 0.16;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 appendResult74 = (float4(_UpLine_U_Scale , _UpLine_V_Scale , 0.0 , 0.0));
			float4 appendResult76 = (float4(_UpLine_U_Move , _UpLine_V_Move , 0.0 , 0.0));
			float4 temp_output_77_0 = ( ( float4( i.uv_texcoord, 0.0 , 0.0 ) * appendResult74 ) + appendResult76 );
			float mulTime28 = _Time.y * _Noise_Speed;
			float4 appendResult22 = (float4(_NoiseTexture_Ucoord , _NoiseTexture_Vcoord , 0.0 , 0.0));
			float4 temp_output_32_0 = ( float4( i.uv_texcoord, 0.0 , 0.0 ) * appendResult22 );
			float2 panner25 = ( mulTime28 * float2( -0.1,0.01 ) + temp_output_32_0.xy);
			float2 panner26 = ( mulTime28 * float2( -0.05,0.02 ) + temp_output_32_0.xy);
			float temp_output_44_0 = ( ( tex2D( _CloudNoise01, panner25 ).r + tex2D( _CloudNoise02, panner26 ).b ) * _Noise_Intensity );
			float4 temp_output_78_0 = ( temp_output_77_0 + temp_output_44_0 );
			float4 temp_output_85_0 = ( ( tex2D( _TextureSample1, ( temp_output_77_0 * temp_output_78_0 ).xy ).r * _UpLine_Trail_Color ) * i.vertexColor );
			float4 temp_cast_7 = (0.0).xxxx;
			#ifdef _UPLINE_TRAIL_USE_OFF
				float4 staticSwitch88 = temp_output_85_0;
			#else
				float4 staticSwitch88 = temp_cast_7;
			#endif
			float4 color93 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
			float4 appendResult53 = (float4(_Trail_U_Scale , _Trail_V_Scale , 0.0 , 0.0));
			float4 appendResult60 = (float4(_Trail_U_Move , _Trail_V_Move , 0.0 , 0.0));
			float4 temp_output_63_0 = ( ( float4( i.uv_texcoord, 0.0 , 0.0 ) * appendResult53 ) + appendResult60 );
			#ifdef _NOISE_USE_OFF
				float4 staticSwitch65 = ( temp_output_44_0 + temp_output_63_0 );
			#else
				float4 staticSwitch65 = temp_output_63_0;
			#endif
			float4 tex2DNode67 = tex2D( _TextureSample0, staticSwitch65.xy );
			o.Emission = ( temp_output_85_0 * ( staticSwitch88 + ( ( ( color93 * tex2DNode67.r ) * _Trail_Tex_Intensity ) * _ParticleColor ) ) ).rgb;
			o.Alpha = 1;
			float2 uv_TextureSample2 = i.uv_texcoord * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
			clip( ( _ParticleColor.a * ( ( ( staticSwitch88 + tex2DNode67.r ) * tex2D( _TextureSample2, uv_TextureSample2 ).r ) * _Alpha_Intensity ) ).r - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
-1913;7;1906;1004;2864.904;889.5906;1.647095;True;False
Node;AmplifyShaderEditor.CommentaryNode;27;-4318.849,-66.24837;Float;False;1878.558;770.3545;Comment;14;19;28;31;22;20;17;39;42;44;38;36;25;26;32;Cloud Noise Panners;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-4292.893,166.5226;Float;False;Property;_NoiseTexture_Ucoord;NoiseTexture_Ucoord;1;0;Create;True;0;0;False;0;0.2;1.86;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-4292.226,276.8281;Float;False;Property;_NoiseTexture_Vcoord;NoiseTexture_Vcoord;2;0;Create;True;0;0;False;0;0.2;3.98;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-4076.148,445.6773;Float;False;Property;_Noise_Speed;Noise_Speed;3;0;Create;True;0;0;False;0;1;-13.79;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-4145.975,9.480856;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;22;-3994.338,149.757;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;28;-3880.638,444.3344;Float;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;81;-3541.046,-814.3665;Float;False;1720.5;642.0871;Comment;13;69;70;76;72;73;75;74;71;78;77;79;80;106;Small flashy line "Upline";1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-3821.231,115.1198;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;26;-3519.381,420.6506;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.05,0.02;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-3491.046,-709.9418;Float;False;Property;_UpLine_U_Scale;UpLine_U_Scale;13;0;Create;True;0;0;False;0;1;0.59;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;25;-3528.162,162.4655;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.1,0.01;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-3457.168,-546.0328;Float;False;Property;_UpLine_V_Scale;UpLine_V_Scale;14;0;Create;True;0;0;False;0;1;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-3291.757,-304.6124;Float;False;Property;_UpLine_V_Move;UpLine_V_Move;12;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;39;-3339.405,132.9175;Float;True;Property;_CloudNoise01;CloudNoise01;5;0;Create;True;0;0;False;0;1f649a906aa594c4b813d3675fdc149f;1f649a906aa594c4b813d3675fdc149f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;42;-3333.045,388.2623;Float;True;Property;_CloudNoise02;CloudNoise02;6;0;Create;True;0;0;False;0;1f649a906aa594c4b813d3675fdc149f;1f649a906aa594c4b813d3675fdc149f;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;74;-3235.36,-602.3521;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;71;-3288.528,-764.3665;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;72;-3306.617,-441.8094;Float;False;Property;_UpLine_U_Move;UpLine_U_Move;15;0;Create;True;0;0;False;0;0;-0.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;68;-3367.558,817.8611;Float;False;1674.521;781.4363;Comment;14;53;62;52;63;64;67;60;55;54;65;57;58;110;111;Trail noise with crackling noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-3317.558,1215.197;Float;False;Property;_Trail_V_Scale;Trail_V_Scale;8;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-3083.205,592.2128;Float;False;Property;_Noise_Intensity;Noise_Intensity;4;0;Create;True;0;0;False;0;1;1.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-3020.564,-592.2737;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-2998.697,296.0045;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-3312.558,1023.197;Float;False;Property;_Trail_U_Scale;Trail_U_Scale;7;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;76;-3036.315,-446.1803;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-3083.167,1392.382;Float;False;Property;_Trail_V_Move;Trail_V_Move;10;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;52;-3140.443,867.8611;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;53;-3069.558,1073.197;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-2855.894,326.6209;Float;True;2;2;0;FLOAT;0.2;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;77;-2856.833,-533.3814;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-3079.057,1280.298;Float;False;Property;_Trail_U_Move;Trail_U_Move;9;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;60;-2836.557,1312.197;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-2636.339,-425.2794;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-2850.557,1038.197;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-2383.649,-537.6672;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-2687.495,1088.691;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;92;-1742.884,-568.5074;Float;False;1011.463;401.3291;Comment;6;83;84;85;86;87;88;Intensity "Emissive" slider for Upline;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;80;-2146.546,-542.241;Float;True;Property;_TextureSample1;Texture Sample 1;17;0;Create;True;0;0;False;0;db1dfc3f73c87b645a0a231d3df3248b;db1dfc3f73c87b645a0a231d3df3248b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;83;-1692.884,-398.1456;Float;False;Property;_UpLine_Trail_Color;UpLine_Trail_Color;18;0;Create;True;0;0;False;0;1,1,1,1;1,0,0.8550725,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;64;-2500.61,882.6147;Float;True;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;97;-1917.199,-26.06642;Float;False;804.1453;480.8;Comment;4;94;96;95;93;;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;117;-1528.565,-176.3774;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;65;-2280.912,1072.986;Float;False;Property;_Noise_Use;Noise_Use;11;0;Create;True;0;0;False;0;0;1;0;True;;ToggleOff;2;Key0;Key1;Create;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-1448.915,-517.7075;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;93;-1872.443,41.41823;Float;False;Constant;_Color0;Color 0;23;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;87;-1202.421,-282.1786;Float;False;Constant;_Float0;Float 0;21;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-1289.813,-555.5076;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;67;-2026.035,1049.261;Float;True;Property;_TextureSample0;Texture Sample 0;16;0;Create;True;0;0;False;0;6f17e8468f1c83e47bca5fe95d151018;6f17e8468f1c83e47bca5fe95d151018;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-1569.288,72.63319;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-1592.58,340.185;Float;False;Property;_Trail_Tex_Intensity;Trail_Tex_Intensity;22;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;115;-888.2494,370.1615;Float;False;358.5482;441.8858;Vertex Color;2;114;91;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;104;-1242.734,881.863;Float;False;906.2678;429.7256;Comment;6;100;98;101;99;103;102;Gradient Added to Smooth effects;1,1,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;88;-1034.421,-460.1785;Float;False;Property;_UpLine_Trail_Use;UpLine_Trail_Use;20;0;Create;True;0;0;False;0;0;1;0;True;;ToggleOff;2;Key0;Key1;Create;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;98;-1192.734,1060.411;Float;True;Property;_TextureSample2;Texture Sample 2;23;0;Create;True;0;0;False;0;bca9821de3818b2438d8118658fced30;bca9821de3818b2438d8118658fced30;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-1302.784,179.7092;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;99;-1069.618,932.2595;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;91;-838.2494,605.0472;Float;False;Property;_ParticleColor;Particle Color;21;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-474.556,99.26563;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-910.1042,1215.464;Float;False;Property;_Alpha_Intensity;Alpha_Intensity;24;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-911.6661,920.1853;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-706.5826,1083.365;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;89;-555.7117,-234.1397;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-2332.764,1367.456;Float;False;Property;_Float1;Float 1;26;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;108;-2401.56,-978.9817;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-1135.971,-706.084;Float;False;Property;_Float3;Float 3;27;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;114;-732.7012,420.1615;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;110;-2254.874,945.587;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;79;-2468.543,-846.7363;Float;True;Property;_Noise_Use;Noise_Use;17;0;Create;True;0;0;False;0;0;0;0;True;;ToggleOff;2;Key0;Key1;Create;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;109;-947.0851,-703.2854;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-277.604,-532.7322;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-2607.403,-926.9114;Float;False;Property;_Float2;Float 2;25;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-539.4852,927.5879;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-1482.522,-265.9787;Float;False;Property;_Upline_G_Intensity;Upline_G_Intensity;19;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;46;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;SH_Fireball_01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.16;True;False;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;22;0;20;0
WireConnection;22;1;31;0
WireConnection;28;0;19;0
WireConnection;32;0;17;0
WireConnection;32;1;22;0
WireConnection;26;0;32;0
WireConnection;26;1;28;0
WireConnection;25;0;32;0
WireConnection;25;1;28;0
WireConnection;39;1;25;0
WireConnection;42;1;26;0
WireConnection;74;0;69;0
WireConnection;74;1;70;0
WireConnection;75;0;71;0
WireConnection;75;1;74;0
WireConnection;36;0;39;1
WireConnection;36;1;42;3
WireConnection;76;0;72;0
WireConnection;76;1;73;0
WireConnection;53;0;54;0
WireConnection;53;1;55;0
WireConnection;44;0;36;0
WireConnection;44;1;38;0
WireConnection;77;0;75;0
WireConnection;77;1;76;0
WireConnection;60;0;57;0
WireConnection;60;1;58;0
WireConnection;78;0;77;0
WireConnection;78;1;44;0
WireConnection;62;0;52;0
WireConnection;62;1;53;0
WireConnection;106;0;77;0
WireConnection;106;1;78;0
WireConnection;63;0;62;0
WireConnection;63;1;60;0
WireConnection;80;1;106;0
WireConnection;64;0;44;0
WireConnection;64;1;63;0
WireConnection;65;1;63;0
WireConnection;65;0;64;0
WireConnection;84;0;80;1
WireConnection;84;1;83;0
WireConnection;85;0;84;0
WireConnection;85;1;117;0
WireConnection;67;1;65;0
WireConnection;94;0;93;0
WireConnection;94;1;67;1
WireConnection;88;1;87;0
WireConnection;88;0;85;0
WireConnection;96;0;94;0
WireConnection;96;1;95;0
WireConnection;99;0;88;0
WireConnection;99;1;67;1
WireConnection;90;0;96;0
WireConnection;90;1;91;0
WireConnection;100;0;99;0
WireConnection;100;1;98;1
WireConnection;101;0;100;0
WireConnection;101;1;102;0
WireConnection;89;0;88;0
WireConnection;89;1;90;0
WireConnection;79;1;77;0
WireConnection;79;0;78;0
WireConnection;107;0;85;0
WireConnection;107;1;89;0
WireConnection;103;0;91;4
WireConnection;103;1;101;0
WireConnection;46;2;107;0
WireConnection;46;10;103;0
ASEEND*/
//CHKSM=5405CD9AB9E415ACCC7DDBDE96D2E5E1359D32D3