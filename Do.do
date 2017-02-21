log using "trabajo 1.log", append
import excel "Base1.xls", sheet("base1") firstrow
codebook 
save "base1.dta"
clear
import delimited "Base2.csv", encoding(ISO-8859-1)
codebook
save "base2.dta"
clear
use "base1.dta"
append using "base2.dta", nolabel
save "basefinal.dta"
codebook
gen fnac = date(var7, "DMY")
format %d fnac
merge 1:1 var1 using "Base3.dta"
codebook
save "basefinal.dta", replace
gen fexam = date(var9, "DMY")
format %d fexam
label variable var1 "Identificación Paciente"
rename var1 id
label variable var2 "Sexo"
rename var2 sex
label variable var3 "Tipo de dolor"
rename var3 tdolor
label variable var4 "Presión Sistolica mmHg"
rename var4 presis
label variable var5 "Colesterol mg/dl"
rename var5 colest
label variable var6 "Resultados Electrocardiograma"
rename var6 reselect
label variable var7 "Fecha de nacimiento sin modificiar"
rename var7 fnacs
label variable fnac "Fecha de Nacimiento"
label variable var8 "Diagnóstico Coronario"
rename var8 dxcor
label variable var9 "Fecha de examen sin modificar"
rename var9 fexams
label variable fexam "Fecha examen angiografico"
label define sexo 0 "Femenino" 1 "Masculino"
label define Tipodolor 1 "Angina típica" 2 "Angina atípica" 3 "No angina" 4 "Asintomático"
label define Resultadoselect 0 "Normal" 1 "Anormalidad segmento ST-T" 2 "Hipertrofia probable o definitiva ventriculo izquierdo"
label define Diagnóstico 0 "menor 50% estrechamiento diametro" 1 "mayor 50% estrechamiento diametro"
label values sex sexo
label values tdolor Tipodolor
label values reselect Resultadoselect
label values dxcor Diagnóstico
codebook sex tdolor reselect dxcor
 gen presis2 = presis
browse presis2
save "basefinal.dta", replace
codebook presis2
browse presis2
destring presis2, generate(presis3) force float
codebook presis3
egen float presis4 = cut(presis3), at(1 90 130 140 160 180 500) icodes
codebook presis4
browse presis3 presis4
tab presis3
codebook presis4
label variable presis4 "Presión Sistólica Categorizada"
label define presis4 0 "Hipotensión < 90 mmHg" 1 "Deseada/Normal 90-129 mmHg" 2 "Prehipertensión 130-139 mmHg" 3 "Hipertensión Grado1 140-159 mmHg" 4 "Hipertensión Grado2 160-179 mmHg" 5 "Crisis Hipertensiva >180 mmHg", replace
label values presis4 presis4
codebook presis4
gen año = ((fexam - fnac)/ 365.25)
codebook año
drop año
gen años = ((fexam - fnac)/ 365.25)
codebook años
browse años
browse fnac fexam años
codebook fnac fexam años
browse fnac fexam años
tabulate sex
mean años
histogram años, bin(10)
graph save Graph "Graph años.gph", replace
histogram sex, discrete percent addlabel
graph save Graph "Graph sexo.gph", replace
tabulate tdolor dxcor, chi2 column
