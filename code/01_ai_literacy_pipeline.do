clear
cd "C:\Users\ilayd\Desktop\Proje3"
import delimited "useofai.csv", varnames(1) clear
describe
list in 1/10
keep if freq == "Annual"
keep if ind_type == "All individuals"
keep if unit == "Percentage of individuals"
describe
keep if time_period == 2025
keep if freq == "Annual"
keep if ind_type == "All individuals"
keep if unit == "Percentage of individuals"
list geo obs_value in 1/15
summ obs_value
tab indic_is
tab geo
keep if indic_is == "Use of generative AI tools: in the last 3 months"
count
list geo obs_value in 1/15
drop if strpos(geo,"European Union")>0
drop if strpos(geo,"Euro area")>0
count
rename obs_value ai_use_2025
keep geo ai_use_2025
save ai_use_clean.dta, replace
clear
import delimited "notuseofai.csv", varnames(1) clear
describe
keep if time_period == 2025
keep if freq == "Annual"
keep if ind_type == "All individuals"
keep if unit == "Percentage of individuals"
summ obs_value
tab indic_is
keep geo obs_value
collapse (mean) obs_value, by(geo)
rename obs_value barrier_index
list geo barrier_index in 1/15
summ barrier_index
drop if strpos(geo,"European Union")>0
drop if strpos(geo,"Euro area")>0
save barrier_index.dta, replace
use ai_use_clean.dta, clear
list in 1/10
encode geo, gen(geo_id)
drop geo
rename geo_id geo
use barrier_index.dta, clear
describe
encode geo, gen(geo_id)
drop geo
rename geo_id geo
save barrier_index.dta, replace
use ai_use_clean.dta, clear
encode geo, gen(geo_id)
drop geo
rename geo_id geo
merge 1:1 geo using barrier_index.dta
tab _merge
drop if _merge != 3
drop _merge
egen use_min = min(ai_use_2025)
egen use_max = max(ai_use_2025)
gen use_norm = (ai_use_2025 - use_min) / (use_max - use_min)
egen bar_min = min(barrier_index)
egen bar_max = max(barrier_index)
gen barrier_norm = (barrier_index - bar_min) / (bar_max - bar_min)
gen ai_literacy = use_norm - barrier_norm
gsort -ai_literacy
list geo ai_use_2025 barrier_index ai_literacy
summ ai_use_2025 barrier_index ai_literacy
graph bar ai_literacy, over(geo, sort(1) descending) ///
title("AI Literacy Index across Countries (2025)") ///
ytitle("Index value")
graph bar ai_literacy, over(geo, sort(1) descending) 
title("AI Literacy Index across Countries (2025)") 
ytitle("Index value")
graph hbar (mean) ai_literacy, over(geo, sort(1) descending label(labsize(small))) 
    title("AI Literacy Index by Country (2025)") 
    ytitle("AI Literacy (normalized)") ///
    name(ai_lit_hbar2, replace)
graph export "C:\Users\ilayd\Desktop\Graphliteracy.png", as(png) name("Graph")
corr ai_use_2025 barrier_index ai_literacy
pwcorr ai_use_2025 barrier_index ai_literacy, sig star(0.05)
scatter barrier_index ai_use_2025, ///
    xtitle("AI use (%)") ///
    ytitle("Barrier index")
scatter barrier_index ai_use_2025, 
    xtitle("AI use (%)") 
    ytitle("Barrier index")
graph export "C:\Users\ilayd\Desktop\Graphobsvalue.jpg", as(jpg) name("Graph") quality(100)
twoway (scatter barrier_index ai_use_2025) ///
       (lfit barrier_index ai_use_2025), ///
       xtitle("AI use (%)") ///
       ytitle("Barrier index")
twoway (scatter barrier_index ai_use_2025) 
       (lfit barrier_index ai_use_2025), 
       xtitle("AI use (%)") ///
twoway (scatter barrier_index ai_use_2025) 
reg barrier_index ai_use_2025
reg ai_use_2025 barrier_index
reg ai_literacy ai_use_2025 barrier_index
egen use_med = median(ai_use_2025)
egen bar_med = median(barrier_index)
gen typology = .
replace typology = 1 if ai_use_2025>=use_med & barrier_index<bar_med
replace typology = 2 if ai_use_2025>=use_med & barrier_index>=bar_med
replace typology = 3 if ai_use_2025<use_med & barrier_index<bar_med
replace typology = 4 if ai_use_2025<use_med & barrier_index>=bar_med
label define typ 1 "High use - Low barrier" ///
                 2 "High use - High barrier" ///
                 3 "Low use - Low barrier" ///
                 4 "Low use - High barrier"
label values typology typ
tab typology
egen use_med = median(ai_use_2025)
egen bar_med = median(barrier_index)
gen typology = .
replace typology = 1 if ai_use_2025>=use_med & barrier_index<bar_med
replace typology = 2 if ai_use_2025>=use_med & barrier_index>=bar_med
replace typology = 3 if ai_use_2025<use_med & barrier_index<bar_med
replace typology = 4 if ai_use_2025<use_med & barrier_index>=bar_med
label define typ 1 "High use - Low barrier" 
                 2 "High use - High barrier" 
                 3 "Low use - Low barrier" 
                 4 "Low use - High barrier"
