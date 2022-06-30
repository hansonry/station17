xof 0303txt 0032

template AnimTicksPerSecond {
  <9E415A43-7BA6-4a73-8743-B73D47E88476>
  DWORD AnimTicksPerSecond;
}

template XSkinMeshHeader {
  <3cf169ce-ff7c-44ab-93c0-f78f62d172e2>
  WORD nMaxSkinWeightsPerVertex;
  WORD nMaxSkinWeightsPerFace;
  WORD nBones;
}

template SkinWeights {
  <6f0d123b-bad2-4167-a0d0-80224f25fabb>
  STRING transformNodeName;
  DWORD nWeights;
  array DWORD vertexIndices[nWeights];
  array float weights[nWeights];
  Matrix4x4 matrixOffset;
}

Frame Root {
  FrameTransformMatrix {
     1.000000, 0.000000, 0.000000, 0.000000,
     0.000000, 1.000000, 0.000000, 0.000000,
     0.000000, 0.000000, 1.000000, 0.000000,
     0.000000, 0.000000, 0.000000, 1.000000;;
  }
  Frame Armature {
    FrameTransformMatrix {
       8.700000, 0.000000, 0.000000, 0.000000,
       0.000000, 0.000000,-8.700000, 0.000000,
       0.000000, 8.700000, 0.000000, 0.000000,
       4.375000,-4.375000, 5.000000, 1.000000;;
    }
    Frame Armature_Bone {
      FrameTransformMatrix {
         1.000000, 0.000000, 0.000000, 0.000000,
         0.000000, 0.000000, 1.000000, 0.000000,
         0.000000,-1.000000, 0.000000, 0.000000,
         0.000000, 0.000000, 0.000000, 1.000000;;
      }
    } // End of Armature_Bone
    Frame LockerDoor {
      FrameTransformMatrix {
         1.149425, 0.000000, 0.000000, 0.000000,
         0.000000, 0.000000, 1.149425, 0.000000,
         0.000000,-1.149425, 0.000000, 0.000000,
        -0.502874, 0.574713, 0.502874, 1.000000;;
      }
      Mesh { // LockerDoor mesh
        24;
         0.437500;-0.437500;-0.437500;,
         0.437500;-0.437500; 1.437500;,
         0.437500; 0.437500; 1.437500;,
         0.437500; 0.437500;-0.437500;,
         0.437500; 0.437500;-0.437500;,
         0.437500; 0.437500; 1.437500;,
         0.500000; 0.437500; 1.437500;,
         0.500000; 0.437500;-0.437500;,
         0.500000; 0.437500;-0.437500;,
         0.500000; 0.437500; 1.437500;,
         0.500000;-0.437500; 1.437500;,
         0.500000;-0.437500;-0.437500;,
         0.500000;-0.437500;-0.437500;,
         0.500000;-0.437500; 1.437500;,
         0.437500;-0.437500; 1.437500;,
         0.437500;-0.437500;-0.437500;,
         0.437500; 0.437500;-0.437500;,
         0.500000; 0.437500;-0.437500;,
         0.500000;-0.437500;-0.437500;,
         0.437500;-0.437500;-0.437500;,
         0.500000; 0.437500; 1.437500;,
         0.437500; 0.437500; 1.437500;,
         0.437500;-0.437500; 1.437500;,
         0.500000;-0.437500; 1.437500;;
        6;
        4;0,1,2,3;,
        4;4,5,6,7;,
        4;8,9,10,11;,
        4;12,13,14,15;,
        4;16,17,18,19;,
        4;20,21,22,23;;
        MeshNormals { // LockerDoor normals
          6;
          -1.000000;-0.000000; 0.000000;,
           0.000000; 1.000000; 0.000000;,
           1.000000;-0.000000; 0.000000;,
           0.000000;-1.000000; 0.000000;,
           0.000000; 0.000000;-1.000000;,
           0.000000;-0.000000; 1.000000;;
          6;
          4;0,0,0,0;,
          4;1,1,1,1;,
          4;2,2,2,2;,
          4;3,3,3,3;,
          4;4,4,4,4;,
          4;5,5,5,5;;
        } // End of LockerDoor normals
        MeshTextureCoords { // LockerDoor UV coordinates
          24;
           0.015625; 0.484375;,
           0.015625; 0.015625;,
           0.234375; 0.015625;,
           0.234375; 0.484375;,
           0.250000; 0.484375;,
           0.250000; 0.015625;,
           0.234375; 0.015625;,
           0.234375; 0.484375;,
           0.234375; 0.484375;,
           0.234375; 0.015625;,
           0.015625; 0.015625;,
           0.015625; 0.484375;,
           0.015625; 0.484375;,
           0.015625; 0.015625;,
           0.000000; 0.015625;,
           0.000000; 0.484375;,
           0.015625; 0.484375;,
           0.015625; 0.500000;,
           0.234375; 0.500000;,
           0.234375; 0.484375;,
           0.015625; 0.000000;,
           0.015625; 0.015625;,
           0.234375; 0.015625;,
           0.234375; 0.000000;;
        } // End of LockerDoor UV coordinates
        XSkinMeshHeader {
          1;
          3;
          1;
        }
        SkinWeights {
          "Armature_Bone";
          24;
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23;
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000,
           1.000000;
           1.149425, 0.000000, 0.000000, 0.000000,
           0.000000, 1.149425,-0.000000, 0.000000,
           0.000000, 0.000000, 1.149425, 0.000000,
          -0.502874, 0.502874,-0.574713, 1.000000;;
        } // End of Armature_Bone skin weights
      } // End of LockerDoor mesh
    } // End of LockerDoor
  } // End of Armature
} // End of Root
AnimTicksPerSecond {
  24;
}
AnimationSet Open {
  Animation {
    {Armature}
    AnimationKey { // Rotation
      0;
      20;
      0;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      1;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      2;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      3;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      4;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      5;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      6;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      7;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      8;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      9;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      10;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      11;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      12;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      13;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      14;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      15;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      16;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      17;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      18;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      19;4; 0.707107, 0.707107, 0.000000, 0.000000;;;
    }
  }
}
Animation {
  {Armature_Bone}
  AnimationKey { // Rotation
    0;
    20;
    0;4;-0.707097, 0.707097, 0.003789,-0.003789;;,
    1;4;-0.706953, 0.706953, 0.014728,-0.014728;;,
    2;4;-0.706370, 0.706370, 0.032274,-0.032274;;,
    3;4;-0.704891, 0.704891, 0.055936,-0.055936;;,
    4;4;-0.701957, 0.701957, 0.085183,-0.085183;;,
    5;4;-0.696961, 0.696961, 0.119356,-0.119356;;,
    6;4;-0.689321, 0.689321, 0.157596,-0.157596;;,
    7;4;-0.678583, 0.678583, 0.198809,-0.198809;;,
    8;4;-0.664520, 0.664520, 0.241687,-0.241687;;,
    9;4;-0.647223, 0.647223, 0.284785,-0.284785;;,
    10;4;-0.627134, 0.627134, 0.326654,-0.326654;;,
    11;4;-0.605022, 0.605022, 0.365990,-0.365990;;,
    12;4;-0.581890, 0.581890, 0.401751,-0.401751;;,
    13;4;-0.558858, 0.558858, 0.433218,-0.433218;;,
    14;4;-0.537039, 0.537039, 0.459988,-0.459988;;,
    15;4;-0.517458, 0.517458, 0.481910,-0.481910;;,
    16;4;-0.501012, 0.501012, 0.498986,-0.498986;;,
    17;4;-0.488469, 0.488469, 0.511271,-0.511271;;,
    18;4;-0.480501, 0.480501, 0.518767,-0.518767;;,
    19;4;-0.477714, 0.477714, 0.521334,-0.521334;;;
  }
}
}
} // End of AnimationSet Open
AnimationSet Close {
  Animation {
    {Armature}
    AnimationKey { // Rotation
      0;
      20;
      0;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      1;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      2;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      3;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      4;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      5;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      6;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      7;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      8;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      9;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      10;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      11;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      12;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      13;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      14;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      15;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      16;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      17;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      18;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      19;4; 0.707107, 0.707107, 0.000000, 0.000000;;;
    }
  }
}
Animation {
  {Armature_Bone}
  AnimationKey { // Rotation
    0;
    20;
    0;4;-0.480501, 0.480501, 0.518767,-0.518767;;,
    1;4;-0.488469, 0.488469, 0.511271,-0.511271;;,
    2;4;-0.501011, 0.501012, 0.498986,-0.498986;;,
    3;4;-0.517458, 0.517458, 0.481910,-0.481910;;,
    4;4;-0.537039, 0.537039, 0.459988,-0.459988;;,
    5;4;-0.558858, 0.558858, 0.433218,-0.433218;;,
    6;4;-0.581890, 0.581890, 0.401751,-0.401751;;,
    7;4;-0.605022, 0.605022, 0.365990,-0.365990;;,
    8;4;-0.627134, 0.627134, 0.326654,-0.326654;;,
    9;4;-0.647223, 0.647223, 0.284785,-0.284785;;,
    10;4;-0.664520, 0.664520, 0.241687,-0.241687;;,
    11;4;-0.678583, 0.678583, 0.198809,-0.198809;;,
    12;4;-0.689321, 0.689321, 0.157596,-0.157596;;,
    13;4;-0.696961, 0.696961, 0.119356,-0.119356;;,
    14;4;-0.701957, 0.701957, 0.085183,-0.085183;;,
    15;4;-0.704891, 0.704891, 0.055936,-0.055936;;,
    16;4;-0.706370, 0.706370, 0.032274,-0.032274;;,
    17;4;-0.706953, 0.706953, 0.014728,-0.014728;;,
    18;4;-0.707097, 0.707097, 0.003788,-0.003789;;,
    19;4;-0.707107, 0.707107, 0.000000, 0.000000;;;
  }
}
}
} // End of AnimationSet Close
AnimationSet Shader_NodetreeAction {
  Animation {
    {Armature}
    AnimationKey { // Rotation
      0;
      20;
      0;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      1;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      2;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      3;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      4;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      5;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      6;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      7;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      8;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      9;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      10;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      11;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      12;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      13;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      14;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      15;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      16;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      17;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      18;4; 0.707107, 0.707107, 0.000000, 0.000000;;,
      19;4; 0.707107, 0.707107, 0.000000, 0.000000;;;
    }
  }
}
Animation {
  {Armature_Bone}
  AnimationKey { // Rotation
    0;
    20;
    0;4;-0.480501, 0.480501, 0.518767,-0.518767;;,
    1;4;-0.488469, 0.488469, 0.511271,-0.511271;;,
    2;4;-0.501011, 0.501012, 0.498986,-0.498986;;,
    3;4;-0.517458, 0.517458, 0.481910,-0.481910;;,
    4;4;-0.537039, 0.537039, 0.459988,-0.459988;;,
    5;4;-0.558858, 0.558858, 0.433218,-0.433218;;,
    6;4;-0.581890, 0.581890, 0.401751,-0.401751;;,
    7;4;-0.605022, 0.605022, 0.365990,-0.365990;;,
    8;4;-0.627134, 0.627134, 0.326654,-0.326654;;,
    9;4;-0.647223, 0.647223, 0.284785,-0.284785;;,
    10;4;-0.664520, 0.664520, 0.241687,-0.241687;;,
    11;4;-0.678583, 0.678583, 0.198809,-0.198809;;,
    12;4;-0.689321, 0.689321, 0.157596,-0.157596;;,
    13;4;-0.696961, 0.696961, 0.119356,-0.119356;;,
    14;4;-0.701957, 0.701957, 0.085183,-0.085183;;,
    15;4;-0.704891, 0.704891, 0.055936,-0.055936;;,
    16;4;-0.706370, 0.706370, 0.032274,-0.032274;;,
    17;4;-0.706953, 0.706953, 0.014728,-0.014728;;,
    18;4;-0.707097, 0.707097, 0.003788,-0.003789;;,
    19;4;-0.707107, 0.707107, 0.000000, 0.000000;;;
  }
}
}
} // End of AnimationSet Shader_NodetreeAction
AnimationSet Default_Action {
  Animation {
    {LockerDoor}
    AnimationKey { // Rotation
      0;
      20;
      0;4;-1.000000, 0.000000, 0.000000, 0.000000;;,
      1;4;-1.000000, 0.000000, 0.000000, 0.000000;;,
      2;4;-1.000000, 0.000000, 0.000000, 0.000000;;,
      3;4;-1.000000, 0.000000, 0.000000, 0.000000;;,
      4;4;-1.000000, 0.000000, 0.000000, 0.000000;;,
      5;4;-1.000000, 0.000000, 0.000000, 0.000000;;,
      6;4;-1.000000, 0.000000, 0.000000, 0.000000;;,
      7;4;-1.000000, 0.000000, 0.000000, 0.000000;;,
      8;4;-1.000000, 0.000000, 0.000000, 0.000000;;,
      9;4;-1.000000, 0.000000, 0.000000, 0.000000;;,
      10;4;-1.000000, 0.000000, 0.000000, 0.000000;;,
      11;4;-1.000000, 0.000000, 0.000000, 0.000000;;,
      12;4;-1.000000, 0.000000, 0.000000, 0.000000;;,
      13;4;-1.000000, 0.000000, 0.000000, 0.000000;;,
      14;4;-1.000000, 0.000000, 0.000000, 0.000000;;,
      15;4;-1.000000, 0.000000, 0.000000, 0.000000;;,
      16;4;-1.000000, 0.000000, 0.000000, 0.000000;;,
      17;4;-1.000000, 0.000000, 0.000000, 0.000000;;,
      18;4;-1.000000, 0.000000, 0.000000, 0.000000;;,
      19;4;-1.000000, 0.000000, 0.000000, 0.000000;;;
    }
  }
}
} // End of AnimationSet Default_Action
