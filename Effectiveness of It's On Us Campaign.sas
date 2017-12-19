ods html close; 
ods html ; 
ods listing;
libname consult "\\stat.ad.ncsu.edu\Redirect\xzhang38\Desktop\project"; 
/*Library was assigned for origional data*/ 
/*import data containing dummy variables */ 
proc import datafile="\\stat.ad.ncsu.edu\Redirect\xzhang38\Desktop\project\proj_data.xls" 
out=consult.firstweekdataraw
dbms=xls
replace; 
run;

data consult.firstweekdata;
set consult.firstweekdataraw;
if finished=1 and Q1 in ('1st year','2nd year', '3rd year','4th+ year',
'Continuing education student','Graduate Student');
run;

 /* 1. Seclect useful variables for analysis*/ 
/*******************************************************************************************************/ 
/*calcluate difference & combine datasets */ 
proc sql; 
create table consult.demographic as 
select Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q32,Q33,Q34,Q35
from consult.firstweekdata; 
quit;

proc sql;
create table consult.involvement as 
select Q47,Q54,Q48,Q10,Q52,Q53,Q12,Q13,Q11
from consult.firstweekdata; 
quit;


*For it's on us programs' program
*From Q26, this is perceptions_aware of programs' effectiveness;
proc sql;
create table consult.prog_perception_aware as 
select Q26_x1,Q26_x2,Q26_X3,Q26_x4,Q26_x5,Q26_X6,Q26_x7,Q26_x8,Q26_X9,Q26_x10,
Q26_x11,Q26_X12,Q26_x13,Q26_x14,Q26_x14_text
from consult.firstweekdata; 
quit;

*From Q27, this is perceptions_knowledge of programs' effectiveness;
proc sql;
create table consult.prog_perception_know as 
select Q27_x1,Q27_x2,Q27_X3,Q27_x4,Q27_x5,Q27_X6,Q27_x7,Q27_x8,Q27_X9,Q27_x10,
Q27_x11,Q27_X12,Q27_x13,Q27_x14,Q27_x14_text
from consult.firstweekdata; 


*From Q28, this is perceptions_skills of programs' effectiveness;
proc sql;
create table consult.prog_perception_skills as 
select Q28_x1,Q28_x2,Q28_X3,Q28_x4,Q28_x5,Q28_X6,Q28_x7,Q28_x8,Q28_X9,Q28_x10,
Q28_x11,Q28_X12,Q28_x13,Q28_x14,Q28_x14_text
from consult.firstweekdata; 
quit;


* For it's on us programs' marketing;
* Q36;
proc sql;
create table consult.market_perception_aware as 
select Q36_x1,Q36_x2,Q36_X3,Q36_x4,Q36_x5,Q36_X6,Q36_x7,Q36_x8,Q36_X9,Q36_x10,
Q36_x11,Q36_X12
from consult.firstweekdata; 
quit;

proc sql;
create table consult.market_perception_know as 
select Q37_x1,Q37_x2,Q37_X3,Q37_x4,Q37_x5,Q37_X6,Q37_x7,Q37_x8,Q37_X9,Q37_x10,
Q37_x11,Q37_X12
from consult.firstweekdata; 
quit;


proc sql;
create table consult.market_perception_skills as 
select Q38_x1,Q38_x2,Q38_X3,Q38_x4,Q38_x5,Q38_X6,Q38_x7,Q38_x8,Q38_X9,Q38_x10,
Q38_x11,Q38_X12
from consult.firstweekdata; 
quit;

* q21;
proc sql;
create table consult.broad_perception_aware as 
select Q21_x1,Q21_x2,Q21_X3,Q21_x4,Q21_x5,Q21_X6,Q21_x7,Q21_x8,Q21_X10,Q21_x10_text
from consult.firstweekdata; 
quit;

*q24;
proc sql;
create table consult.broad_perception_know as 
select Q24_x1,Q24_x2,Q24_X3,Q24_x4,Q24_x5,Q24_X6,Q24_x7,Q24_x8,Q24_X10,Q24_x10_text
from consult.firstweekdata; 
quit;

