// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_SlashReflect_02"
{
	Properties
	{
		_Speed("Speed", Float) = 1.2
		_FlowStr("FlowStr", Float) = 0.3
		_ColorStart("ColorStart", Color) = (0.1529412,0.4352942,1,1)
		_ColorEnd("ColorEnd", Color) = (1,0,0.7529413,1)
		_Emission("Emission", Float) = 4
		_DarkEdge("DarkEdge", Range( 0.1 , 2)) = 1
		_Texture0("Texture 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _ColorStart;
		uniform float4 _ColorEnd;
		uniform float _Emission;
		uniform sampler2D _Texture0;
		uniform float _Speed;
		uniform float _FlowStr;
		uniform float _DarkEdge;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float U100 = i.uv_texcoord.x;
			float4 lerpResult78 = lerp( _ColorStart , _ColorEnd , ( U100 * 1.0 ));
			float mulTime97 = _Time.y * _Speed;
			float Time98 = mulTime97;
			float2 UV5 = i.uv_texcoord;
			float2 panner6 = ( Time98 * float2( -1,0 ) + UV5);
			float2 panner33 = ( Time98 * float2( -0.8,0 ) + ( UV5 + ( ( ( (tex2D( _Texture0, panner6 )).rg + -0.3 ) * 2.0 ) * _FlowStr * U100 ) ));
			float2 panner41 = ( Time98 * float2( -1,-0.2 ) + UV5);
			float clampResult45 = clamp( ( ( ( 1.0 - U100 ) + -0.55 ) * 2.0 ) , 0.25 , 0.75 );
			float clampResult51 = clamp( ( ( tex2D( _Texture0, panner41 ).g + clampResult45 ) - ( U100 * 0.9 ) ) , 0.0 , 1.0 );
			float clampResult62 = clamp( ( i.uv_texcoord.y * ( 1.0 - i.uv_texcoord.y ) * ( 1.0 - U100 ) * 6.0 ) , 0.0 , 1.0 );
			float EdgeMask65 = ( clampResult62 * 1.0 );
			float temp_output_86_0 = ( tex2D( _Texture0, panner33 ).b * clampResult51 * EdgeMask65 * i.vertexColor.a );
			float lerpResult91 = lerp( 0.0 , pow( temp_output_86_0 , 2.0 ) , _DarkEdge);
			o.Emission = ( ( lerpResult78 * i.vertexColor * _Emission ) * lerpResult91 ).rgb;
			o.Alpha = temp_output_86_0;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
-1876;4;1906;1004;1998.122;1408.711;1.81;True;False
Node;AmplifyShaderEditor.CommentaryNode;53;-3600.381,-535.0731;Float;False;2608.763;589.4222;Flow Map for Trail;16;33;32;23;16;31;17;14;15;12;10;6;5;4;96;97;98;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-3586.308,-106.0187;Float;False;Property;_Speed;Speed;0;0;Create;True;0;0;False;0;1.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;97;-3422.744,-101.5967;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-3410.159,-314.9053;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;98;-3045.382,-67.07333;Float;False;Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-3115.785,-310.3921;Float;True;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;66;-3599.969,130.8449;Float;False;1581.657;596.0657;Edge Mask variable;8;60;58;64;65;62;100;99;102;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;52;-3149.442,-1512.485;Float;False;2104.735;765.6717;Dissolve Mask;11;44;37;45;49;50;42;41;38;39;40;43;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;6;-2775.107,-229.915;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;100;-3286.792,376.5545;Float;False;U;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;103;-2945.024,-732.1247;Float;True;Property;_Texture0;Texture 0;6;0;Create;True;0;0;False;0;9a5ad12aa4fa58142869ced59cf04267;9a5ad12aa4fa58142869ced59cf04267;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;10;-2550.489,-318.2573;Float;True;Property;_T_FlowMap_01;T_FlowMap_01;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;38;-3094.143,-1462.485;Float;True;100;U;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;102;-3060.591,385.1543;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-3100.742,-1083.698;Float;True;98;Time;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;43;-2819.644,-1043.495;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;99;-3130.79,244.7542;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;12;-2210.908,-422.0312;Float;True;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-3135.401,611.9108;Float;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;False;0;6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-3095.7,-1275.174;Float;True;5;UV;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;44;-2540.884,-1000.87;Float;True;ConstantBiasScale;-1;;4;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT;0;False;1;FLOAT;-0.55;False;2;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;15;-1900.152,-384.6563;Float;True;ConstantBiasScale;-1;;5;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT2;0,0;False;1;FLOAT;-0.3;False;2;FLOAT;2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1872.009,-144.5114;Float;False;Property;_FlowStr;FlowStr;1;0;Create;True;0;0;False;0;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-1890.293,-57.84528;Float;False;100;U;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;41;-2741.029,-1219.693;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-1,-0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-2867.016,302.5121;Float;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;62;-2637.861,304.3033;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1641.598,-285.3098;Float;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;37;-2522.756,-1243.498;Float;True;Property;_T_Dissolve_Mask;T_Dissolve_Mask;4;0;Create;True;0;0;False;0;9a5ad12aa4fa58142869ced59cf04267;9a5ad12aa4fa58142869ced59cf04267;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;45;-2271.795,-999.814;Float;True;3;0;FLOAT;0;False;1;FLOAT;0.25;False;2;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-1847.396,-468.3968;Float;False;5;UV;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-2481.319,305.1785;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-1990.555,-1456.471;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-1496.246,-237.0845;Float;False;98;Time;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-1498.628,-395.1879;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-1992.262,-1238.65;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;33;-1286.353,-407.8117;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.8,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;87;-1002.956,-1768.58;Float;False;1021.698;681.3699;Color;7;81;83;78;75;76;80;79;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-2243.117,302.4784;Float;True;EdgeMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;50;-1661.688,-1308.711;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;105;-807.2709,-631.3834;Float;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;False;0;9a5ad12aa4fa58142869ced59cf04267;9a5ad12aa4fa58142869ced59cf04267;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;85;-705.5773,-424.7335;Float;True;65;EdgeMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-970.1706,-1357.432;Float;True;100;U;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;51;-804.5091,-884.3166;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;82;-526.6375,-1001.011;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-779.4306,-1355.913;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;75;-897.1274,-1718.58;Float;False;Property;_ColorStart;ColorStart;2;0;Create;True;0;0;False;0;0.1529412,0.4352942,1,1;0.1529412,0.4352942,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-372.5486,-692.0536;Float;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;76;-884.7939,-1543.202;Float;False;Property;_ColorEnd;ColorEnd;3;0;Create;True;0;0;False;0;1,0,0.7529413,1;1,0,0.7529413,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;106;-191.8303,-925.6785;Float;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;78;-510.3292,-1520.038;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-197.368,-1034.894;Float;False;Property;_DarkEdge;DarkEdge;5;0;Create;True;0;0;False;0;1;1;0.1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-557.7554,-1277.1;Float;False;Property;_Emission;Emission;4;0;Create;True;0;0;False;0;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;91;139.674,-1076.196;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-214.6557,-1340.501;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;108;-284.3301,-177.8257;Float;True;Property;_T_ReflectGradient_01;T_ReflectGradient_01;8;0;Create;True;0;0;False;0;147071ae69e0cd34eb74ad0e83638049;147071ae69e0cd34eb74ad0e83638049;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;407.0728,-1139.326;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;107;-733.3301,-236.8257;Float;True;Property;_T_ReflectGradient_03;T_ReflectGradient_03;7;0;Create;True;0;0;False;0;dc6a0c4ad235ac248a80d46e21638e85;dc6a0c4ad235ac248a80d46e21638e85;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;3;754.4686,-960.2838;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;SH_SlashReflect_02;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;97;0;96;0
WireConnection;98;0;97;0
WireConnection;5;0;4;0
WireConnection;6;0;5;0
WireConnection;6;1;98;0
WireConnection;100;0;4;1
WireConnection;10;0;103;0
WireConnection;10;1;6;0
WireConnection;102;0;100;0
WireConnection;43;0;38;0
WireConnection;99;0;4;2
WireConnection;12;0;10;0
WireConnection;44;3;43;0
WireConnection;15;3;12;0
WireConnection;41;0;39;0
WireConnection;41;1;40;0
WireConnection;58;0;4;2
WireConnection;58;1;99;0
WireConnection;58;2;102;0
WireConnection;58;3;60;0
WireConnection;62;0;58;0
WireConnection;16;0;15;0
WireConnection;16;1;17;0
WireConnection;16;2;14;0
WireConnection;37;0;103;0
WireConnection;37;1;41;0
WireConnection;45;0;44;0
WireConnection;64;0;62;0
WireConnection;42;0;38;0
WireConnection;23;0;31;0
WireConnection;23;1;16;0
WireConnection;49;0;37;2
WireConnection;49;1;45;0
WireConnection;33;0;23;0
WireConnection;33;1;32;0
WireConnection;65;0;64;0
WireConnection;50;0;49;0
WireConnection;50;1;42;0
WireConnection;105;0;103;0
WireConnection;105;1;33;0
WireConnection;51;0;50;0
WireConnection;80;0;79;0
WireConnection;86;0;105;3
WireConnection;86;1;51;0
WireConnection;86;2;85;0
WireConnection;86;3;82;4
WireConnection;106;0;86;0
WireConnection;78;0;75;0
WireConnection;78;1;76;0
WireConnection;78;2;80;0
WireConnection;91;1;106;0
WireConnection;91;2;92;0
WireConnection;81;0;78;0
WireConnection;81;1;82;0
WireConnection;81;2;83;0
WireConnection;89;0;81;0
WireConnection;89;1;91;0
WireConnection;3;2;89;0
WireConnection;3;9;86;0
ASEEND*/
//CHKSM=030402D74CD11433BF90FDFC5F2E3EE38ED90766