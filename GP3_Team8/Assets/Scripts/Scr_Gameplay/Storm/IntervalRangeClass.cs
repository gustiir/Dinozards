using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class IntervalRangeClass 
{
    [Tooltip("This will happen after the storm start")]
    public float preCounter;
    [Tooltip("This will happen after the storm start")]
    public float shrinkSpeed;
    public float units;
    public bool moveStorm;
    public bool raiseLava;
    public bool thunderStrong;
    public bool thunderWeak;

}
