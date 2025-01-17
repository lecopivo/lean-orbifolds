# Orbifolds in Lean

This project aims to formalise some of the basic theory of orbifolds and other generalised smooth spaces in lean. A first goal is to develop the theory of diffeological spaces to a point where orbifolds can be defined and reasoned about as special diffeological spaces; after that the focus will probably shift more towards proving theorems about orbifolds, or maybe even building up a theory of Lie groupoids to the point where orbifolds can be defined in terms of them too.

So far this is mostly following Patrick Iglesias-Zemmour's book "Diffeology" - I will list more references here when I use them. The API is also in large parts adapted from mathlib's topology API, since there is a lot of similarities at least in the basic theory.

## Current implementation status
- Diffeological Spaces:
	- Constructions:
		- [x] Diffeology generated by a family of functions
		- [x] Arbitrary joins and meets of diffeologies
		- [x] Pushforwards and pullbacks of diffeologies
		- [x] Subspace diffeologies
		- [x] Quotient diffeologies
		- [x] Binary product diffeologies
		- [ ] Product diffeologies
		- [ ] Binary coproduct diffeologies
		- [ ] Coproduct diffeologies
		- [x] Mapping spaces
		- [x] D-topology
		- [x] Continuous diffeology
	- Maps:
		- [x] Smooth maps
		- [x] Inductions & subductions
		- [x] Diffeomorphisms
	- Types of diffeological spaces:
		- [x] Diffeological groups
		- [ ] Diffeological vector spaces
		- [ ] Diffeological manifolds
		- [ ] Orbifolds as diffeological spaces
	- Other spaces as diffeological spaces:
		- [x] Finite-dimensional vector spaces
		- [ ] Normed or Banach spaces
		- [ ] Manifolds, maybe ones with boundary & corners too
	- Abstract nonsense:
		- [x] Category of diffeological spaces
		- [x] Completeness and Cocompleteness of that category
		- [x] Cartesian-closedness of that category
		- [x] Forgetful functor and related adjunctions
		- [x] D-topology functor and adjunction
		- [x] Category of smooth sets as sheaf topos on `CartSp`
		- [x] Embedding of diffeological spaces into that
		- [ ] Alternative characterisations via `EuclOp` etc.