*q25;
proc sql;
create table consult.broad_perception_skills as 
select Q25_x1,Q25_x2,Q25_X3,Q25_x4,Q25_x5,Q25_X6,Q25_x7,Q25_x8,Q25_X10,Q25_x10_text
from consult.firstweekdata; 
quit;

*Q17;
proc sql;
create table consult.behavior_past as 
select Q17_1,Q17_2,Q17_3,Q17_4,Q17_5,Q17_6,Q17_7,Q17_8,Q17_9,Q17_10,
Q17_11,Q17_12,Q17_13,Q17_14,Q17_15,Q17_16,Q17_17,Q17_18,Q17_19
from consult.firstweekdata; 
quit;

*Q22;
proc sql;
create table consult.behavior_now as 
select Q22_1,Q22_2,Q22_3,Q22_4,Q22_5,Q22_6,Q22_7,Q22_8,Q22_9,Q22_10,
Q22_11,Q22_12,Q22_13,Q22_14,Q22_15,Q22_16,Q22_17,Q22_18,Q22_19
from consult.firstweekdata; 
quit;

data consult.behavior_past_score;
set consult.behavior_past;
array question(*) q17_1--q17_19;
do i=1 to 19;
question[i]=tranwrd(question[i],'Yes','1');
question[i]=tranwrd(question[i],'No','0');
question[i]=tranwrd(question[i],'Not Applicable','');
end;
*behavior_past_score=sum(of q17_1--q17_19);
run;

proc format;
value $score '5'='1'
            '4'='2'
			'3'='3'
			'2'='4'
			'1'='5';
run;



*Now I would like to deal with the behavior_now data;
data consult.behavior(drop=i);
set  consult.behavior_now;
*if _n_>=3;
ARRAY Q22(*) Q22_1 Q22_2 Q22_3 Q22_4 Q22_5 Q22_6 Q22_7 Q22_8 Q22_9 Q22_10 Q22_11 Q22_12
Q22_13 Q22_14 Q22_15 Q22_16 Q22_17 Q22_18 Q22_19;
do i=1 to 19;
*get the numeric answer;
Q22[i]=substr(Q22[i],1,1);
end;
Q22_1_new=input(put(Q22_1,$score.),1.);
Q22_9_new=input(put(Q22_9,$score.),1.);
drop Q22_1 Q22_9;
rename Q22_1_new=Q22_1 Q22_9_new=Q22_9;

*sum to get the total score;
high_risk=sum(of Q22_2,Q22_4,Q22_5);
intervention=sum(of Q22_6,Q22_8,Q22_11,Q22_12,Q22_13,Q22_14,Q22_15);
proactive=sum(of Q22_16,Q22_17,Q22_18,Q22_19);
low_risk= sum(of Q22_1, Q22_7, Q22_9, Q22_10);
run;

ods listing;
proc univariate data=consult.behavior;
var high_risk intervention proactive low_risk;
histogram high_risk intervention proactive low_risk;
*high-risk:12-high=1,low-12=0;
*intervention:28-high=1;
*proactibe:16-high;
*low_risk:16-high;
run;

proc sgplot data=consult.behavior;
histogram high_risk;
density high_risk;
title "High Rish Situation Score Distribution";
run;


proc format;
value score_high_risk 
      12<-high='1'
	  low-12='0';
value score_inter
      28<-high='1'
	  low-28='0';
value score_pro
      16<-high='1'
	  low-16='0';
	  value score_low_risk
      16<-high='1'
	  low-16='0';
run;

data consult.practise;
set consult.behavior;
format high_risk score_high_risk. intervention score_inter. proactive score_pro. low_risk score_low_risk.;
run;


data consult.practise_with_demo(keep=high_risk intervention proactive low_risk
Q8 Q9 Q2 Q34 Q33 Q32 Q3 Q4 Q1 rename=(Q32=age Q1=class_status Q2=school_type Q3=school_year Q4=school_size
Q33=race Q34=gender Q8=clubs Q9=leadership));
merge consult.practise consult.demographic;
run;

