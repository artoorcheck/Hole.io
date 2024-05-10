using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectAbsorber : MonoBehaviour
{
    [SerializeField]private LayerMask _activeMask;

    [SerializeField]private LayerMask _targetMask;
    
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer == (int)Mathf.Log(_targetMask, 2))
        {
            other.gameObject.layer = (int)Mathf.Log(_activeMask, 2);
            other.GetComponent<Rigidbody>().isKinematic = false;
        }

    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.layer == (int)Mathf.Log(_activeMask, 2))
        {
            other.gameObject.layer = (int)Mathf.Log(_targetMask, 2);
        }
    }
}
