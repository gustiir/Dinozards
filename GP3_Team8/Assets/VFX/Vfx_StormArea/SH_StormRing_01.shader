// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_StormRing_01"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Speed_Vertical("Speed_Vertical", Float) = 1.2
		_Speed_Horizontal("Speed_Horizontal", Float) = 1.2
		_ColorEnd("ColorEnd", Color) = (1,0,0.7529413,1)
		_Emission("Emission", Float) = 4
		_DarkEdge("DarkEdge", Range( 0.1 , 2)) = 0.83
		_Texture0("Texture 0", 2D) = "white" {}
		_Tile_Vertical("Tile_Vertical", Float) = 1
		_Tile_Horizontal("Tile_Horizontal", Float) = 1
		_FrontSide_Alpha("FrontSide_Alpha", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend One One , One One
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
		};

		uniform float4 _ColorEnd;
		uniform float _Emission;
		uniform sampler2D _Texture0;
		uniform float _Speed_Horizontal;
		uniform float _Speed_Vertical;
		uniform float _Tile_Horizontal;
		uniform float _Tile_Vertical;
		uniform float _FrontSide_Alpha;
		uniform float _DarkEdge;
		uniform float _Cutoff = 0.5;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime120 = _Time.y * _Speed_Horizontal;
			float Speed_Horizontal121 = mulTime120;
			float mulTime97 = _Time.y * _Speed_Vertical;
			float Speed_Vertical98 = mulTime97;
			float2 UV5 = i.uv_texcoord;
			float2 panner41 = ( Speed_Vertical98 * float2( -0.1,-1 ) + UV5);
			float2 panner123 = ( Speed_Horizontal121 * float2( 0,0 ) + panner41);
			float V109 = i.uv_texcoord.y;
			float clampResult45 = clamp( ( ( ( 1.0 - V109 ) + -0.66 ) * 1.26 ) , -0.08 , 0.35 );
			float clampResult51 = clamp( ( ( tex2D( _Texture0, panner123 ).g + clampResult45 ) - ( V109 * 0.9 ) ) , 0.0 , 1.0 );
			float4 appendResult116 = (float4(_Tile_Horizontal , _Tile_Vertical , 0.0 , 0.0));
			float2 panner122 = ( Speed_Horizontal121 * float2( -1,0 ) + ( float4( i.uv_texcoord, 0.0 , 0.0 ) * appendResult116 ).xy);
			float2 panner6 = ( Speed_Vertical98 * float2( 0,-1 ) + panner122);
			float2 temp_output_12_0 = (tex2D( _Texture0, panner6 )).rg;
			float v100 = i.uv_texcoord.x;
			float clampResult62 = clamp( ( i.uv_texcoord.x * ( 1.0 - i.uv_texcoord.y ) * ( 1.0 - v100 ) * 6.0 ) , 0.0 , 1.0 );
			float EdgeMask65 = pow( ( clampResult62 * 1.0 ) , _FrontSide_Alpha );
			float temp_output_86_0 = ( clampResult51 * i.vertexColor.a * tex2D( _Texture0, temp_output_12_0 ).r * EdgeMask65 );
			float lerpResult91 = lerp( 0.0 , pow( temp_output_86_0 , 2.0 ) , _DarkEdge);
			o.Emission = ( ( _ColorEnd * i.vertexColor * _Emission ) * lerpResult91 ).rgb;
			float clampResult145 = clamp( temp_output_86_0 , 0.0 , 1.0 );
			o.Alpha = clampResult145;
			clip( clampResult145 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.vertexColor = IN.color;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
-1954;30;1918;1016;863.3506;1362.602;1.34183;True;False
Node;AmplifyShaderEditor.CommentaryNode;53;-3600.381,-535.0731;Float;False;948.8262;589.4223;Panner speeds;8;120;121;122;6;97;96;98;119;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-3584.696,-106.0187;Float;False;Property;_Speed_Vertical;Speed_Vertical;0;0;Create;True;0;0;False;0;1.2;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;66;-3555.525,207.5119;Float;False;1581.657;596.0657;Edge Mask variable;8;60;58;64;62;100;99;102;126;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;118;-4333.284,-1151.07;Float;False;839.3276;575.0145;Tiling_Storm;5;111;112;113;116;114;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-4423.271,384.8155;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;119;-3569.95,-202.3119;Float;False;Property;_Speed_Horizontal;Speed_Horizontal;1;0;Create;True;0;0;False;0;1.2;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;97;-3330.886,-104.2212;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-4122.482,277.6026;Float;True;V;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;100;-3324.324,461.9652;Float;True;v;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-3904.563,299.956;Float;True;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;52;-3149.442,-1512.485;Float;False;2104.735;765.6717;Dissolve Mask;13;44;37;45;49;50;42;41;38;39;40;43;123;124;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-4271.145,-691.0562;Float;False;Property;_Tile_Vertical;Tile_Vertical;11;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-4283.284,-896.0629;Float;False;Property;_Tile_Horizontal;Tile_Horizontal;12;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;98;-3080.655,-183.0524;Float;True;Speed_Vertical;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;120;-3439.055,-318.6734;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;113;-4067.489,-1101.07;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;99;-3204.389,236.1704;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-3095.7,-1275.174;Float;True;5;UV;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;121;-3346.713,-459.0378;Float;False;Speed_Horizontal;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-3094.143,-1462.485;Float;True;109;V;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-3090.957,688.5782;Float;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;False;0;6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-3100.742,-1083.698;Float;True;98;Speed_Vertical;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;116;-4012.19,-790.8627;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;102;-3016.147,461.8213;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;43;-2819.644,-1043.495;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-2822.572,379.1791;Float;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-3728.957,-955.408;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;41;-2741.029,-1219.693;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.1,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-2822.049,-1432.234;Float;True;121;Speed_Horizontal;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;103;-2945.024,-732.1247;Float;True;Property;_Texture0;Texture 0;10;0;Create;True;0;0;False;0;9a5ad12aa4fa58142869ced59cf04267;9a5ad12aa4fa58142869ced59cf04267;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.FunctionNode;44;-2540.884,-1000.87;Float;True;ConstantBiasScale;-1;;4;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT;0;False;1;FLOAT;-0.66;False;2;FLOAT;1.26;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;122;-3097.16,-384.4878;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;62;-2593.417,380.9703;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;123;-2530.851,-1329.643;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-2436.875,381.8455;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-2427.035,706.6611;Float;False;Property;_FrontSide_Alpha;FrontSide_Alpha;14;0;Create;True;0;0;False;0;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;45;-2271.795,-999.814;Float;True;3;0;FLOAT;0;False;1;FLOAT;-0.08;False;2;FLOAT;0.35;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;6;-2841.85,-377.1276;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;37;-2329.994,-1240.821;Float;True;Property;_T_Dissolve_Mask;T_Dissolve_Mask;4;0;Create;True;0;0;False;0;9a5ad12aa4fa58142869ced59cf04267;9a5ad12aa4fa58142869ced59cf04267;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-1990.555,-1456.471;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;125;-2120.887,489.297;Float;True;2;0;FLOAT;0;False;1;FLOAT;3.47;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-1992.262,-1238.65;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-2533.875,-311.1372;Float;True;Property;_T_FlowMap_01;T_FlowMap_01;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;12;-2210.908,-422.0312;Float;True;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;50;-1661.688,-1308.711;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-1825.337,360.2564;Float;True;EdgeMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;105;-807.2709,-631.3834;Float;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;False;0;9a5ad12aa4fa58142869ced59cf04267;9a5ad12aa4fa58142869ced59cf04267;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;82;-526.6375,-1001.011;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;85;-705.5773,-424.7335;Float;True;65;EdgeMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;51;-804.5091,-884.3166;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;87;-1002.956,-1768.58;Float;False;1021.698;681.3699;Color;8;81;83;78;75;76;80;79;127;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-372.5486,-692.0536;Float;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;76;-865.7031,-1546.673;Float;False;Property;_ColorEnd;ColorEnd;7;0;Create;True;0;0;False;0;1,0,0.7529413,1;0,0.9556165,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;106;-191.8303,-925.6785;Float;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-453.6646,-1238.571;Float;False;Property;_Emission;Emission;8;0;Create;True;0;0;False;0;4;1.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-197.368,-1034.894;Float;False;Property;_DarkEdge;DarkEdge;9;0;Create;True;0;0;False;0;0.83;0.936;0.1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;91;146.5205,-959.8055;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-195.565,-1343.972;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;245.2486,49.13953;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-1496.246,-237.0845;Float;False;98;Speed_Vertical;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;138;19.24864,-349.8606;Float;False;Property;_Noise_Opacity;Noise_Opacity;6;0;Create;True;0;0;False;0;1.17;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-1890.293,-57.84528;Float;True;109;V;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-349.7519,30.13953;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;15;-1900.152,-384.6563;Float;True;ConstantBiasScale;-1;;5;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT2;0,0;False;1;FLOAT;-0.3;False;2;FLOAT;2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-558.7518,115.1395;Float;False;Constant;_Float2;Float 2;3;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-970.1706,-1357.432;Float;True;109;V;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-614.3398,-1389.384;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1872.009,-144.5114;Float;False;Property;_FlowStr;FlowStr;4;0;Create;True;0;0;False;0;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;78;-382.2385,-1569.509;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;145;530.5562,-635.7469;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;131;-635.7518,-28.8605;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;136;39.24864,311.1396;Float;False;3;0;FLOAT;0;False;1;FLOAT;5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;33;-1286.353,-407.8117;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.8,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;75;-871.5366,-1722.051;Float;False;Property;_ColorStart;ColorStart;5;0;Create;True;0;0;False;0;0.1529412,0.4352942,1,1;0,0.2358491,0.2298933,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;129;-766.7517,360.1396;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;204.0767,-208.7947;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;508.9851,-989.9301;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1641.598,-285.3098;Float;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;140;449.2484,-336.8605;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-1498.628,-395.1879;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;133;-294.7519,346.1396;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;130;-549.7518,353.1396;Float;True;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-719.8362,-1241.609;Float;False;Property;_ColorLerp;ColorLerp;13;0;Create;True;0;0;False;0;1;4.62;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;135;-176.7518,-78.86063;Float;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;74b4b67d8ec1be54a8babc4dc731abff;74b4b67d8ec1be54a8babc4dc731abff;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;31;-1847.396,-468.3968;Float;False;5;UV;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;144;979.4686,-994.2838;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;SH_StormRing_01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;TransparentCutout;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;4;1;False;-1;1;False;-1;4;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;1,1,1,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;97;0;96;0
WireConnection;109;0;4;2
WireConnection;100;0;4;1
WireConnection;5;0;4;0
WireConnection;98;0;97;0
WireConnection;120;0;119;0
WireConnection;99;0;4;2
WireConnection;121;0;120;0
WireConnection;116;0;111;0
WireConnection;116;1;112;0
WireConnection;102;0;100;0
WireConnection;43;0;38;0
WireConnection;58;0;4;1
WireConnection;58;1;99;0
WireConnection;58;2;102;0
WireConnection;58;3;60;0
WireConnection;114;0;113;0
WireConnection;114;1;116;0
WireConnection;41;0;39;0
WireConnection;41;1;40;0
WireConnection;44;3;43;0
WireConnection;122;0;114;0
WireConnection;122;1;121;0
WireConnection;62;0;58;0
WireConnection;123;0;41;0
WireConnection;123;1;124;0
WireConnection;64;0;62;0
WireConnection;45;0;44;0
WireConnection;6;0;122;0
WireConnection;6;1;98;0
WireConnection;37;0;103;0
WireConnection;37;1;123;0
WireConnection;42;0;38;0
WireConnection;125;0;64;0
WireConnection;125;1;126;0
WireConnection;49;0;37;2
WireConnection;49;1;45;0
WireConnection;10;0;103;0
WireConnection;10;1;6;0
WireConnection;12;0;10;0
WireConnection;50;0;49;0
WireConnection;50;1;42;0
WireConnection;65;0;125;0
WireConnection;105;0;103;0
WireConnection;105;1;12;0
WireConnection;51;0;50;0
WireConnection;86;0;51;0
WireConnection;86;1;82;4
WireConnection;86;2;105;1
WireConnection;86;3;85;0
WireConnection;106;0;86;0
WireConnection;91;1;106;0
WireConnection;91;2;92;0
WireConnection;81;0;76;0
WireConnection;81;1;82;0
WireConnection;81;2;83;0
WireConnection;137;0;135;1
WireConnection;137;1;136;0
WireConnection;134;0;131;0
WireConnection;134;1;132;0
WireConnection;15;3;12;0
WireConnection;80;0;79;0
WireConnection;80;1;127;0
WireConnection;78;0;75;0
WireConnection;78;1;76;0
WireConnection;78;2;80;0
WireConnection;145;0;86;0
WireConnection;136;2;133;0
WireConnection;33;0;23;0
WireConnection;33;1;32;0
WireConnection;139;0;135;1
WireConnection;89;0;81;0
WireConnection;89;1;91;0
WireConnection;16;0;15;0
WireConnection;16;1;17;0
WireConnection;16;2;14;0
WireConnection;140;0;138;0
WireConnection;140;1;137;0
WireConnection;23;0;31;0
WireConnection;23;1;16;0
WireConnection;133;0;130;0
WireConnection;130;0;129;0
WireConnection;135;1;134;0
WireConnection;144;2;89;0
WireConnection;144;9;145;0
WireConnection;144;10;145;0
ASEEND*/
//CHKSM=F8D68E5932F114666B3C5B7E672ABDA6A172CFB1