data consult.practise_with_demo;
set consult.practise_with_demo;
if leadership='' then  leadership=0;
else leadership=1;
if clubs='' then  clubs=0;
else clubs=1;
if gender not in('Woman or Female or Feminine','Man or Male or Masculine') then delete;
if school_type not in('Private','Public') then delete;
run;
proc format;
value $race
'White'='1'
other='0';
run;
* white vs non-white;
data consult.practise_with_demo_white;
set consult.practise_with_demo;
format race $race.;
run;

proc freq data=consult.practise_with_demo_white;
tables race*high_risk/chisq;
run;
proc freq data=consult.practise_with_demo_white;
tables race*intervention/chisq;
run;
proc freq data=consult.practise_with_demo_white;
tables race*proactive/chisq;
run;
proc freq data=consult.practise_with_demo_white;
tables race*low_risk/chisq;
run;



*class_status;
proc freq data=consult.practise_with_demo;
tables class_status*high_risk/chisq;
run;

proc freq data=consult.practise_with_demo;
tables class_status*intervention/chisq;
run;

proc freq data=consult.practise_with_demo;
tables class_status*proactive/chisq;
run;

666;
proc freq data=consult.practise_with_demo;
tables class_status*low_risk/chisq;
run; 

*school year;
proc freq data=consult.practise_with_demo;
tables school_year*high_risk/chisq;
run;

proc freq data=consult.practise_with_demo;
tables school_year*intervention/chisq;
run;

proc freq data=consult.practise_with_demo;
tables school_year*proactive/chisq;
run;

proc freq data=consult.practise_with_demo;
tables school_year*low_risk/chisq;
run; 


*school size;
proc freq data=consult.practise_with_demo;
tables school_size*high_risk/chisq;
run;

proc freq data=consult.practise_with_demo;
tables school_size*intervention/chisq;
run;

proc freq data=consult.practise_with_demo;
tables school_size*proactive/chisq;
run;

proc freq data=consult.practise_with_demo;
tables school_size*low_risk/chisq;
run; 


*gender;
*significant;
proc freq data=consult.practise_with_demo;
tables gender*high_risk/chisq;
run;

proc freq data=consult.practise_with_demo;
tables gender*intervention/chisq;
run;

*significant;
proc freq data=consult.practise_with_demo;
tables gender*proactive/chisq;
run;

proc freq data=consult.practise_with_demo;
tables gender*low_risk/chisq;
run; 

*race, highly unbalanced, might not be able to represent the general facts;
666;
proc freq data=consult.practise_with_demo;
tables race*high_risk/chisq;
run;

proc freq data=consult.practise_with_demo;
tables race*intervention/chisq;
run;

*marginal significant with p-value=0.07;
proc freq data=consult.practise_with_demo;
tables race*proactive/chisq;
run;

proc freq data=consult.practise_with_demo;
tables race*low_risk/chisq;
run; 



*school_type;
proc freq data=consult.practise_with_demo;
tables school_type*high_risk/chisq;
run;
   
proc freq data=consult.practise_with_demo;
tables school_type*intervention/chisq;
run;

*Significant;
proc freq data=consult.practise_with_demo;
tables school_type*proactive/chisq;
run;

proc freq data=consult.practise_with_demo;
tables school_type*low_risk/chisq;
run; 

*leadership--with higher scores in leader group but not significant;
proc freq data=consult.practise_with_demo;
tables leadership*high_risk/chisq;
run;
   
proc freq data=consult.practise_with_demo;
tables leadership*intervention/chisq;
run;

proc freq data=consult.practise_with_demo;
tables leadership*proactive/chisq;
run;

proc freq data=consult.practise_with_demo;
tables leadership*low_risk/chisq;
run; 

*clubs;
proc freq data=consult.practise_with_demo;
tables clubs*high_risk/chisq;
run;
   
proc freq data=consult.practise_with_demo;
tables clubs*intervention/chisq;
run;

proc freq data=consult.practise_with_demo;
tables clubs*proactive/chisq;
run;

proc freq data=consult.practise_with_demo;
tables clubs*low_risk/chisq;
run; 

*age;
proc freq data=consult.practise_with_demo;
tables age*high_risk/chisq;
run;
   
