Require Import Sets.
Require Import Equality.
Require Import List Modal_Library Modal_Notations Deductive_System.
Import ListNotations.

Lemma modal_ax1:
  forall (S: axiom -> Prop) g A B,
  S (ax1 A B) ->
  (S; g |-- A) -> (S; g |-- [! B -> A !]).
Proof.
  intros.
  eapply Mp.
  - apply Ax with (a := ax1 A B).
    + assumption.
    + reflexivity.
  - assumption.
Defined.

Lemma modal_ax2:
  forall (S: axiom -> Prop) g A B C,
  S (ax2 A B C) ->
  (S; g |-- [! A -> B -> C !]) ->
  (S; g |-- [! A -> B !]) ->
  (S; g |-- [! A -> C !]).
Proof.
  intros S g a b c H H1 H2.
  assert (S; g |-- [! (a -> b -> c) -> (a -> b) -> a -> c !]).
  - apply Ax with (a := ax2 a b c).
    + assumption.
    + reflexivity.
  - assert (S; g |-- [! (a -> b) -> a -> c !]).
    + eapply Mp.
      * exact H0.
      * assumption.
    + eapply Mp.
      * exact H3.
      * assumption.
Defined.

Lemma modal_ax5:
  forall (S: axiom -> Prop) g A B,
  S (ax5 A B) ->
  (S; g |-- [! A /\ B !]) -> (S; g |-- A).
Proof.
  intros.
  assert (S; g |-- Implies (And A B) A).
  - apply Ax with (a := ax5 A B).
    + assumption.
    + reflexivity.
  - eapply Mp.
    + apply H1.
    + assumption.
Defined.

Lemma modal_ax6:
  forall (S: axiom -> Prop) g A B,
  S (ax6 A B) ->
  (S; g |-- [! A /\ B !]) -> (S; g |-- B).
Proof.
  intros.
  assert (S; g |-- Implies (And A B) B).
  - apply Ax with (a := ax6 A B).
    + assumption.
    + reflexivity.
  - eapply Mp.
    + apply H1.
    + assumption.
Defined.

Lemma modal_compose:
  forall (S: axiom -> Prop) g A B C,
  S (ax1 [! B -> C !] A) ->
  S (ax2 A B C) ->
  (S; g |-- [! A -> B !]) ->
  (S; g |-- [! B -> C !]) ->
  (S; g |-- [! A -> C !]).
Proof.
  intros S g a b c ?H ?H H1 H2.
  assert (S; g |-- [! a -> b -> c !]).
  - eapply modal_ax1.
    + assumption.
    + assumption.
  - eapply modal_ax2.
    + eassumption.
    + exact H3.
    + exact H1.
Defined.

Lemma modal_axK:
  forall (S: axiom -> Prop) g A B,
  S (axK A B) ->
  (S; g |-- [! [](A -> B) !]) -> (S; g |-- [! []A -> []B !]).
Proof.
  intros.
  eassert (S; g |-- Implies ?[X] ?[Y]).
  - apply Ax with (a := axK A B).
    + assumption.
    + reflexivity.
  - eapply Mp.
    + apply H1.
    + assumption.
Defined.

Lemma modal_axK4:
  forall (S: axiom -> Prop) g A,
  S (axK4 A) ->
  (S; g |-- [! []A -> [][]A !]).
Proof.
  intros.
  apply Ax with (a := axK4 A).
  - assumption.
  - reflexivity.
Defined.

Lemma modal_impl_transitivity:
  forall M a b c,
  (M |= [! a -> b !]) /\ (M |= [! b -> c !]) ->
  (M |= [! a -> c !]).
Proof.
  intros M a b c [H1 H2] w H3.
  apply H2; apply H1; assumption.
Defined.

Lemma modal_deduction:
  forall A g p q,
  Subset K A ->
  (A; Union (Singleton p) g |-- q) ->
  (A; g |-- [! p -> q !]).
Proof.
  intros.
  dependent induction H0.
  - destruct H0.
    + dependent destruction H0.
      apply derive_identity.
      assumption.
    + apply modal_ax1.
      * apply H.
        apply K_ax1.
      * constructor 1.
        assumption.
  - apply modal_ax1.
    + apply H.
      apply K_ax1.
    + econstructor 2.
      * eassumption.
      * reflexivity.
  - eapply modal_ax2.
    + apply H.
      apply K_ax2.
    + apply IHdeduction1.
      * assumption.
      * reflexivity.
    + apply IHdeduction2.
      * assumption.
      * reflexivity.
  - apply modal_ax1.
    + apply H.
      apply K_ax1.
    + constructor 4.
      assumption.
Qed.

Lemma deduction_subset:
  forall A G1 G2,
  Subset G1 G2 ->
  forall p,
  deduction A G1 p -> deduction A G2 p.
Proof.
  induction 2.
  - constructor 1.
    apply H.
    assumption.
  - econstructor 2.
    + eassumption.
    + assumption.
  - econstructor 3.
    + apply IHdeduction1.
      assumption.
    + apply IHdeduction2.
      assumption.
  - econstructor 4.
    assumption.
Qed.
