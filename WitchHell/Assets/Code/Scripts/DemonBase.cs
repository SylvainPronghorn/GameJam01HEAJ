using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class DemonBase : MonoBehaviour
{
    private NavMeshAgent mAgent;


    private void Awake()
    {
        mAgent = GetComponent<NavMeshAgent>();
    }
}
