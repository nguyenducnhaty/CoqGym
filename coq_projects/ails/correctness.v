(* This program is free software; you can redistribute it and/or      *)
(* modify it under the terms of the GNU Lesser General Public License *)
(* as published by the Free Software Foundation; either version 2.1   *)
(* of the License, or (at your option) any later version.             *)
(*                                                                    *)
(* This program is distributed in the hope that it will be useful,    *)
(* but WITHOUT ANY WARRANTY; without even the implied warranty of     *)
(* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the      *)
(* GNU General Public License for more details.                       *)
(*                                                                    *)
(* You should have received a copy of the GNU Lesser General Public   *)
(* License along with this program; if not, write to the Free         *)
(* Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA *)
(* 02110-1301 USA                                                     *)


Require Import Bool.
Require Import Reals.
Require Import trajectory_const.
Require Import trajectory_def.
Require Import constants.
Require Import ycngftys.
Require Import ycngstys.
Require Import ails_def.
Require Import math_prop.
Require Import tau.
Require Import ails.
Require Import trajectory.
Require Import measure2state.
Require Import ails_trajectory.
Require Import alarm.
Require Import alpha_no_conflict.

Unset Standard Proposition Elimination Names.

(***********************************************************)
(************************ THEOREMS *************************)
(***********************************************************)

Theorem ails_alarm_at_alerting_distance :
 forall (intr : Trajectory) (evad : EvaderTrajectory),
 (d intr evad <= AlertRange)%R ->
 ails_alert (measure2state intr 0) (measure2state (tr evad) 0).
Proof with trivial.
intros; apply alarm_at_alerting_distance...
Qed.

Theorem ails_alarm_when_conflict :
 forall (intr : Trajectory) (evad : EvaderTrajectory) (T : TimeT),
 h intr = V ->
 h (tr evad) = V ->
 (AlertRange < d intr evad)%R ->
 conflict intr evad T = true ->
 ails_alert (measure2state intr 0) (measure2state (tr evad) 0).
Proof with trivial.
intros; cut (Die intr evad T T <= ConflictRange)%R...
intro...
case (Rle_dec (l intr evad T) (MaxDistance T)); intro...
case (Rle_dec (MinDistance T) (l intr evad T)); intro...
cut (Omega (beta intr evad T + thetat intr 0) = false)...
intro; apply (ails_alarm_tau_gt0 intr evad T)...
case (Rle_dec (tau (measure2state intr 0) (measure2state (tr evad) 0) 0) 0);
 intro...
rewrite Rplus_comm in H4;
 generalize (ails_no_conflict_tau_le0 intr evad T H H0 r0 r H1 H4 r1); 
 intro; rewrite H5 in H2; elim diff_false_true...
auto with real...
cut
 (Omega (beta intr evad T + thetat intr 0) = false \/
  Omega (beta intr evad T + thetat intr 0) = true)...
intro; elim H4; intro...
cut (ConflictRange + vi intr < l intr evad T)%R...
cut (rho_vi intr * T <= PI - rho_vi intr)%R...
intros; generalize (no_conflict_Omega intr evad T H7 H6 H5); intro;
 rewrite H8 in H2; elim diff_false_true...
apply Rplus_le_reg_l with (rho_vi intr)...
replace (rho_vi intr + (PI - rho_vi intr))%R with PI...
cut (rho_vi intr <= rho_vi intr * T)%R...
intro; apply Rle_trans with (rho_vi intr * T + rho_vi intr * T)%R...
apply Rplus_le_compat_r...
cut (rho_vi intr * T <= PI / 2)%R...
intro; rewrite (double_var PI);
 apply Rle_trans with (rho_vi intr * T + PI / 2)%R...
apply Rplus_le_compat_l...
apply Rplus_le_compat_r...
left; replace (rho_vi intr) with rho_V...
apply rho_t_PI2...
unfold rho_V, rho_vi in |- *; unfold vi in |- *; rewrite H...
pattern (rho_vi intr) at 1 in |- *; rewrite <- (Rmult_1_r (rho_vi intr));
 apply rho_t_le; left; apply Rlt_le_trans with MinT...
unfold MinT in |- *; unfold MaxT, tstep in |- *;
 apply Rmult_lt_reg_l with 2%R...
prove_sup...
rewrite Rmult_1_r; rewrite Rmult_minus_distr_l...
rewrite <- Rinv_r_sym; [ prove_sup | discrR ]...
apply (cond_1 T)...
ring...
apply Rlt_le_trans with (MinDistance T)...
apply Rlt_le_trans with MinDistance_lb...
replace (vi intr) with V...
rewrite Rplus_comm...
apply MinDistance_lb_majoration...
apply MinDistance_lb_0...
unfold Omega in |- *;
 case (Rle_dec (PI / 2) (beta intr evad T + thetat intr 0)); 
 intro...
case (Rle_dec (beta intr evad T + thetat intr 0) (3 * (PI / 2))); intros...
right...
left...
left...
cut (l intr evad T < MinDistance T)%R...
cut (0 <= rho_vi intr * T)%R...
cut (rho_vi intr * T < 2)%R...
intros; unfold MinDistance in H4; unfold m in H4...
cut (r_V = r_vi intr)...
cut (rho_V = rho_vi intr)...
intros; unfold MinDistance in H6; unfold m in H6...
rewrite H8 in H6; rewrite H7 in H6...
generalize (no_conflict_lt_min intr evad T H5 H4 H6); intro...
rewrite H9 in H2...
elim diff_false_true...
unfold rho_V, rho_vi in |- *; unfold vi in |- *; rewrite H...
unfold r_V, r_vi in |- *; unfold vi in |- *; rewrite H...
replace (rho_vi intr) with rho_V...
apply rho_t_2...
unfold rho_V, rho_vi in |- *; unfold vi in |- *; rewrite H...
left; apply Rmult_lt_0_compat...
unfold rho_vi in |- *; apply rrho.rho_pos...
apply Rlt_le_trans with MinT...
apply MinT_is_pos...
apply (cond_1 T)...
auto with real...
cut (MaxDistance T < l intr evad T)%R...
intro; unfold MaxDistance in H4; cut (V = vi intr)...
intro; rewrite H5 in H4...
generalize (no_conflict_gt_max intr evad T H4); intro...
rewrite H6 in H2...
elim diff_false_true...
symmetry  in |- *; unfold vi in |- *; rewrite H...
auto with real...
apply (conflict_T_e_0 intr evad T)...
Qed.

Theorem ails_correctness :
 forall (intr : Trajectory) (evad : EvaderTrajectory) (T : TimeT),
 h intr = V ->
 h (tr evad) = V ->
 conflict intr evad T = true ->
 ails_alert (measure2state intr 0) (measure2state (tr evad) 0).
Proof with trivial.
intros; case (Rle_dec (d intr evad) AlertRange); intro;
 [ apply (ails_alarm_at_alerting_distance _ _ r)
 | cut (AlertRange < d intr evad)%R;
    [ intro; apply (ails_alarm_when_conflict intr evad T) | auto with real ] ]...
Qed.
