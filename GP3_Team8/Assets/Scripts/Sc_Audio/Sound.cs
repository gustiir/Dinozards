﻿using UnityEngine;
using UnityEngine.Audio;

[System.Serializable]
public class Sound
{
    public string name;

    public AudioClip clip;

    [Range(0f,1f)]
    public float volume;
    [Range(0f,3f)]
    public float pitch = 1f;

    public bool loop;

    public bool isSoundTrack;

    [HideInInspector]
    public AudioSource source;

}