proc freq data=consult.practise_with_demo;
tables age*intervention/chisq;
run;

proc freq data=consult.practise_with_demo;
tables age*proactive/chisq;
run;

proc freq data=consult.practise_with_demo;
tables age*proactive/chisq;
run; 


***********************************************
*             Effectiveness of programs       *
***********************************************;
data consult.Prog_perception_aware;
set consult.Prog_perception_aware;
rename Q26_x1=x1 Q26_x2=x2 Q26_x3=x3 Q26_x4=x4
Q26_x5=x5 Q26_x6=x6 Q26_x7=x7 Q26_x8=x8 Q26_x9=x9 Q26_x10=x10 Q26_x11=x11 Q26_x12=x12
Q26_x13=x13 Q26_x14=x14;
drop Q26_x14_text;
run;

data consult.Prog_perception_know;
set consult.Prog_perception_know;
rename Q27_x1=x1 Q27_x2=x2 Q27_x3=x3 Q27_x4=x4
Q27_x5=x5 Q27_x6=x6 Q27_x7=x7 Q27_x8=x8
Q27_x9=x9 Q27_x10=x10 Q27_x11=x11 Q27_x12=x12
Q27_x13=x13 Q27_x14=x14;
drop Q27_x14_text;
run;

data consult.Prog_perception_skills;
set consult.Prog_perception_skills;
rename Q28_x1=x1 Q28_x2=x2 Q28_x3=x3 Q28_x4=x4
Q28_x5=x5 Q28_x6=x6 Q28_x7=x7 Q28_x8=x8
Q28_x9=x9 Q28_x10=x10 Q28_x11=x11 Q28_x12=x12
Q28_x13=x13 Q28_x14=x14;
drop Q28_X14_TEXT;
run;


data consult.specific;
set consult.prog_perception_know consult.prog_perception_skills consult.prog_perception_aware;
array question(*) x1--x14;
array question_new(14) x1_new x2_new x3_new x4_new x5_new  x6_new x7_new x8_new x9_new x10_new
x11_new  x12_new x13_new x14_new;
do i=1 to 14;
question[i]=substr(question[i],1,1);
question_new[i]=input(question[i],1.);
end;
run;

* now I can count the non-zero as the popularity, mean as effectiveness, std as controvercy;
proc format;
value num .='0'
          other='1';
run;
*popularity;
ods output OneWayFreqs=consult.specific_pop;
proc freq data=consult.specific ;
format x1_new--x14_new num.;
tables x1_new--x14_new/missing;
run;
ods output close;

* mean;
proc means data=consult.specific;
var x1_new--x14_new;
output out=consult.specific_summary(drop=_type_ _freq_) mean= median= std= q1= q3= / autoname;
run;
*good vs bad;
proc format;
value level low-<4='good'
            4-high='bad';
run;

ods output OneWayFreqs=consult.specific_good_bad;
proc freq data=consult.specific ;
format x1_new--x14_new level.;
tables x1_new--x14_new;
run;


*****************************************************;
*marketing;
data consult.market_perception_aware;
set consult.market_perception_aware;
rename Q36_x1=x1 Q36_x2=x2 Q36_x3=x3 Q36_x4=x4
Q36_x5=x5 Q36_x6=x6 Q36_x7=x7 Q36_x8=x8 Q36_x9=x9 Q36_x10=x10 Q36_x11=x11 Q36_x12=x12;
run;

data consult.market_perception_know;
set consult.market_perception_know;
rename Q37_x1=x1 Q37_x2=x2 Q37_x3=x3 Q37_x4=x4
Q37_x5=x5 Q37_x6=x6 Q37_x7=x7 Q37_x8=x8
Q37_x9=x9 Q37_x10=x10 Q37_x11=x11 Q37_x12=x12;
run;

data consult.market_perception_skills;
set consult.market_perception_skills;
rename Q38_x1=x1 Q38_x2=x2 Q38_x3=x3 Q38_x4=x4
Q38_x5=x5 Q38_x6=x6 Q38_x7=x7 Q38_x8=x8
Q38_x9=x9 Q38_x10=x10 Q38_x11=x11 Q38_x12=x12;
run;


