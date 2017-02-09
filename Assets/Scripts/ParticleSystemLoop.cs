using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(ParticleSystem))]
public class ParticleSystemLoop : MonoBehaviour 
{
	private void Awake()
	{
		ParticleSystem particle = GetComponent<ParticleSystem>();
		particle.Play();
		ParticleSystem.MainModule main = particle.main;
		main.loop = true;
	}
}
