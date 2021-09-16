using UnityEngine;

public class PatrolPoint : MonoBehaviour
{
    /// <summary>
    /// the amount of time an entity will pass on the point
    /// </summary>
    public float mWaitDuration = 0.5f;
    [HideInInspector]
    ///<summary>
    /// The linked previous patrol point
    /// </summary>
    public PatrolPoint mPreviousPatrolPoint;
    [HideInInspector]
    ///<summary>
    /// The linked next patrol point
    /// </summary>
    public PatrolPoint mNextPatrolPoint;

#if UNITY_EDITOR
    private void OnDrawGizmos()
    {
        Gizmos.color = Color.blue;
        Gizmos.DrawWireSphere(transform.position, 0.25f);
    }
#endif
}
