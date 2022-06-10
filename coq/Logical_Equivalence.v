Require Import Modal_Library Modal_Notations Classical List.

Theorem implies_to_or_modal:
  forall φ ψ,
  [! φ -> ψ !] =|= [! ~φ \/ ψ !].
Proof.
  split.
  - unfold entails_modal in *. 
    intros; simpl in *.
    destruct H as (?,_). 
    unfold validate_model in *. 
    simpl in *; intros.
    edestruct classic.
    + exact H0.
    + right; apply H.
      apply not_or_and in H0.
      destruct H0 as (?, _);
      apply NNPP in H0; auto.
  - unfold entails_modal in *. 
    intros; simpl in *.
    destruct H as (?, _).
    unfold validate_model in *.
    simpl in *; intros.
    destruct H with w.
    + contradiction.
    + assumption. 
Qed.

Theorem double_neg_modal:
  forall φ,
  [! ~~φ !] =|= φ.
Proof.
  split.
  - unfold entails_modal.
    simpl in *.
    unfold validate_model.
    intros.
    destruct H as (?, _).
    simpl in *.
    apply NNPP; auto.
  - unfold entails_modal.
    simpl in *.
    unfold validate_model.
    intros; simpl in *.
    destruct H as (?, _).
    edestruct classic.
    + exact H0.
    + apply NNPP in H0.
      exfalso; eauto.
Qed.

Theorem and_to_implies_modal:
  forall φ ψ,
  [! φ /\ ψ !] =|= [! ~(φ -> ~ψ) !].
Proof.
  split.
  - unfold entails_modal, validate_model.
    simpl in *; intros.
    unfold validate_model in *.
    simpl in *.
    destruct H as (?, _).
    unfold not; intros; apply H0.
    + destruct H with (w:=w); auto.
    + destruct H with (w:=w); auto.
  - unfold entails_modal.
    simpl in *; intros.
    unfold validate_model in *.
    intros; simpl in *.
    destruct H as (?, _).
    split.
    + edestruct classic.
      * exact H0.
      * exfalso. unfold not in H.
      apply H with (w:=w). intros;
      contradiction.
    + edestruct classic.
      * exact H0.
      * exfalso; unfold not in H;
        apply H with (w:=w). 
        intros; contradiction. 
Qed.

Theorem diamond_to_box_modal:
  forall φ,
  [! <>φ !] =|= [! ~[]~φ !].
Proof.
  split.
  - unfold entails_modal, validate_model in *.
    simpl in *; intros.
    destruct H as (?, _).
    unfold validate_model in H; simpl in H.
    edestruct classic.
    + exact H0.
    + unfold not; intros. 
      destruct H with (w:=w). 
      apply H1 with (w':=x).
      destruct H2; auto.
      destruct H2; auto.
  - intros. unfold entails_modal in *.
    simpl in *.
    unfold validate_model in *.
    simpl in *. 
    unfold not in *.
    intros.
    destruct H as (?, _).
    edestruct classic.
    + exact H0.
    + exfalso; apply H with (w:=w);
      intros.
      apply H0; exists w';
      split; auto; auto.
Qed.