label values typology typ
tab typology
sort typology
list geo ai_use_2025 barrier_index typology
collapse (mean) ai_use_2025 barrier_index, by(typology)
list
graph bar ai_use_2025 barrier_index, over(typology) ///
    legend(order(1 "AI use (%)" 2 "Barrier index")) ///
    title("Country typology based on AI use and barriers")
graph bar ai_use_2025 barrier_index, over(typology) 
    legend(order(1 "AI use (%)" 2 "Barrier index")) 
    title("Country typology based on AI use and barriers")
graph export "C:\Users\ilayd\Desktop\Graphaiuse_barrier.jpg", as(jpg) name("Graph") quality(100)
dir
use ai_use_clean.dta, clear
describe
use ai_use_clean.dta, clear
merge 1:1 geo using barrier_index.dta
gen geo2 = geo
drop geo
rename geo2 geo
merge 1:1 geo using barrier_index.dta
use barrier_index.dta, clear
describe
use barrier_index.dta, clear
tostring geo, replace
save barrier_index.dta, replace
use ai_use_clean.dta, clear
gen geo2 = geo
drop geo
rename geo2 geo
merge 1:1 geo using barrier_index.dta
tab _merge
use barrier_index.dta, clear
tostring geo, replace
describe
save barrier_index.dta, replace
use barrier_index.dta, clear
tostring geo, replace
describe
tostring geo, replace
restore
use barrier_index.dta, clear
decode geo, gen(geo_str)     
drop geo
rename geo_str geo
save barrier_index_string.dta, replace
use ai_use_clean.dta, clear
gen geo2 = geo              
drop geo
rename geo2 geo
merge 1:1 geo using barrier_index_string.dta
tab _merge
drop if _merge != 3
drop _merge
save ai_merged.dta, replace
use ai_merged.dta, clear
describe
egen use_min = min(ai_use_2025)
egen use_max = max(ai_use_2025)
gen use_norm = (ai_use_2025 - use_min)/(use_max-use_min)
egen bar_min = min(barrier_index)
egen bar_max = max(barrier_index)
gen barrier_norm = (barrier_index - bar_min)/(bar_max-bar_min)
gen ai_literacy = use_norm - barrier_norm
summ ai_literacy
egen use_med = median(ai_use_2025)
egen bar_med = median(barrier_index)
gen typology = .
replace typology = 1 if ai_use_2025>=use_med & barrier_index<bar_med
replace typology = 2 if ai_use_2025>=use_med & barrier_index>=bar_med
replace typology = 3 if ai_use_2025<use_med & barrier_index<bar_med
replace typology = 4 if ai_use_2025<use_med & barrier_index>=bar_med
label define typ 1 "High use - Low barrier" 
                 2 "High use - High barrier" 
                 3 "Low use - Low barrier" 
                 4 "Low use - High barrier"
label values typology typ
tab typology
label values typology typ
tab typology
label define typ 1 "High use - Low barrier" ///
                 2 "High use - High barrier" ///
                 3 "Low use - Low barrier" ///
                 4 "Low use - High barrier", replace
label values typology typ
tab typology
label define typ 1 "High use - Low barrier" 2 "High use - High barrier" 3 "Low use - Low barrier" 4 "Low use - High barrier", replace
label values typology typ
tab typology
sort typology
list geo ai_use_2025 barrier_index ai_literacy typology
bys typology: egen mean_lit = mean(ai_literacy)
bys typology: egen mean_use = mean(ai_use_2025)
bys typology: egen mean_bar = mean(barrier_index)
sort typology
list typology mean_lit mean_use mean_bar if _n==1 | typology!=typology[_n-1]
graph bar mean_lit, over(typology) ///
    title("Average AI Literacy by Country Typology") ///
    ytitle("Mean AI literacy")
graph bar mean_lit, over(typology) title("Average AI Literacy by Country Typology") ytitle("Mean AI literacy")
graph hbar mean_lit, over(typology, label(labsize(vsmall))) 
title("Average AI Literacy by Country Typology") 
ytitle("Mean AI literacy")
graph export "C:\Users\ilayd\Desktop\Graph1.jpg", as(jpg) name("Graph") quality(90)
pwcorr ai_use_2025 barrier_index ai_literacy, sig star(0.05)
twoway (scatter ai_literacy ai_use_2025) (lfit ai_literacy ai_use_2025), 
xtitle("AI use (%)") 
ytitle("AI Literacy")
graph export "C:\Users\ilayd\Desktop\Graph2.jpg", as(jpg) name("Graph") quality(100)
twoway (scatter ai_literacy barrier_index) (lfit ai_literacy barrier_index), 
xtitle("Barrier index") 
ytitle("AI Literacy")
graph export "C:\Users\ilayd\Desktop\Graph3.jpg", as(jpg) name("Graph") quality(100)
reg ai_literacy ai_use_2025
reg ai_literacy barrier_index
reg ai_literacy ai_use_2025 barrier_index
histogram ai_literacy, normal
graph export "C:\Users\ilayd\Desktop\Graph4.jpg", as(jpg) name("Graph") quality(100)
gsort -ai_literacy
list geo ai_literacy in 1/5
gsort ai_literacy
list geo ai_literacy in 1/5
log using "C:\Users\ilayd\Desktop\Untitled.smcl"
