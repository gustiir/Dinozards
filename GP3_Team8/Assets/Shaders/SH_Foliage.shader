// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Foliage"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.64
		_FoliageAtlas01_opacity("FoliageAtlas01_opacity", 2D) = "white" {}
		_FoliageAtlas01_diffuse("FoliageAtlas01_diffuse", 2D) = "white" {}
		_FoliageAtlas01_normal("FoliageAtlas01_normal", 2D) = "bump" {}
		_Rougnessintensity("Rougness intensity", Float) = 0
		_FoliageAtlas01_roughness("FoliageAtlas01_roughness", 2D) = "white" {}
		_ColorAdd("ColorAdd", Color) = (0.3157262,0.5188679,0.3211065,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TreeTransparentCutout"  "Queue" = "Geometry+0" }
		Cull Off
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _FoliageAtlas01_normal;
		uniform float4 _FoliageAtlas01_normal_ST;
		uniform float4 _ColorAdd;
		uniform sampler2D _FoliageAtlas01_diffuse;
		uniform float4 _FoliageAtlas01_diffuse_ST;
		uniform sampler2D _FoliageAtlas01_roughness;
		uniform float4 _FoliageAtlas01_roughness_ST;
		uniform float _Rougnessintensity;
		uniform sampler2D _FoliageAtlas01_opacity;
		uniform float4 _FoliageAtlas01_opacity_ST;
		uniform float _Cutoff = 0.64;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_FoliageAtlas01_normal = i.uv_texcoord * _FoliageAtlas01_normal_ST.xy + _FoliageAtlas01_normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _FoliageAtlas01_normal, uv_FoliageAtlas01_normal ) );
			float2 uv_FoliageAtlas01_diffuse = i.uv_texcoord * _FoliageAtlas01_diffuse_ST.xy + _FoliageAtlas01_diffuse_ST.zw;
			o.Albedo = ( _ColorAdd * tex2D( _FoliageAtlas01_diffuse, uv_FoliageAtlas01_diffuse ) ).rgb;
			float2 uv_FoliageAtlas01_roughness = i.uv_texcoord * _FoliageAtlas01_roughness_ST.xy + _FoliageAtlas01_roughness_ST.zw;
			o.Smoothness = ( tex2D( _FoliageAtlas01_roughness, uv_FoliageAtlas01_roughness ).r * _Rougnessintensity );
			float2 uv_FoliageAtlas01_opacity = i.uv_texcoord * _FoliageAtlas01_opacity_ST.xy + _FoliageAtlas01_opacity_ST.zw;
			float4 tex2DNode19 = tex2D( _FoliageAtlas01_opacity, uv_FoliageAtlas01_opacity );
			o.Alpha = tex2DNode19.r;
			clip( tex2DNode19.r - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
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
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
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
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
2322;113;1467;865;579.6175;553.9243;1.3;True;True
Node;AmplifyShaderEditor.SamplerNode;30;-3.289886,176.9178;Float;True;Property;_FoliageAtlas01_roughness;FoliageAtlas01_roughness;5;0;Create;True;0;0;False;0;33889344feced2845b9466f017a38dca;33889344feced2845b9466f017a38dca;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;70.80969,379.6145;Float;False;Property;_Rougnessintensity;Rougness intensity;4;0;Create;True;0;0;False;0;0;0.63;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-96.88959,-283.7893;Float;True;Property;_FoliageAtlas01_diffuse;FoliageAtlas01_diffuse;2;0;Create;True;0;0;False;0;fc7e2183097b49e47841972fcd9392cb;fc7e2183097b49e47841972fcd9392cb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;29;-75.05623,-490.4874;Float;False;Property;_ColorAdd;ColorAdd;6;0;Create;True;0;0;False;0;0.3157262,0.5188679,0.3211065,0;0,1,0.01960778,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;19;11.13484,520.7457;Float;True;Property;_FoliageAtlas01_opacity;FoliageAtlas01_opacity;1;0;Create;True;0;0;False;0;b8f727e99d967f147adcb0fd512cc035;b8f727e99d967f147adcb0fd512cc035;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;26;40.18824,-54.35995;Float;True;Property;_FoliageAtlas01_normal;FoliageAtlas01_normal;3;0;Create;True;0;0;False;0;81c972c4941fc9947a6e1c6cfa770f78;81c972c4941fc9947a6e1c6cfa770f78;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;360.2547,247.5419;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;339.0197,-317.5292;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;835.0464,-21.36948;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;SH_Foliage;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.64;True;True;0;True;TreeTransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;1;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;31;0;30;1
WireConnection;31;1;27;0
WireConnection;34;0;29;0
WireConnection;34;1;18;0
WireConnection;0;0;34;0
WireConnection;0;1;26;0
WireConnection;0;4;31;0
WireConnection;0;9;19;0
WireConnection;0;10;19;0
ASEEND*/
//CHKSM=1F903115572FFC21206F761FF38381BBFA8A0BBF