data consult.market;
set consult.market_perception_know consult.market_perception_skills consult.market_perception_aware;
array question(*) x1--x12;
array question_new(12) x1_new x2_new x3_new x4_new x5_new  x6_new x7_new x8_new x9_new x10_new
x11_new  x12_new;
do i=1 to 12;
question[i]=substr(question[i],1,1);
question_new[i]=input(question[i],1.);
*if question_new[i]=. then question_new[i]=0;
end;
run;

* now I can count the non-zero as the popularity, mean as effectiveness, std as controvercy;
proc format;
value num .='0'
          other='1';
run;
*popularity;
ods output OneWayFreqs=consult.market_pop;
proc freq data=consult.market ;
format x1_new--x12_new num.;
tables x1_new--x12_new/missing;
run;
ods output close;


* mean;
proc means data=consult.market;
var x1_new--x12_new;
output out=consult.market_summary(drop=_type_ _freq_) mean= median= std= q1= q3= / autoname;
run;

*good vs bad;
proc format;
value level low-<4='good'
            4-high='bad';
run;

ods output OneWayFreqs=consult.market_good_bad;
proc freq data=consult.market ;
format x1_new--x12_new level.;
tables x1_new--x12_new;
run;

*****************************************************;
*broad;
data consult.broad_perception_aware;
set consult.broad_perception_aware;
rename Q21_x1=x1 Q21_x2=x2 Q21_x3=x3 Q21_x4=x4
Q21_x5=x5 Q21_x6=x6 Q21_x7=x7 Q21_x8=x8 Q21_x10=x10;
drop Q21_x10_text;
/*set consult.prog_perception_aware;*/
/*array name{*} Q26_x1--Q26_x14;*/
/*do i=1 to 14;*/
/*rename name[i]=i;*/
/*end;*/
run;

data consult.broad_perception_know;
set consult.broad_perception_know;
rename Q24_x1=x1 Q24_x2=x2 Q24_x3=x3 Q24_x4=x4
Q24_x5=x5 Q24_x6=x6 Q24_x7=x7 Q24_x8=x8 Q24_x10=x10;
drop Q24_x10_text;
run;

data consult.broad_perception_skills;
set consult.broad_perception_skills;
rename Q25_x1=x1 Q25_x2=x2 Q25_x3=x3 Q25_x4=x4
Q25_x5=x5 Q25_x6=x6 Q25_x7=x7 Q25_x8=x8 Q25_x10=x10;
drop Q25_x10_text;
run;


data consult.broad;
set consult.broad_perception_know consult.broad_perception_skills consult.broad_perception_aware;
array question(*) x1--x10;
array question_new(9) x1_new x2_new x3_new x4_new x5_new  x6_new x7_new x8_new x10_new;
do i=1 to 9;
question[i]=substr(question[i],1,1);
question_new[i]=input(question[i],1.);
end;
run;

* now I can count the non-zero as the popularity, mean as effectiveness, std as controvercy;
proc format;
value num .='0'
          other='1';
run;
*popularity;
ods output OneWayFreqs=consult.broad_pop;
proc freq data=consult.broad ;
format x1_new--x10_new num.;
tables x1_new--x10_new/missing;
run;
ods output close;


* mean;
proc means data=consult.broad;
var x1_new--x10_new;
output out=consult.broad_summary(drop=_type_ _freq_) mean= median= std= q1= q3= / autoname;
run;

*good vs bad;
proc format;
value level low-<4='good'
            4-high='bad';
run;

ods output OneWayFreqs=consult.broad_good_bad;
proc freq data=consult.broad ;
format x1_new--x10_new level.;
tables x1_new--x10_new;
run;

*test the proportion across programs;
*significant difference in three categories of programs;
data consult.program_prop;
        input program $ Num_good total;
		 Good="Yes"; Count=Num_good;       output;
         Good="No "; Count=Total-Num_good; output;
        datalines;
      specific  2313 4648
      market 5799 11667
	  broad 2271 4135
      ;
