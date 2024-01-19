/* Exemple de modélisation par la regression logistique*/

/* Source: http://www.statsci.org/data/general/titanic.html */

/*Nettoyage du fichier*/
dm "clear log ; clear output ; " ; run ;
options nocenter nodate nonumber ls=132 ; run ;
ods html close ; run ;
ods graphics off; run ;
ods listing ; run ;




libname in "\\Mac\Home\Desktop\études\M2\UPEC\cours\S2\Scoring\3" ; run ;
data titanic; set in.titanic; run; 
PROC LOGISTIC  data= titanic; 
model survived (ref='0') = Pclass AGE SEX /selection = stepwise RSQUARE;  run;


* constante et covar a diminué de plus de 3,84 à 3e étape avec ajout age donc acceptable (baisse log vraisemblance)
La déviance par rapport au modèle saturé (qui est le modèle idéale), est égale à -2log(vraissemblance du modèle ajusté) et vaut 1688.065 dans le cas du modèle réduit à la constante.
Cette déviance est analogue pour la régression logistique de la somme des carrés des résiduels pour la regression linéaire, et constitue un des principaux indicateurs de la qualité d ajustement du modèle.
L algorithme de selection ajoute au modèle les variables qui font le plus augmenter la vraissemblance et donc diminuer la déviance (-2log(vraissemblance)). Sous l hypothèse H0 de la nullité du coeff  d une 
nouvelle variable ajoutée, la baisse de la déviance suit une loi de Khi2 à 1ddl et on n ajoute donc cette variable que si la baisse de la déviance est supérieure au seuil critique 3,84 à 5% (table duX2, déviance à peut près 4) du khi2 à 1ddl- CF tableau "Récapitulatif sur la sélection Stepwise"; 


*Analyse des valeurs estimées du maximum de vraisemblance de l'étape 3: toutes var significatives à 5%
effets attenduss visuels;

*Tableau  "Analyse des valeurs estimées du maximum de vraisemblance" : Ce tableau est le plus utile pour le scoring, puisqu il contient les estimateurs de coefficients de chaque variable dans la régression logistique; 
- Le ratio Khi-2 de Wald (appelé aussi statistique de Wald)= (Estimation/erreur)^2 est d autant plus elevé que l estimateur est supérieur de 0 et doit etre superieur à 3,84 au seuil de confiance de 95%.
==> Les variables qui ont une khi2 de Wald les plus bas correspondent aux variables les moins fiables.
- Le tableau "Estimation du rapport de cotes" contient les Odds ratios des variables. Ils sont supérieurs à 1 pour les variables influancant positivement sur la proba à prédire, et inférieurs à 1 sinon. Et leurs IC ne doit pas contenir 1. 
- Le tableau "Association des probabilités prédites et des réponses observées"  : fournit les résultats des tests de concordance ;
*Pourcentage concordant: proba de concordance: ce que l'algo explique bien;
/* On constate que les variables selectionnées par le processus stepwise sont, dans l'ordre, SEX, Pclass puis AGE; aucune variable n'est éliminée du processus (etape 0 à 3)*/

/*
- Le R2 passe de 0.22 à 0.31
- Notez aussi que la déviance diminue d une étape à l autre : 1688.065->1355.531->1200.952 : La différence de deux déviances successives est donc bien supérieure au seuil de 3,84 correspondant au khi2 à 1 ddl;

- Coeff : Est-ce que ces signes sont cohérents?

- Sex : est negatif : les hommes (sex=1) survivent moins que les femmes au naufrage (sex=0)
- Age : est negatif
- Pclass : est negatif car on survit moins en 3éme classe qu'en seconde classe, et moins en seconde classe qu'en première classe. 

courbe ROC à lancer après 
 */

proc freq data= titanic;
tables (Pclass age sex)*survived;run;

/* La performance du modèle, i.e, sa capacité à distinguer les survivants des victimes, est fournie par l'indicateur "c" : c'est l'aire sous la courbe de Roc / qui vaut : 0.828*/

/*Courbe de ROC */
* ROC curve for model, classer observations par odre desc, pas var continue, on interprete air au max, ici proche de 1
Intervalle de confiance de Wald à95% doit pas contenir 1 sinon erreur, on peut pas savoir si effet positif ou negatif;

proc logistic data=titanic descending plots(only)=roc;
class SEX Pclass / param=ref; /*var quantitatives*/
model survived = SEX Pclass age;
run;


/* EXEMPLE DE PROGRAMME SAS POUR EFFECTUER UNE ANALYSE SUR VARIABLES QUANTITATIVES*/

