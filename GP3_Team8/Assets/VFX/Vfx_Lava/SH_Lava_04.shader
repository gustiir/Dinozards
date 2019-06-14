// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Lava_04"
{
	Properties
	{
		_Fire_01("Fire_01", 2D) = "white" {}
		_Rock_Normal("Rock_Normal", 2D) = "white" {}
		_Brightness("Brightness", Float) = 1
		_ScaleXNormal("Scale X Normal", Float) = 1
		_ScaleYNormal("Scale Y Normal", Float) = 1
		_ScaleXLava("Scale X Lava", Float) = 1
		_ScaleYLava("Scale Y Lava", Float) = 1
		_Stylized_rock_roughness_004("Stylized_rock_roughness_004", 2D) = "white" {}
		_Stylized_rock_AO_004("Stylized_rock_AO_004", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Rock_Normal;
		uniform float _ScaleXNormal;
		uniform float _ScaleYNormal;
		uniform sampler2D _Fire_01;
		uniform float _ScaleXLava;
		uniform float _ScaleYLava;
		uniform float _Brightness;
		uniform sampler2D _Stylized_rock_roughness_004;
		uniform float4 _Stylized_rock_roughness_004_ST;
		uniform sampler2D _Stylized_rock_AO_004;
		uniform float4 _Stylized_rock_AO_004_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 appendResult23 = (float4(_ScaleXNormal , _ScaleYNormal , 0.0 , 0.0));
			float2 panner11 = ( 1.0 * _Time.y * float2( 0.01,0 ) + ( float4( i.uv_texcoord, 0.0 , 0.0 ) * appendResult23 ).xy);
			float4 tex2DNode4 = tex2D( _Rock_Normal, panner11 );
			o.Normal = tex2DNode4.rgb;
			float4 appendResult24 = (float4(_ScaleXLava , _ScaleYLava , 0.0 , 0.0));
			float2 panner12 = ( 1.0 * _Time.y * float2( -0.05,0 ) + ( float4( i.uv_texcoord, 0.0 , 0.0 ) * appendResult24 ).xy);
			float4 tex2DNode3 = tex2D( _Fire_01, panner12 );
			o.Albedo = tex2DNode3.rgb;
			float4 temp_output_14_0 = ( tex2DNode3 * _Brightness );
			o.Emission = temp_output_14_0.rgb;
			float2 uv_Stylized_rock_roughness_004 = i.uv_texcoord * _Stylized_rock_roughness_004_ST.xy + _Stylized_rock_roughness_004_ST.zw;
			o.Smoothness = ( 1.0 - tex2D( _Stylized_rock_roughness_004, uv_Stylized_rock_roughness_004 ) ).r;
			float2 uv_Stylized_rock_AO_004 = i.uv_texcoord * _Stylized_rock_AO_004_ST.xy + _Stylized_rock_AO_004_ST.zw;
			o.Occlusion = tex2D( _Stylized_rock_AO_004, uv_Stylized_rock_AO_004 ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
-1917;16;1906;1010;1635.423;335.9268;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;26;-2576.673,310.6115;Float;False;Property;_ScaleYLava;Scale Y Lava;8;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2564.976,166.3117;Float;False;Property;_ScaleXLava;Scale X Lava;6;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-2546.82,-328.4092;Float;False;Property;_ScaleXNormal;Scale X Normal;4;0;Create;True;0;0;False;0;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2548.918,-241.7097;Float;False;Property;_ScaleYNormal;Scale Y Normal;5;0;Create;True;0;0;False;0;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-2329.674,250.8116;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-2346.61,100.5184;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-2309.515,-427.4818;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;23;-2301.918,-301.5096;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1945.893,199.5178;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1941.291,-17.5824;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;12;-1691.669,232.7507;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.05,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;11;-1721.269,-28.54935;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.01,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1066.737,385.2742;Float;False;Property;_Brightness;Brightness;3;0;Create;True;0;0;False;0;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-1375.319,189.6458;Float;True;Property;_Fire_01;Fire_01;0;0;Create;True;0;0;False;0;297422662255f4a408461ee3fa6cd010;dad94e13cca70aa42ad2392a78d9afc1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;34;-401.2234,497.975;Float;True;Property;_Stylized_rock_roughness_004;Stylized_rock_roughness_004;11;0;Create;True;0;0;False;0;3a76012bd7bfbb042a0ff9d0222cf9b4;3a76012bd7bfbb042a0ff9d0222cf9b4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;-2564.877,645.111;Float;False;Property;_ScaleXMask;Scale X Mask;7;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;13;-1733.27,470.6506;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.02,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;31;-751.3369,-229.0348;Float;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;False;0;297422662255f4a408461ee3fa6cd010;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;19;-994.5748,506.3207;Float;True;3;0;FLOAT;1.8;False;1;FLOAT;0.1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-749.9249,97.48653;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;-2329.575,729.6109;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-163.3369,-295.0348;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2036.231,107.3107;Float;False;Constant;_Speed_LavaFlow;Speed_LavaFlow;10;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-2576.574,789.4108;Float;False;Property;_ScaleYMask;Scale Y Mask;9;0;Create;True;0;0;False;0;1;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-465.5526,193.8584;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;35;-82.73901,486.6428;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;4;-1382.894,-67.30347;Float;True;Property;_Rock_Normal;Rock_Normal;2;0;Create;True;0;0;False;0;b63a7142c55ee3345aec28dd20886ff8;b63a7142c55ee3345aec28dd20886ff8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-680.6862,323.2259;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-2330.228,582.3537;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-1388.797,440.7715;Float;True;Property;_Fire_02;Fire_02;1;0;Create;True;0;0;False;0;dad94e13cca70aa42ad2392a78d9afc1;dad94e13cca70aa42ad2392a78d9afc1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;36;-245.8413,218.8633;Float;True;Property;_Stylized_rock_AO_004;Stylized_rock_AO_004;12;0;Create;True;0;0;False;0;1c08b19c69cd3a54e90a0aac78b86e50;1c08b19c69cd3a54e90a0aac78b86e50;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-415.3369,-338.0348;Float;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1923.092,470.4185;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-328.4233,-47.92676;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;120.4305,-77.87124;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;SH_Lava_04;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;1;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;0;25;0
WireConnection;24;1;26;0
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;7;0;2;0
WireConnection;7;1;24;0
WireConnection;6;0;1;0
WireConnection;6;1;23;0
WireConnection;12;0;7;0
WireConnection;11;0;6;0
WireConnection;3;1;12;0
WireConnection;13;0;8;0
WireConnection;19;2;5;1
WireConnection;14;0;3;0
WireConnection;14;1;15;0
WireConnection;28;0;27;0
WireConnection;28;1;29;0
WireConnection;32;0;31;0
WireConnection;32;1;33;0
WireConnection;16;0;14;0
WireConnection;16;1;20;0
WireConnection;35;0;34;0
WireConnection;4;1;11;0
WireConnection;20;1;19;0
WireConnection;5;1;13;0
WireConnection;8;0;10;0
WireConnection;8;1;28;0
WireConnection;37;0;4;0
WireConnection;37;1;14;0
WireConnection;0;0;3;0
WireConnection;0;1;4;0
WireConnection;0;2;14;0
WireConnection;0;4;35;0
WireConnection;0;5;36;0
ASEEND*/
//CHKSM=09796862ED7363FA703303C8674C805BAA9A1FEF