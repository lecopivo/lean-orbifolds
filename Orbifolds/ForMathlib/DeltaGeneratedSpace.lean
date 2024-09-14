import Mathlib.Topology.ContinuousFunction.Basic
import Mathlib.Topology.Instances.Real

/-!
# Delta-generated topological spaces

This file defines delta-generated spaces, as topological spaces whose topology is coinduced by all
maps from euclidean spaces into them. Categorical properties are shown in `DeltaGenerated.lean`.

See https://ncatlab.org/nlab/show/Delta-generated+topological+space.

Adapted from `Mathlib.Topology.Compactness.CompactlyGeneratedSpace`.
-/

universe u v

open TopologicalSpace Topology

/-- The topology coinduced by all maps from ℝⁿ into a space. -/
def TopologicalSpace.deltaGenerated (X : Type u) [TopologicalSpace X] : TopologicalSpace X :=
  ⨆ f : (n : ℕ) × C(((Fin n) → ℝ),X), coinduced f.2 inferInstance

/-- The topology coinduced by a map out of a sigma type is the surpremum of the topologies
  coinduced by its components.
  Probably should go into mathlib; `induced_to_pi` is already there. -/
lemma coinduced_sigma {ι Y : Type u} {X : ι → Type v} [tX : (i : ι) → TopologicalSpace (X i)]
    (f : (i : ι) → X i → Y) : coinduced (fun x : (i : ι) × X i => f x.1 x.2) inferInstance =
    ⨆ i : ι, coinduced (f i) inferInstance := by
  rw [instTopologicalSpaceSigma,coinduced_iSup]; rfl

/-- The delta-generated topology is also coinduced by a single map out of a sigma type. -/
lemma deltaGenerated_eq_coinduced {X : Type u} [t : TopologicalSpace X] :
    deltaGenerated X = coinduced
    (fun x : (f : (n : ℕ) × C(((Fin n) → ℝ),X)) × ((Fin f.1) → ℝ) => x.1.2 x.2)
    inferInstance := by
  rw [deltaGenerated,←coinduced_sigma]

/-- The delta-generated topology is at least as fine as the original one. -/
lemma deltaGenerated_le {X : Type u} [t : TopologicalSpace X] : deltaGenerated X ≤ t :=
  iSup_le_iff.mpr fun f => f.2.continuous.coinduced_le

lemma isOpen_deltaGenerated_iff {X : Type u} [t : TopologicalSpace X] {u : Set X} :
    IsOpen[deltaGenerated X] u ↔ ∀ (n : ℕ) (p : C(((Fin n) → ℝ),X)), IsOpen (p ⁻¹' u) := by
  simp_rw [deltaGenerated,isOpen_iSup_iff,isOpen_coinduced,Sigma.forall]

/-- A map from ℝⁿ to X is continuous iff it is continuous regarding the
  delta-generated topology on X. -/
lemma continuous_to_deltaGenerated {X : Type u} [t : TopologicalSpace X] {n : ℕ}
    {f : ((Fin n) → ℝ) → X} : Continuous[_,deltaGenerated X] f ↔ Continuous f := by
  simp_rw [continuous_iff_coinduced_le]
  refine' ⟨fun h => h.trans deltaGenerated_le,fun h => _⟩
  simp_rw [deltaGenerated]
  exact le_iSup_of_le (i := ⟨n,f,continuous_iff_coinduced_le.mpr h⟩) le_rfl

lemma deltaGenerated_deltaGenerated_eq {X : Type u} [t : TopologicalSpace X] :
    @deltaGenerated X (deltaGenerated X) = deltaGenerated X := by
  ext u; simp_rw [isOpen_deltaGenerated_iff]; refine' forall_congr' fun n => _
  -- somewhat awkward because `ContinuousMap` doesn't play well with multiple topologies.
  refine' ⟨fun h p => h <| @ContinuousMap.mk (Fin n → ℝ) X _ (deltaGenerated X) p <|
      continuous_to_deltaGenerated.mpr p.2,
    fun h p => h ⟨p,continuous_to_deltaGenerated.mp <|
      @ContinuousMap.continuous_toFun _ _ _ (deltaGenerated X) p⟩⟩

/-- A space is delta-generated if its topology is equal to the delta-generated topology, i.e.
  coinduced by all continuous maps ℝⁿ → X. Since the delta-generated topology is always finer
  than the original one, it suffices to show that it is also coarser. -/
class DeltaGeneratedSpace (X : Type u) [t : TopologicalSpace X] : Prop where
  le_deltaGenerated : t ≤ deltaGenerated X

variable {X : Type u} [t : TopologicalSpace X]

lemma eq_deltaGenerated [DeltaGeneratedSpace X] : t = deltaGenerated X :=
  eq_of_le_of_le DeltaGeneratedSpace.le_deltaGenerated deltaGenerated_le

namespace DeltaGeneratedSpace

lemma isOpen_iff [DeltaGeneratedSpace X] {u : Set X} : IsOpen u ↔
    ∀ (n : ℕ) (p : ContinuousMap ((Fin n) → ℝ) X), IsOpen (p ⁻¹' u) := by
  nth_rewrite 1 [eq_deltaGenerated (X := X)]; exact isOpen_deltaGenerated_iff

/-- Type synonym to be equipped with the delta-generated topology. -/
def of (X : Type u) [TopologicalSpace X] : Type u := X

instance : TopologicalSpace (of X) := deltaGenerated X

instance : DeltaGeneratedSpace (of X) :=
  ⟨le_of_eq deltaGenerated_deltaGenerated_eq.symm⟩

/-- The natural map from the delta-generification of `X` to `X`. -/
def counit : (of X) → X := id

/-- The delta-generification counit is continuous. -/
lemma continuous_counit : Continuous (counit : _ → X) := by
  rw [continuous_iff_coinduced_le]; exact deltaGenerated_le

end DeltaGeneratedSpace
