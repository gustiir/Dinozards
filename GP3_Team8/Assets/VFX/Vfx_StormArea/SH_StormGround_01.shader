// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_StormGroundHuge_01"
{
	Properties
	{
		_Speed_Vertical("Speed_Vertical", Float) = 1.2
		_Speed_Horizontal("Speed_Horizontal", Float) = 1.2
		_ColorStart("ColorStart", Color) = (0.1529412,0.4352942,1,1)
		_ColorEnd("ColorEnd", Color) = (1,0,0.7529413,1)
		_Emission("Emission", Float) = 4
		_DarkEdge("DarkEdge", Range( 0.1 , 2)) = 1
		_Texture0("Texture 0", 2D) = "white" {}
		_Tile_Vertical("Tile_Vertical", Float) = 1
		_Tile_Horizontal("Tile_Horizontal", Float) = 1
		_FrontSide_Alpha("FrontSide_Alpha", Float) = 10
		_ColorLerp("ColorLerp", Float) = 1
		_OpacityFade("Opacity Fade", Float) = 1
		_Alphafade("Alpha fade", Range( 0 , 5)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
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
		uniform float _ColorLerp;
		uniform float _Emission;
		uniform sampler2D _Texture0;
		uniform float _Speed_Vertical;
		uniform float _Speed_Horizontal;
		uniform float _Tile_Horizontal;
		uniform float _Tile_Vertical;
		uniform float _FrontSide_Alpha;
		uniform float _DarkEdge;
		uniform float _OpacityFade;
		uniform float _Alphafade;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float V109 = i.uv_texcoord.y;
			float4 lerpResult78 = lerp( _ColorStart , _ColorEnd , ( V109 * _ColorLerp ));
			float mulTime97 = _Time.y * _Speed_Vertical;
			float Speed_Vertical98 = mulTime97;
			float mulTime120 = _Time.y * _Speed_Horizontal;
			float Speed_Horizontal121 = mulTime120;
			float4 appendResult116 = (float4(_Tile_Horizontal , _Tile_Vertical , 0.0 , 0.0));
			float2 panner122 = ( Speed_Horizontal121 * float2( -1,0 ) + ( float4( i.uv_texcoord, 0.0 , 0.0 ) * appendResult116 ).xy);
			float2 panner6 = ( Speed_Vertical98 * float2( 0,-1 ) + panner122);
			float2 temp_output_12_0 = (tex2D( _Texture0, panner6 )).rg;
			float2 UV5 = i.uv_texcoord;
			float2 panner41 = ( V109 * float2( 0,0 ) + UV5);
			float2 panner123 = ( Speed_Horizontal121 * float2( 0,-1 ) + panner41);
			float clampResult45 = clamp( ( ( ( 1.0 - V109 ) + 2.09 ) * 2.91 ) , -0.08 , 0.35 );
			float clampResult51 = clamp( ( ( tex2D( _Texture0, panner123 ).g + clampResult45 ) - ( V109 * 0.9 ) ) , 0.0 , 1.0 );
			float v100 = i.uv_texcoord.x;
			float clampResult62 = clamp( ( i.uv_texcoord.x * ( 1.0 - i.uv_texcoord.y ) * ( 1.0 - v100 ) * 6.0 ) , 0.0 , 1.0 );
			float EdgeMask65 = pow( ( clampResult62 * 1.0 ) , _FrontSide_Alpha );
			float temp_output_86_0 = ( tex2D( _Texture0, temp_output_12_0 ).r * i.vertexColor.a * clampResult51 * EdgeMask65 );
			float lerpResult91 = lerp( 0.0 , pow( temp_output_86_0 , 1.0 ) , _DarkEdge);
			o.Emission = ( ( lerpResult78 * i.vertexColor * _Emission ) * lerpResult91 ).rgb;
			float clampResult136 = clamp( ( V109 * _Alphafade ) , 0.0 , 1.0 );
			float lerpResult130 = lerp( ( temp_output_86_0 * _OpacityFade ) , ( 0.0 * 1.0 ) , clampResult136);
			o.Alpha = lerpResult130;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
-1913;1;1906;1010;1380.209;1403.009;1.3;True;False
Node;AmplifyShaderEditor.CommentaryNode;53;-3600.381,-535.0731;Float;False;948.8262;589.4223;Panner speeds;8;120;121;122;6;97;96;98;119;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;66;-3555.525,207.5119;Float;False;1581.657;596.0657;Edge Mask variable;8;60;58;64;62;100;99;102;126;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-4423.271,384.8155;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;118;-4333.284,-1151.07;Float;False;839.3276;575.0145;Tiling_Storm;5;111;112;113;116;114;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-3744.353,-235.912;Float;False;Property;_Speed_Horizontal;Speed_Horizontal;1;0;Create;True;0;0;False;0;1.2;-0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;100;-3324.324,461.9652;Float;True;v;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-4271.145,-691.0562;Float;False;Property;_Tile_Vertical;Tile_Vertical;8;0;Create;True;0;0;False;0;1;0.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-4283.284,-896.0629;Float;False;Property;_Tile_Horizontal;Tile_Horizontal;9;0;Create;True;0;0;False;0;1;0.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;52;-3149.442,-1512.485;Float;False;2104.735;765.6717;Dissolve Mask;13;44;37;45;49;50;42;41;38;39;40;43;123;124;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-3904.563,299.956;Float;True;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;120;-3439.055,-318.6734;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-4122.482,277.6026;Float;True;V;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-3095.7,-1275.174;Float;True;5;UV;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-3100.742,-1083.698;Float;True;109;V;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;116;-4012.19,-790.8627;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;113;-4067.489,-1101.07;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;38;-3094.143,-1462.485;Float;True;109;V;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-3090.957,688.5782;Float;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;False;0;6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;99;-3204.389,236.1704;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;102;-3016.147,461.8213;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-3584.696,-106.0187;Float;False;Property;_Speed_Vertical;Speed_Vertical;0;0;Create;True;0;0;False;0;1.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;121;-3346.713,-459.0378;Float;False;Speed_Horizontal;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;97;-3330.886,-104.2212;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-2822.572,379.1791;Float;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;41;-2743.629,-1219.693;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-3728.957,-955.408;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-2822.049,-1432.234;Float;True;121;Speed_Horizontal;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;43;-2819.644,-1043.495;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;98;-3080.655,-183.0524;Float;True;Speed_Vertical;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;62;-2593.417,380.9703;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;103;-2945.024,-732.1247;Float;True;Property;_Texture0;Texture 0;7;0;Create;True;0;0;False;0;9a5ad12aa4fa58142869ced59cf04267;9a5ad12aa4fa58142869ced59cf04267;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;123;-2530.851,-1329.643;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;44;-2540.884,-1000.87;Float;True;ConstantBiasScale;-1;;6;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT;0;False;1;FLOAT;2.09;False;2;FLOAT;2.91;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;122;-3097.16,-384.4878;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;37;-2329.994,-1240.821;Float;True;Property;_T_Dissolve_Mask;T_Dissolve_Mask;4;0;Create;True;0;0;False;0;9a5ad12aa4fa58142869ced59cf04267;9a5ad12aa4fa58142869ced59cf04267;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;126;-2427.035,706.6611;Float;False;Property;_FrontSide_Alpha;FrontSide_Alpha;10;0;Create;True;0;0;False;0;10;1.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-2436.875,381.8455;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;6;-2841.85,-377.1276;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;45;-2271.795,-999.814;Float;True;3;0;FLOAT;0;False;1;FLOAT;-0.08;False;2;FLOAT;0.35;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-1992.262,-1238.65;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-2533.875,-311.1372;Float;True;Property;_T_FlowMap_01;T_FlowMap_01;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-1990.555,-1456.471;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;125;-2120.887,489.297;Float;True;2;0;FLOAT;0;False;1;FLOAT;3.47;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;12;-2210.908,-422.0312;Float;True;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;87;-1002.956,-1768.58;Float;False;1021.698;681.3699;Color;8;81;83;78;75;76;80;79;127;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;50;-1661.688,-1308.711;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-1825.337,360.2564;Float;True;EdgeMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-970.1706,-1357.432;Float;True;109;V;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;105;-807.2709,-631.3834;Float;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;False;0;9a5ad12aa4fa58142869ced59cf04267;9a5ad12aa4fa58142869ced59cf04267;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;51;-797.8343,-872.3017;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-719.8362,-1241.609;Float;False;Property;_ColorLerp;ColorLerp;11;0;Create;True;0;0;False;0;1;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-705.5773,-424.7335;Float;True;65;EdgeMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;82;-526.6375,-1001.011;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;133;-157.6226,-99.11606;Float;True;Property;_Alphafade;Alpha fade;13;0;Create;True;0;0;False;0;0;1.19;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-194.8338,-671.3489;Float;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-614.3398,-1389.384;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-318.8363,-194.883;Float;False;109;V;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;75;-878.0366,-1722.051;Float;False;Property;_ColorStart;ColorStart;3;0;Create;True;0;0;False;0;0.1529412,0.4352942,1,1;0,1,0.9747474,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;76;-865.7031,-1546.673;Float;False;Property;_ColorEnd;ColorEnd;4;0;Create;True;0;0;False;0;1,0,0.7529413,1;1,0.08018869,0.9113927,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;128.1065,-381.1644;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;129;-152.2687,-374.0445;Float;False;Property;_OpacityFade;Opacity Fade;12;0;Create;True;0;0;False;0;1;1.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;78;-382.2385,-1569.509;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-484.3693,-1261.266;Float;False;Property;_Emission;Emission;5;0;Create;True;0;0;False;0;4;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-197.368,-1034.894;Float;False;Property;_DarkEdge;DarkEdge;6;0;Create;True;0;0;False;0;1;0.446;0.1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;106;-191.8303,-925.6785;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;156.2347,-745.694;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;136;394.9388,-465.1193;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-195.565,-1343.972;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;91;139.674,-1076.196;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;161.9388,-519.1193;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1641.598,-285.3098;Float;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;15;-1900.152,-384.6563;Float;True;ConstantBiasScale;-1;;7;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT2;0,0;False;1;FLOAT;-0.3;False;2;FLOAT;2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1872.009,-144.5114;Float;False;Property;_FlowStr;FlowStr;2;0;Create;True;0;0;False;0;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-1890.293,-57.84528;Float;True;109;V;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-1498.628,-395.1879;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;130;484.4975,-730.139;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-1496.246,-237.0845;Float;False;98;Speed_Vertical;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;33;-1286.353,-407.8117;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.8,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;407.0728,-1139.326;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-1847.396,-468.3968;Float;False;5;UV;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;138;-3194.629,-742.5007;Float;True;Property;_Texture1;Texture 1;15;0;Create;True;0;0;False;0;988176e9569d879499e5bca8457e90c7;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;3;754.4686,-960.2838;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;SH_StormGroundHuge_01;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;100;0;4;1
WireConnection;5;0;4;0
WireConnection;120;0;119;0
WireConnection;109;0;4;2
WireConnection;116;0;111;0
WireConnection;116;1;112;0
WireConnection;99;0;4;2
WireConnection;102;0;100;0
WireConnection;121;0;120;0
WireConnection;97;0;96;0
WireConnection;58;0;4;1
WireConnection;58;1;99;0
WireConnection;58;2;102;0
WireConnection;58;3;60;0
WireConnection;41;0;39;0
WireConnection;41;1;40;0
WireConnection;114;0;113;0
WireConnection;114;1;116;0
WireConnection;43;0;38;0
WireConnection;98;0;97;0
WireConnection;62;0;58;0
WireConnection;123;0;41;0
WireConnection;123;1;124;0
WireConnection;44;3;43;0
WireConnection;122;0;114;0
WireConnection;122;1;121;0
WireConnection;37;0;103;0
WireConnection;37;1;123;0
WireConnection;64;0;62;0
WireConnection;6;0;122;0
WireConnection;6;1;98;0
WireConnection;45;0;44;0
WireConnection;49;0;37;2
WireConnection;49;1;45;0
WireConnection;10;0;103;0
WireConnection;10;1;6;0
WireConnection;42;0;38;0
WireConnection;125;0;64;0
WireConnection;125;1;126;0
WireConnection;12;0;10;0
WireConnection;50;0;49;0
WireConnection;50;1;42;0
WireConnection;65;0;125;0
WireConnection;105;0;103;0
WireConnection;105;1;12;0
WireConnection;51;0;50;0
WireConnection;86;0;105;1
WireConnection;86;1;82;4
WireConnection;86;2;51;0
WireConnection;86;3;85;0
WireConnection;80;0;79;0
WireConnection;80;1;127;0
WireConnection;132;0;131;0
WireConnection;132;1;133;0
WireConnection;78;0;75;0
WireConnection;78;1;76;0
WireConnection;78;2;80;0
WireConnection;106;0;86;0
WireConnection;128;0;86;0
WireConnection;128;1;129;0
WireConnection;136;0;132;0
WireConnection;81;0;78;0
WireConnection;81;1;82;0
WireConnection;81;2;83;0
WireConnection;91;1;106;0
WireConnection;91;2;92;0
WireConnection;16;0;15;0
WireConnection;16;1;17;0
WireConnection;16;2;14;0
WireConnection;15;3;12;0
WireConnection;23;0;31;0
WireConnection;23;1;16;0
WireConnection;130;0;128;0
WireConnection;130;1;134;0
WireConnection;130;2;136;0
WireConnection;33;0;23;0
WireConnection;33;1;32;0
WireConnection;89;0;81;0
WireConnection;89;1;91;0
WireConnection;3;2;89;0
WireConnection;3;9;130;0
ASEEND*/
//CHKSM=3593B6FEE9C7233F1A815185FDA5C573AF59FBD7