DATA infarctus;
INPUT NOM $ C $ prono $ FRCAR INCAR INSYS PRDIA PAPUL PVENT REPUL;
Cards;
1 2 SURVIE 90 1.71 19.0 16 19.5 16.0 912
2 1 DECES 90 1.68 18.7 24 31.0 14.0 1476
3 1 DECES 120 1.40 11.7 23 29.0 8.0 1657
4 2 SURVIE 82 1.79 21.8 14 17.5 10.0 782
5 1 DECES 80 1.58 19.7 21 28.0 18.5 1418
6 1 DECES 80 1.13 14.1 18 23.5 9.0 1664
7 2 SURVIE 94 2.04 21.7 23 27.0 10.0 1059
8 2 SURVIE 80 1.19 14.9 16 21.0 16.5 1412
9 2 SURVIE 78 2.16 27.7 15 20.5 11.5 759
10 2 SURVIE 100 2.28 22.8 16 23.0 4.0 807
11 2 SURVIE 90 2.79 31.0 16 25.0 8.0 717
12 2 SURVIE 86 2.70 31.4 15 23.0 9.5 681
13 2 SURVIE 80 2.61 32.6 8 15.0 1.0 460
14 2 SURVIE 61 2.84 47.3 11 17.0 12.0 479
15 2 SURVIE 99 3.12 31.8 15 20.0 11.0 513
16 2 SURVIE 92 2.47 26.8 12 19.0 11.0 615
17 2 SURVIE 96 1.88 19.6 12 19.0 3.0 809
18 2 SURVIE 86 1.70 19.8 10 14.0 10.5 659
19 2 SURVIE 125 3.37 26.9 18 28.0 6.0 665
20 2 SURVIE 80 2.01 25.0 15 20.0 6.0 796
21 2 SURVIE 82 3.15 38.4 13 20.0 6.0 508
22 1 DECES 110 1.66 15.1 23 31.0 6.5 1494
23 1 DECES 80 1.50 18.7 13 17.0 12.0 907
24 1 DECES 118 1.03 8.7 19 27.0 10.0 2097
25 1 DECES 95 1.89 19.9 25 27.0 20.0 1143
26 1 DECES 80 1.45 18.1 19 23.0 15.0 1269
27 1 DECES 85 1.30 15.1 13 18.0 10.0 1108
28 1 DECES 105 1.84 17.5 18 22.0 10.0 957
29 2 SURVIE 122 2.79 22.9 25 36.0 10.0 1032
30 2 SURVIE 81 1.77 21.9 18 27.0 11.0 1220
31 2 SURVIE 118 2.31 19.6 22 27.0 10.0 935
32 1 DECES 87 1.20 13.8 34 41.0 20.0 2733
33 1 DECES 65 1.19 18.3 15 18.0 13.0 1210
34 2 SURVIE 84 2.15 25.6 27 37.0 10.0 1377
35 1 DECES 103 0.91 8.8 30 33.5 10.0 2945
36 2 SURVIE 75 2.54 33.9 24 31.0 16.0 976
37 2 SURVIE 90 2.08 23.1 20 28.0 6.0 1077
38 2 SURVIE 90 1.93 21.4 11 18.0 10.0 746
39 1 DECES 90 0.95 10.6 20 24.0 6.0 2021
40 2 SURVIE 65 2.38 36.6 16 22.0 12.0 739
41 1 DECES 95 0.99 10.4 20 27.5 8.0 2222
42 1 DECES 95 0.85 8.9 19 22.0 15.5 2071
43 2 SURVIE 86 2.05 23.8 21 28.0 10.0 1093
44 2 SURVIE 82 2.02 24.6 16 22.0 14.0 871
45 1 DECES 70 1.44 20.6 19 26.5 11.0 1472
46 2 SURVIE 92 3.06 33.3 10 15.0 6.0 392
47 1 DECES 94 1.31 13.9 26 40.0 15.0 2443
48 1 DECES 79 1.29 16.3 24 31.0 10.0 1922
49 2 SURVIE 67 1.47 21.9 15 18.0 16.0 980
50 1 DECES 75 1.21 16.1 19 24.0 4.0 1587
51 2 SURVIE 80 2.41 30.9 19 24.0 7.0 797
52 2 SURVIE 61 3.28 54.0 12.0 16.0 7.0 390
53 1 DECES 110 1.24 11.3 22.0 27.5 11.0 1774
54 1 DECES 116 1.85 15.9 33.0 42.0 13.0 1816
55 2 SURVIE 75 2.00 26.7 16.0 22.0 5.0 880
56 1 DECES 92 1.97 21.4 18.0 27.0 3.0 1096
57 2 SURVIE 110 0.96 8.8 15.0 19.0 16.0 1583
58 2 SURVIE 95 2.56 26.9 8.0 13.0 3.0 406
59 2 SURVIE 75 2.32 30.9 8.0 10.0 6.0 345
60 2 SURVIE 80 2.65 33.1 13.0 19.0 9.0 574
61 1 DECES 102 1.60 15.7 24.0 31.0 16.0 1550
62 2 SURVIE 86 1.67 19.4 18.0 23.0 8.5 1102
63 1 DECES 60 0.82 13.7 22.0 32.0 13.0 3122
64 2 SURVIE 100 1.76 17.6 23.0 33.0 2.0 1500
65 2 SURVIE 80 3.28 41.0 12.0 17.0 2.0 415
66 2 SURVIE 108 2.96 27.4 24.0 35.0 6.5 946
67 1 DECES 92 1.37 14.8 25.0 46.0 11.0 2686
68 1 DECES 100 1.38 13.8 20.0 31.0 11.0 1797
69 2 SURVIE 80 2.85 35.6 25.0 32.0 7.0 898
70 1 DECES 87 2.51 28.8 16.0 24.0 20.0 765
71 2 SURVIE 100 2.31 23.1 8.0 12.0 1.0 416
72 1 DECES 120 1.18 9.9 25.0 36.0 8.0 2441
73 1 DECES 115 1.83 15.9 25.0 30.0 8.0 1311
74 2 SURVIE 101 2.55 25.2 23.2 30.5 9.0 957
79 1 DECES 104 1.23 11.8 27.0 33.0 11.0 2146
75 2 SURVIE 92 2.17 23.5 19.0 24.0 3.0 885
76 1 DECES 87 1.42 16.1 20.0 26.0 10.0 1465
77 2 SURVIE 80 1.59 19.9 13.0 20.5 4.0 1031
78 1 DECES 88 1.47 16.7 23.0 32.5 10.0 1769
80 2 SURVIE 90 1.45 16.1 17.0 24.0 8.5 1324
81 1 DECES 67 0.85 12.7 26.0 33.0 11.0 3106
82 2 SURVIE 87 2.37 27.2 15.0 22.0 10.0 743
83 2 SURVIE 108 2.40 22.2 26.0 31.0 4.0 1033
84 1 DECES 120 1.91 15.9 18.0 27.0 15.0 1131
85 1 DECES 108 1.50 13.9 28.0 43.0 16.0 1813
86 2 SURVIE 86 2.36 27.4 24.0 34.0 8.0 1153
87 1 DECES 112 1.56 13.9 24.0 29.0 4.0 1487
88 1 DECES 80 1.34 17.0 16.0 25.0 16.0 1493
89 1 DECES 95 1.65 17.4 20.0 33.0 7.0 1600
90 1 DECES 90 2.04 22.7 28.0 41.0 10.0 1608
91 2 SURVIE 90 3.03 33.6 17.0 23.5 7.0 620
92 1 DECES 94 1.21 12.9 17.0 22.0 3.0 1455
93 1 DECES 51 1.34 26.3 11.0 17.0 6.0 1015
94 1 DECES 110 1.17 10.6 29.0 35.0 10.5 2393
95 1 DECES 96 1.74 18.1 24.0 29.0 6.0 1333
96 1 DECES 132 1.31 9.9 23.0 28.0 12.0 1710
97 1 DECES 135 0.95 7.0 15.0 20.0 7.0 1684
98 1 DECES 105 1.92 18.3 18.0 24.0 3.0 1000
99 1 DECES 99 0.83 8.4 23.0 27.0 8.0 2602
100 1 DECES 116 0.60 5.2 33.0 38.0 10.0 5067
101 1 DECES 112 1.54 13.8 25.0 31.0 8.0 1610
;
Run;

proc format;
	value $pronof
			  SURVIE = 1
			  DECES = 0;
run;
proc freq data= infarctus; table prono; format prono $pronof.;run;


PROC LOGISTIC  data= infarctus; 
model prono (ref='SURVIE') = FRCAR -- REPUL /selection = stepwise RSQUARE;  run;

/*diff de déviance au moins de 3,84
étape 3: diff 70 avec étape 0
étape 2 : diff de 15 avec étape 1
impacte sur survie*/

proc freq data= infarctus;
tables (FRCAR INCAR INSYS PRDIA PAPUL PVENT REPUL)*prono;run;

proc logistic data=infarctus descending plots(only)=roc;
model prono = FRCAR INCAR INSYS PRDIA PAPUL PVENT REPUL;
run;

/* incar et prdia devraient avoir impacte positif sur proba de ne pas survivre

ici impacte sur proba survie*/
