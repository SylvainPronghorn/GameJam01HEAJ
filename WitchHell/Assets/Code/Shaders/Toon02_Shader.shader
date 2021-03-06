// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Toon02_Shader"
{
	Properties
	{
		[NoScaleOffset]_ToonRamp("Toon Ramp", 2D) = "white" {}
		_ShadowRampDisplacement("ShadowRampDisplacement", Float) = 0
		[NoScaleOffset][Normal]_NormalMap("Normal Map", 2D) = "bump" {}
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)
		_FresnelBias("Fresnel Bias", Float) = 0
		_FresnelScale("Fresnel Scale", Float) = 0
		_FresnelPower("Fresnel Power", Float) = 0
		_FresnelTint("Fresnel Tint", Color) = (1,1,1,1)
		[NoScaleOffset]_Emissive("Emissive", 2D) = "white" {}
		[HDR]_EmissiveTint("EmissiveTint", Color) = (1,1,1,1)
		_MainTilingandOffset("Main Tiling and Offset", Vector) = (1,1,0,0)
		_NdotLAdd("NdotL Add", Float) = 0
		_NDotLMul("NDotL Mul", Float) = 0
		[Toggle]_ToggleSwitch0("Toggle Switch0", Float) = 0
		_OffsetFadeUp("OffsetFadeUp", Float) = 0.5
		_Scale("Scale", Float) = 1
		[HDR]_OutlineColor("Outline Color", Color) = (0,0,0,0)
		[Toggle]_UseHeightGradient("UseHeightGradient", Float) = 0
		_OutlineWidth("Outline Width", Range( 0 , 1)) = 0.02
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float outlineVar = _OutlineWidth;
			v.vertex.xyz *= ( 1 + outlineVar);
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			float3 appendResult143 = (float3(_OutlineColor.r , _OutlineColor.g , _OutlineColor.b));
			o.Emission = appendResult143;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float4 _EmissiveTint;
		uniform sampler2D _Emissive;
		SamplerState sampler_Emissive;
		uniform float4 _MainTilingandOffset;
		uniform float _UseHeightGradient;
		uniform float _FresnelBias;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float _ToggleSwitch0;
		uniform sampler2D _NormalMap;
		uniform float _NdotLAdd;
		uniform float _NDotLMul;
		uniform float4 _FresnelTint;
		uniform sampler2D _ToonRamp;
		uniform float _ShadowRampDisplacement;
		uniform float4 _Tint;
		uniform sampler2D _Albedo;
		uniform float _Scale;
		uniform float _OffsetFadeUp;
		uniform float4 _OutlineColor;
		uniform float _OutlineWidth;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += 0;
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV51 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode51 = ( _FresnelBias + _FresnelScale * pow( 1.0 - fresnelNdotV51, _FresnelPower ) );
			float2 appendResult98 = (float2(_MainTilingandOffset.z , _MainTilingandOffset.w));
			float2 appendResult97 = (float2(_MainTilingandOffset.x , _MainTilingandOffset.y));
			float2 temp_cast_1 = (0.0).xx;
			float2 MainUV105 = ( appendResult98 + ( appendResult97 * ( i.uv_texcoord - temp_cast_1 ) ) + 0.0 );
			float3 NormalTex21 = UnpackNormal( tex2D( _NormalMap, MainUV105 ) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult2 = dot( normalize( (WorldNormalVector( i , NormalTex21 )) ) , ase_worldlightDir );
			float Normal_LightDir8 = (( _ToggleSwitch0 )?( ( ( dotResult2 + _NdotLAdd ) * _NDotLMul ) ):( dotResult2 ));
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 RimLight55 = ( saturate( ( fresnelNode51 * ( Normal_LightDir8 * ase_lightAtten ) ) ) * ( ase_lightColor * _FresnelTint ) );
			float2 temp_cast_2 = ((Normal_LightDir8*_ShadowRampDisplacement + _ShadowRampDisplacement)).xx;
			float4 Albedo29 = ( _Tint * tex2D( _Albedo, MainUV105 ) );
			float4 Shadow15 = ( tex2D( _ToonRamp, temp_cast_2 ) * Albedo29 );
			UnityGI gi37 = gi;
			float3 diffNorm37 = WorldNormalVector( i , NormalTex21 );
			gi37 = UnityGI_Base( data, 1, diffNorm37 );
			float3 indirectDiffuse37 = gi37.indirect.diffuse + diffNorm37 * 0.0001;
			float4 Lighting36 = ( Shadow15 * ( ase_lightColor * float4( ( indirectDiffuse37 + ase_lightAtten ) , 0.0 ) ) );
			float4 temp_output_65_0 = ( RimLight55 + Lighting36 );
			float HeightGradient138 = ( 1.0 - saturate( ( ( ase_worldPos / ( _Scale * 2.0 ) ).y + _OffsetFadeUp ) ) );
			c.rgb = (( _UseHeightGradient )?( ( temp_output_65_0 * HeightGradient138 ) ):( temp_output_65_0 )).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			float3 appendResult112 = (float3(_EmissiveTint.r , _EmissiveTint.g , _EmissiveTint.b));
			float2 appendResult98 = (float2(_MainTilingandOffset.z , _MainTilingandOffset.w));
			float2 appendResult97 = (float2(_MainTilingandOffset.x , _MainTilingandOffset.y));
			float2 temp_cast_0 = (0.0).xx;
			float2 MainUV105 = ( appendResult98 + ( appendResult97 * ( i.uv_texcoord - temp_cast_0 ) ) + 0.0 );
			float4 tex2DNode95 = tex2D( _Emissive, MainUV105 );
			float3 appendResult110 = (float3(tex2DNode95.r , tex2DNode95.g , tex2DNode95.b));
			float3 Emissive114 = ( appendResult112 * appendResult110 );
			o.Emission = Emissive114;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18503
363;73;733;540;-660.7389;-43.21268;1;True;False
Node;AmplifyShaderEditor.TexCoordVertexDataNode;101;-4345.081,866.1477;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;99;-4298.255,991.025;Inherit;False;Constant;_Float1;Float 1;17;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;96;-4404.523,618.1648;Inherit;False;Property;_MainTilingandOffset;Main Tiling and Offset;18;0;Create;True;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;97;-4141.122,619.5156;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;102;-4102.614,866.1479;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;98;-4134.875,732.9456;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-3937.154,833.8879;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;104;-3747.758,825.5628;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;-3601.014,832.858;Inherit;False;MainUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;-3288.337,682.0901;Inherit;False;105;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;20;-3079.219,618.3788;Inherit;True;Property;_NormalMap;Normal Map;2;2;[NoScaleOffset];[Normal];Create;True;0;0;False;0;False;-1;None;7b342d5c10742ea4498fed8d28dc6055;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;10;-3017.48,25.48897;Inherit;False;1513.181;481.7377;NormalDotLi;10;8;121;120;119;118;117;2;1;3;22;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-2777.236,619.7643;Inherit;False;NormalTex;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-2943.097,152.8607;Inherit;False;21;NormalTex;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;1;-2698.17,75.48883;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;3;-2734.139,224.1965;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;118;-2300.869,328.4741;Inherit;False;Property;_NdotLAdd;NdotL Add;19;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;2;-2437.447,187.4433;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-2133.869,358.4741;Inherit;False;Property;_NDotLMul;NDotL Mul;20;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;117;-2089.701,252.7697;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;-1937.869,261.4741;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;30;-1490.715,-180.5939;Inherit;False;1066.398;559.9264;Albedo;5;107;24;29;26;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ToggleSwitchNode;121;-1907.869,141.4741;Inherit;False;Property;_ToggleSwitch0;Toggle Switch0;21;0;Create;True;0;0;False;0;False;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-1426.281,104.9144;Inherit;False;105;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;25;-1170.539,-130.5938;Inherit;False;Property;_Tint;Tint;4;0;Create;True;0;0;False;0;False;1,1,1,1;0.496351,0.5490331,0.6226415,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;24;-1248.997,91.95699;Inherit;True;Property;_Albedo;Albedo;3;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;e1f15744a67ccf141b34a93a17d89293;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-1719.213,161.4973;Inherit;False;Normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;19;-1376.972,728.129;Inherit;False;1311.126;329.8708;Shadow;7;18;15;31;13;32;17;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-809.621,-20.54476;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1356.957,872.1456;Inherit;False;Property;_ShadowRampDisplacement;ShadowRampDisplacement;1;0;Create;True;0;0;False;0;False;0;0.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;137;63.83443,1374.461;Inherit;False;1833.027;588.435;Comment;14;116;126;127;135;134;132;131;133;128;123;125;130;129;138;Height Gradient;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;-1287.972,780.5708;Inherit;False;8;Normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-648.3175,-23.02959;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;130;330.8344,1795.461;Inherit;False;Constant;_Float0;Float 0;23;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;17;-1073.6,811.5687;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;42;-1358.117,1217.192;Inherit;False;1273.059;499.4547;Lighting;9;33;35;36;34;37;38;40;39;41;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;129;328.8344,1689.461;Inherit;False;Property;_Scale;Scale;23;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;68;-1906.463,1872.064;Inherit;False;1801.848;893.6233;Comment;22;63;54;53;52;61;62;51;59;57;64;66;60;56;55;49;48;45;50;43;46;44;47;Rim Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-1850.463,2128.029;Inherit;False;Property;_FresnelPower;Fresnel Power;9;0;Create;True;0;0;False;0;False;0;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-1856.463,2041.029;Inherit;False;Property;_FresnelScale;Fresnel Scale;8;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-1308.117,1501.647;Inherit;False;21;NormalTex;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-688.9042,964.368;Inherit;False;29;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;13;-886.9322,778.1292;Inherit;True;Property;_ToonRamp;Toon Ramp;0;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;e6792bf7cb9dad74ca09d44598d628c1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;52;-1845.463,1966.028;Inherit;False;Property;_FresnelBias;Fresnel Bias;7;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-1587.144,2135.122;Inherit;False;8;Normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;63;-1568.532,2213.476;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;123;121.8344,1424.461;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;499.8344,1707.461;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;37;-1119.117,1503.647;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightAttenuation;38;-1100.118,1605.647;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;128;646.8342,1505.461;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FresnelNode;51;-1644.271,1932.026;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-515.9045,831.3682;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-1329.101,2124.871;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;57;-982.5715,2170.458;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;133;915.8342,1681.461;Inherit;False;Property;_OffsetFadeUp;OffsetFadeUp;22;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-853.1178,1504.647;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;131;790.8342,1504.461;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ColorNode;59;-1023.938,2309.115;Inherit;False;Property;_FresnelTint;Fresnel Tint;10;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-334.5446,823.8049;Inherit;False;Shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;34;-1049.198,1329.156;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-1170.532,1936.476;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-758.8042,2253.781;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-740.3179,1379.68;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;132;1100.834,1557.461;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;66;-963.8274,1953.603;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;-713.2322,1267.192;Inherit;False;15;Shadow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-586.1598,1943.318;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-882.42,-764.7278;Inherit;False;105;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;134;1228.835,1557.461;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-499.0595,1272.724;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;135;1380.677,1542.285;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;-328.6153,1922.064;Inherit;False;RimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;111;-590.4609,-1035.114;Inherit;False;Property;_EmissiveTint;EmissiveTint;17;1;[HDR];Create;True;0;0;False;0;False;1,1,1,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-309.0594,1268.724;Inherit;False;Lighting;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;95;-675.1583,-786.8629;Inherit;True;Property;_Emissive;Emissive;16;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;110;-377.5851,-759.2257;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;220.4651,98.29621;Inherit;False;36;Lighting;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;226.9061,-58.46378;Inherit;False;55;RimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;138;1559.999,1554.151;Inherit;False;HeightGradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;112;-389.3291,-1003.922;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;142;741.1804,293.1196;Inherit;False;Property;_OutlineColor;Outline Color;24;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;139;510.2985,166.9633;Inherit;False;138;HeightGradient;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;462.9251,-10.88548;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-178.517,-869.476;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;93;-2425.082,2994.482;Inherit;False;2737.891;1051.178;Not in use;23;82;84;83;80;92;71;73;69;70;72;88;89;91;76;74;79;78;90;86;75;77;81;87;Spec;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-7.352742,-848.546;Inherit;False;Emissive;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;11;-2652.613,779.7983;Inherit;False;913.6124;417.8063;NormalDotL;5;23;5;9;7;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;143;971.1677,313.0148;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;753.4122,86.36732;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;144;900.7389,494.2126;Inherit;False;Property;_OutlineWidth;Outline Width;26;0;Create;True;0;0;False;0;False;0.02;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-1170.603,2562.56;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;5;-2372.017,829.7983;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;86;-1210.845,3323.427;Inherit;True;Property;_SpecularMap;SpecularMap;13;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;49;-1002.693,2649.688;Inherit;False;Property;_RimPower;RimPower;6;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;1066.359,1783.704;Inherit;False;8;Normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-2066.351,3104.933;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;127;347.8344,1504.461;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-1470.108,3296.444;Inherit;False;Constant;_Max;Max;12;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-860.8896,3092.851;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;47;-877.7498,2560.968;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;46;-1025.768,2564.152;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;75;-1583.108,3113.444;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;83;-271.1909,3234.365;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;48;-667.6598,2560.702;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;77;-1261.108,3084.444;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;-2375.082,3363.903;Inherit;False;21;NormalTex;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;126;113.8344,1580.461;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;88.8092,3100.365;Inherit;False;Specular;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-516.6931,2565.688;Inherit;False;Rim;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;74;-1925.082,3099.903;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;1273.244,-220.8661;Inherit;False;114;Emissive;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OutlineNode;141;1204.439,279.2711;Inherit;False;1;True;None;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;-1426.592,3433.201;Inherit;False;105;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-1460.831,3929.66;Inherit;False;Property;_Spectransition;Spec transition;15;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;72;-2185.082,3367.903;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightPos;71;-2353.25,3221.779;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.DotProductOpNode;7;-2173.875,860.5994;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-1433.214,2557.785;Inherit;False;9;Normal_ViewDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-295.1592,3088.444;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-1992.261,888.2393;Inherit;False;Normal_ViewDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-1901.082,3253.903;Inherit;False;Property;_SpecPower;Spec Power;11;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;69;-2274.694,3044.482;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;45;-1400.306,2476.453;Inherit;False;Property;_RimOffset;RimOffset;5;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;88;-1391.942,3569.357;Inherit;False;Property;_SpecColor;Spec Color;14;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-837.392,3526.985;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-79.88471,3094.008;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-2597.476,862.0879;Inherit;False;21;NormalTex;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ToggleSwitchNode;140;978.4233,-22.59313;Inherit;False;Property;_UseHeightGradient;UseHeightGradient;25;0;Create;True;0;0;False;0;False;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-595.1592,3240.444;Inherit;False;Property;_SpecIntensity;Spec Intensity;12;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;6;-2350.093,1001.369;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;78;-1473.108,3213.444;Inherit;False;Constant;_Min;Min;13;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;89;-1357.831,3779.66;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;90;-1109.123,3602.201;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1548.901,-253.1571;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Toon02_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;True;1.33;0.1698113,0.1698113,0.1698113,0;VertexScale;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;97;0;96;1
WireConnection;97;1;96;2
WireConnection;102;0;101;0
WireConnection;102;1;99;0
WireConnection;98;0;96;3
WireConnection;98;1;96;4
WireConnection;103;0;97;0
WireConnection;103;1;102;0
WireConnection;104;0;98;0
WireConnection;104;1;103;0
WireConnection;104;2;99;0
WireConnection;105;0;104;0
WireConnection;20;1;106;0
WireConnection;21;0;20;0
WireConnection;1;0;22;0
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;117;0;2;0
WireConnection;117;1;118;0
WireConnection;119;0;117;0
WireConnection;119;1;120;0
WireConnection;121;0;2;0
WireConnection;121;1;119;0
WireConnection;24;1;107;0
WireConnection;8;0;121;0
WireConnection;26;0;25;0
WireConnection;26;1;24;0
WireConnection;29;0;26;0
WireConnection;17;0;12;0
WireConnection;17;1;18;0
WireConnection;17;2;18;0
WireConnection;13;1;17;0
WireConnection;125;0;129;0
WireConnection;125;1;130;0
WireConnection;37;0;40;0
WireConnection;128;0;123;0
WireConnection;128;1;125;0
WireConnection;51;1;52;0
WireConnection;51;2;53;0
WireConnection;51;3;54;0
WireConnection;31;0;13;0
WireConnection;31;1;32;0
WireConnection;62;0;61;0
WireConnection;62;1;63;0
WireConnection;39;0;37;0
WireConnection;39;1;38;0
WireConnection;131;0;128;0
WireConnection;15;0;31;0
WireConnection;64;0;51;0
WireConnection;64;1;62;0
WireConnection;60;0;57;0
WireConnection;60;1;59;0
WireConnection;41;0;34;0
WireConnection;41;1;39;0
WireConnection;132;0;131;1
WireConnection;132;1;133;0
WireConnection;66;0;64;0
WireConnection;56;0;66;0
WireConnection;56;1;60;0
WireConnection;134;0;132;0
WireConnection;35;0;33;0
WireConnection;35;1;41;0
WireConnection;135;0;134;0
WireConnection;55;0;56;0
WireConnection;36;0;35;0
WireConnection;95;1;109;0
WireConnection;110;0;95;1
WireConnection;110;1;95;2
WireConnection;110;2;95;3
WireConnection;138;0;135;0
WireConnection;112;0;111;1
WireConnection;112;1;111;2
WireConnection;112;2;111;3
WireConnection;65;0;16;0
WireConnection;65;1;67;0
WireConnection;113;0;112;0
WireConnection;113;1;110;0
WireConnection;114;0;113;0
WireConnection;143;0;142;1
WireConnection;143;1;142;2
WireConnection;143;2;142;3
WireConnection;136;0;65;0
WireConnection;136;1;139;0
WireConnection;44;0;45;0
WireConnection;44;1;43;0
WireConnection;5;0;23;0
WireConnection;86;1;108;0
WireConnection;70;0;69;0
WireConnection;70;1;71;1
WireConnection;127;0;123;0
WireConnection;127;1;126;0
WireConnection;87;0;77;0
WireConnection;87;1;92;0
WireConnection;47;0;46;0
WireConnection;46;0;44;0
WireConnection;75;0;74;0
WireConnection;75;1;76;0
WireConnection;48;0;47;0
WireConnection;48;1;49;0
WireConnection;77;0;75;0
WireConnection;77;1;78;0
WireConnection;77;2;79;0
WireConnection;84;0;82;0
WireConnection;50;0;48;0
WireConnection;74;0;70;0
WireConnection;74;1;72;0
WireConnection;141;0;143;0
WireConnection;141;1;144;0
WireConnection;72;0;73;0
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;80;0;87;0
WireConnection;80;1;81;0
WireConnection;9;0;7;0
WireConnection;92;0;86;0
WireConnection;92;1;90;0
WireConnection;82;0;80;0
WireConnection;82;1;83;0
WireConnection;140;0;65;0
WireConnection;140;1;136;0
WireConnection;90;0;88;0
WireConnection;90;1;89;0
WireConnection;90;2;91;0
WireConnection;0;2;115;0
WireConnection;0;13;140;0
WireConnection;0;11;141;0
ASEEND*/
//CHKSM=8C84D713390CD52BD78547E9BB373AC2C79E176D