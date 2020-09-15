Given that the nature of the contract as an artwork.
Given that the contract does not store ETH and is not intended to receive to funds.
Given that the contract is meant to be manipulated by users with aesthetic opinions, which can exceed or conflict with expectations.
The security of this contract is not particularly relevant.

That said, the contract should: 
remain usable forever,
give appropriate credit to poem generators,
delete poems only when overwriting them.


Re-entrancy attacks are impossible because the contract does not delegate calls outside of itself.

Integer overflow attacks are impossible because there is no addition, subtraction, multiplication or division performed by the contract.

There is an attack on the timestamp dependance. This contract sources an arbitrary poem for splicing by taking the modulus of the timestamp. 
If a miner really wanted to evolve their selected poem with a particular mate, they could modify the timestamp slightly. 
Given that there is no incentive outside of aesthetic accomplishment, I do not see any harm that can come from this.

There is an attack on the poem business logic in general. The original Darwinian Poetry gave users only two poems to choose from. 
In the case of Universe, the code provides two poems to consider, but ultimately, the user can select neither and provide two other indices to evolve.
While I contemplated fighting this attack through a variety of complex mechanisms, I ultimately decided that Darwinian Poetry was similarly attackable. 
Users could refuse to select either poem and simply refresh the page until the pairing was one they liked.

Forcibly sending Ether to this contract will result in it being lost. There is no reason to expect this attack, as it would have no impact on the contract. 
