using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class Test_DustPuff : MonoBehaviour 
{
	public GameObject target;

	private void OnCollisionEnter(Collision collision)
	{
		Vector3 position;
		Vector3 normal;
		GetContactAverages(collision.contacts, out position, out normal);

		target.transform.position = position;
		target.transform.up = normal;
		ParticleSystem[] particles = target.GetComponentsInChildren<ParticleSystem>();

		foreach (ParticleSystem particle in particles)
		{
			particle.Play();
		}
	}

	private void GetContactAverages(ContactPoint[] contacts, out Vector3 position, out Vector3 normal)
	{
		position = Vector3.zero;
		normal = Vector3.zero;
		foreach (ContactPoint contact in contacts)
		{
			position += contact.point;
			normal += contact.normal;
		}
		position /= contacts.Length;
		normal /= contacts.Length;
	}
}
