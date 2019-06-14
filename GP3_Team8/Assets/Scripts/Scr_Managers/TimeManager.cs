using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimeManager : MonoBehaviour {
    
    public void SlowDownTime(float timeScale, float duration) {

        StartCoroutine(SlowDownTimeCoroutine(timeScale, duration));
    }
    
    private IEnumerator SlowDownTimeCoroutine (float timeScale, float duration) {

        Time.timeScale = timeScale;

        yield return new WaitForSecondsRealtime(duration);

        //yield return new WaitForSeconds(duration);

        Time.timeScale = 1f;
    }
}
