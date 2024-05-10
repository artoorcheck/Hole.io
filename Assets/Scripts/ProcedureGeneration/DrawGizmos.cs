using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ProcedureGeneration;
using NaughtyAttributes;


public class DrawGizmos : MonoBehaviour
{
    [SerializeField] private int seed;
    [SerializeField] private MeshFilter meshFilter;
    [SerializeField] private float scale = 100;
    [SerializeField] private float zscale = 0.01f;


    [Button]
    public void GenerateMesh()
    {
        var mesh = meshFilter.mesh;
        var vertices = mesh.vertices;
        var procedureGeneration = new PerlinNoizeGenerator(seed);
        for ( int i = 0; i< vertices.Length; i++ )
        {
            var v = vertices[i];
            v.z = Mathf.Pow(procedureGeneration.Noise(v.x*scale, v.y*scale)*2, 3)/2*zscale;
            vertices[i] = v;
        }

        mesh.SetVertices(vertices);
        meshFilter.GetComponent<MeshCollider>().sharedMesh = mesh;
    }
}
