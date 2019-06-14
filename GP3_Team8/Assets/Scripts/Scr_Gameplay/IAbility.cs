using UnityEngine;

public interface IAbility
{
    int ManaCost();
    bool CanActivate();
    int OnActivate(GameObject instigator);
}
