using NaughtyAttributes;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;



[RequireComponent(typeof(Collider), typeof(Rigidbody))]
public class Absorbable : MonoBehaviour
{
    [field: SerializeField] public int NeedRadius { get; private set; } = 1;  
    [field: SerializeField] public int Reward { get; private set; } = 1;
}