run;

 proc freq data=consult.program_prop;
  weight count;
  table program * good / chisq;
  output out=ChiSqData n nmiss pchi lrchi;
run;

*one by one;
data consult.program_prop_1;
        input program $ Num_good total;
		 Good="Yes"; Count=Num_good;       output;
         Good="No "; Count=Total-Num_good; output;
        datalines;
      specific  2313 4648
      market 5799 11667
      ;
run;

 proc freq data=consult.program_prop_1;
  weight count;
  table program * good / chisq;
  output out=ChiSqData n nmiss pchi lrchi;
run;


*significant difference in specific vs. broad;
data consult.program_prop_2;
        input program $ Num_good total;
		 Good="Yes"; Count=Num_good;       output;
         Good="No "; Count=Total-Num_good; output;
        datalines;
      specific  2313 4648
	  broad 2271 4135
      ;
run;

 proc freq data=consult.program_prop_2;
  weight count;
  table program * good / chisq;
  output out=ChiSqData n nmiss pchi lrchi;
run;

*significant difference in market vs. broad;
data consult.program_prop_3;
        input program $ Num_good total;
		 Good="Yes"; Count=Num_good;       output;
         Good="No "; Count=Total-Num_good; output;
        datalines;
      market 5799 11667
	  broad 2271 4135
      ;
run;

 proc freq data=consult.program_prop_3;
  weight count;
  table program * good / chisq;
  output out=ChiSqData n nmiss pchi lrchi;
run;

****************************************
*Logistic regression model             *
****************************************;
libname model "\\stat.ad.ncsu.edu\Redirect\xzhang38\Desktop\project\model";
* Now build a regression model;
data model.variable;
merge consult.practise consult.demographic
      consult.involvement consult.behavior_past_score;
keep high_risk intervention proactive low_risk Q34 Q2 Q48 Q10 Q12 Q13 Q11 Q17_1--Q17_19;
run;

* deal with Q12,Q13,Q11;
data model.variable_2;
set model.variable;
if find(Q12,'music')=0 then do;
Q12_new=compress(Q12,',','k');
Q12_num=length(Q12_new);
end;
else do;
Q12_new=compress(Q12,',','k');
Q12_num=length(Q12_new)-3;
end;
Q13_new=compress(Q13,',','k');
Q13_num=length(Q13_new);
Q11_new=compress(Q11,',','k');
Q11_num=length(Q11_new);
total_num=sum(of Q11_num,Q12_NUM,Q13_NUM);
if Q48='Yes' then Q48='1';
else Q48='0';
run;

*high risk model;
proc freq data=model.variable_2;
table Q48;
run;
*Here I included demo of gender;
proc logistic data=model.variable_2;
class Q34 Q10 Q17_2 Q17_4 Q17_5 Q48;
model high_risk=Q34 Q10 total_num Q17_2 Q17_4 Q17_5 Q48;
run;

*intervention model;
proc logistic data=model.variable_2;
class Q10 Q17_6 Q17_8 Q17_11 Q17_12 Q17_13 Q17_14 Q17_15 Q48;
model intervention=Q10 total_num Q17_6 Q17_8 Q17_11 Q17_12 Q17_13 Q17_14 Q17_15 Q48;
run;
*proactive model;
*Here I included gender and school_type;
proc logistic data=model.variable_2;
class Q34 Q2 Q10 Q48 Q17_16 Q17_17 Q17_18 Q17_19 Q48;
model proactive=Q34 Q2 Q10 Q48 total_num Q17_16 Q17_17 Q17_18 Q17_19 Q48;
run;
*low_risk model;
proc logistic data=model.variable_2;
class Q10 Q48 Q17_1 Q17_7 Q17_9 Q17_10 Q48;
model low_risk=Q10 Q48 total_num Q17_1 Q17_7 Q17_9 Q17_10 Q48;
run;

data model.corr;
set model.variable_2;
if Q2='Public' then Q2_NEW=1;
else Q2_NEW='0';
if Q34='Woman or Female or Feminine' then Q34_NEW=1;
else Q34_NEW=0;
run;

*Test for correlation of two important variables;
proc corr data=model.corr;
var Q2 Q34;
run;



