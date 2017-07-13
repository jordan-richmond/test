/***
Disruption Figures - Heterogeneity by Age at Move:
	1) Kid Outcomes for 1 time movers by age at move and parent quintile
	2) Kid outcome for diff # of moves (within a cohort) by age at move and parent income quintile
	3) XX FIX
***/

global jordan "${dropbox}\movers\analysis\jordan"
global disrupt "${dropbox}\disrupt"
global clps "${disrupt}\collapse"
global dgraph "${disrupt}\graphs"
global dmaps "${disrupt}\maps"
global ffigs "${disrupt}\slides\figures_4_13_17"
global mvdata "${dropbox}\movers\analysis\beta\beta_complete_final"

clear
set more off
local geo zip5


* 1 Time Movers
use ${clps}/new/`geo'/aam/kr_1mv_byaam_bycoh_mskd, clear
g par_quint =.
replace par_quint = 1 if par_pct <=20
replace par_quint = 2 if par_pct > 20 & par_pct <=40
replace par_quint = 3 if par_pct > 40 & par_pct <=60
replace par_quint = 4 if par_pct > 60 & par_pct <=80
replace par_quint = 5 if par_pct > 80 & par_pct <=100

*foreach age in 26 30 {
foreach age in 26 {
	preserve
	collapse (mean)kid_rank_`age'=kid_rank_`age' (rawsum)num_obs=num_obs [w=num_obs], by(par_quint aa_move_zip5_18)

	* 1) Kid Outcomes for 1 time movers by age at move and parent quintile
	* Fewer obs for younger aam b/c can observe that for fewer cohorts
	twoway ///
	(connected kid_rank_`age' aa_move_zip5_18_1 if par_quint == 1) ///
	(connected kid_rank_`age' aa_move_zip5_18_1 if par_quint == 2) ///
	(connected kid_rank_`age' aa_move_zip5_18_1 if par_quint == 3) ///
	(connected kid_rank_`age' aa_move_zip5_18_1 if par_quint == 4) ///
	(connected kid_rank_`age' aa_move_zip5_18_1 if par_quint == 5), /// 
	title("Disruption Effects by Age at Move") ///
	xtitle("Age at Move") ytitle("Mean Child Rank in National Income Distribution at Age `age'") ///
	yscale(range(.3 .6)) ylabel(.3(.05).6) xscale(range(11 18)) xlabel(11(1)18) ///
	legend(order(1 2 3 4 5) c(2) ring(0) pos(6) region(color(none)) ///
	lab(1 "ParQ 1") lab(2 "ParQ 2") lab(3 "ParQ 3") lab(4 "ParQ 4") lab(5 "ParQ 5"))
	graph export ${disrupt}/figures/`geo'/aam/dis_kr`age'_byaam.wmf, replace
	restore
}





* All Movers
local geo zip5
use ${clps}/new/`geo'/aam/kr26_allmv_byaam_bycoh_mskd, clear
g par_quint =.
replace par_quint = 1 if par_pct <=20
replace par_quint = 2 if par_pct > 20 & par_pct <=40
replace par_quint = 3 if par_pct > 40 & par_pct <=60
replace par_quint = 4 if par_pct > 60 & par_pct <=80
replace par_quint = 5 if par_pct > 80 & par_pct <=100

* 2) Restrict to specific cohort and specific number of moves
foreach movenum in 1 2 3 4 {
forval coh= 1982(1)1986 {
	di in red "MOVENUM = `movenum' and COHORT = `coh'" 
	preserve
	keep if cohort == `coh'
	keep if total_moves_zip5_18 == `movenum'
	collapse (mean)kid_rank_26=kid_rank_26 (rawsum)num_obs=num_obs [w=num_obs], by(par_quint aa_move_zip5_18_1)

	twoway ///
	(connected kid_rank_26 aa_move_zip5_18_1 if par_quint == 1) ///
	(connected kid_rank_26 aa_move_zip5_18_1 if par_quint == 2) ///
	(connected kid_rank_26 aa_move_zip5_18_1 if par_quint == 3) ///
	(connected kid_rank_26 aa_move_zip5_18_1 if par_quint == 4) ///
	(connected kid_rank_26 aa_move_zip5_18_1 if par_quint == 5), /// 
	title("AAM Heterogeneity for `movenum'x Movers in `coh' cohort") ///
	xtitle("Age at First Move") ytitle("Mean Child Rank in National Income Distribution at Age 26") ///
	yscale(range(.3 .6)) ylabel(.3(.05).6) ///
	legend(order(1 2 3 4 5) c(5) pos(6) region(color(none)) ///
	lab(1 "ParQ 1") lab(2 "ParQ 2") lab(3 "ParQ 3") lab(4 "ParQ 4") lab(5 "ParQ 5"))
	graph export ${disrupt}/figures/`geo'/aam/dis_kr_byaam_`movenum'mv_coh`coh'.wmf, replace
	restore
}
}

* 3) What if people who move at younger ages are simply more likely to move again?
* 		Drop 0 time movers, just collapse on aam
local geo zip5
use ${clps}/new/`geo'/aam/kr_allmv_byaam_bycoh_mskd, clear
g par_quint =.
replace par_quint = 1 if par_pct <=20
replace par_quint = 2 if par_pct > 20 & par_pct <=40
replace par_quint = 3 if par_pct > 40 & par_pct <=60
replace par_quint = 4 if par_pct > 60 & par_pct <=80
replace par_quint = 5 if par_pct > 80 & par_pct <=100
drop if total_moves_zip5_18 == 0

/*
	local age 26
	collapse (mean)kid_rank_`age'=kid_rank_`age' (rawsum)num_obs=num_obs [w=num_obs], by(par_quint aa_move_zip5_18_1)
*/

foreach age in 26 30 {
	preserve
	collapse (mean)kid_rank_`age'=kid_rank_`age' (rawsum)num_obs=num_obs [w=num_obs], by(par_quint aa_move_zip5_18_1)
	twoway ///
	(connected kid_rank_`age' aa_move_zip5_18_1 if par_quint == 1) ///
	(connected kid_rank_`age' aa_move_zip5_18_1 if par_quint == 2) ///
	(connected kid_rank_`age' aa_move_zip5_18_1 if par_quint == 3) ///
	(connected kid_rank_`age' aa_move_zip5_18_1 if par_quint == 4) ///
	(connected kid_rank_`age' aa_move_zip5_18_1 if par_quint == 5), /// 
	title("AAM Heterogeneity for all movers 80-86 cohorts") ///
	xtitle("Age at First Move") ytitle("Mean Child Rank in National Income Distribution at Age `age'") ///
	yscale(range(.3 .6)) ylabel(.3(.05).6) ///
	legend(order(1 2 3 4 5) c(5) pos(6) region(color(none)) ///
	lab(1 "ParQ 1") lab(2 "ParQ 2") lab(3 "ParQ 3") lab(4 "ParQ 4") lab(5 "ParQ 5"))
	restore
}
