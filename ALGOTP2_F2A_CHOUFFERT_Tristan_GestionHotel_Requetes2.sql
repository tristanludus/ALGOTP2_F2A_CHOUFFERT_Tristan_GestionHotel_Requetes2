Classement des clients par nombre d'occupations:
SELECT CHB_ID as client, sum(CHB_PLN_CLI_OCCUPE) as occupe
FROM TJ_CHB_PLN_CLI
GROUP BY client
ORDER BY occupe desc

Classement des clients par montant dépensé dans l'hotel:
SELECT TJ_CHB_PLN_CLI.CLI_ID as client, sum(TJ_TRF_CHB.TRF_CHB_PRIX) as montant
FROM TJ_CHB_PLN_CLI, TJ_TRF_CHB
WHERE TJ_CHB_PLN_CLI.CHB_ID=TJ_TRF_CHB.CHB_ID
GROUP BY client
ORDER BY montant desc

Classement des occupations par mois:
Select strftime('%m',PLN_JOUR) as Mois, sum(CHB_PLN_CLI_OCCUPE) as Occupe
FROM TJ_CHB_PLN_CLI
GROUP BY Mois
ORDER BY Occupe desc 

Classement des occupations par trimestre:



Montant TTC de chaque ligne de facture:



Classement du montant total TTC des factures:



Tarif moyen des chambres par années croissantes:
Select avg(TRF_CHB_PRIX) as tarif, strftime('%Y',TRF_DATE_DEBUT) as année
FROM TJ_TRF_CHB
GROUP BY année
ORDER BY tarif asc

Tarif moyen des chambres par étage et années croissantes:
Select avg(TJ_TRF_CHB.TRF_CHB_PRIX) as tarif, strftime('%Y',TJ_TRF_CHB.TRF_DATE_DEBUT) as année, T_CHAMBRE.CHB_ETAGE as etage
FROM TJ_TRF_CHB, T_CHAMBRE
WHERE T_CHAMBRE.CHB_ID=TJ_TRF_CHB.CHB_ID
GROUP BY année, etage
ORDER BY tarif asc

chambre la plus cher et en quelle année:
SELECT MAX(TRF_CHB_PRIX) as PrixMax, strftime('%Y',TRF_DATE_DEBUT) as année
FROM TJ_TRF_CHB

Chambre réservées mais pas occupées:
SELECT CHB_ID as chambre, CHB_PLN_CLI_RESERVE as réservé
FROM TJ_CHB_PLN_CLI
WHERE CHB_PLN_CLI_RESERVE=1
AND CHB_PLN_CLI_OCCUPE=0

Taux de réservation par chambre:
SELECT avg(CHB_PLN_CLI_RESERVE) as réservation, CHB_ID as chambre
FROM TJ_CHB_PLN_CLI
GROUP BY chambre
ORDER BY réservation ASC

Facture réglées avant leur édition:
SELECT FAC_ID as facture , FAC_DATE as date, FAC_PMT_DATE as paiement
FROM T_FACTURE
WHERE FAC_DATE>FAC_PMT_DATE
AND PMT_CODE<>""
GROUP BY facture
ORDER BY facture asc

Par qui ont été payées ces factures réglées en avances:
SELECT T_FACTURE.FAC_ID as facture , T_FACTURE.FAC_DATE as date, T_FACTURE.FAC_PMT_DATE as paiement, T_FACTURE.CLI_ID as client, T_CLIENT.CLI_NOM as nom, T_CLIENT.CLI_PRENOM as prenom
FROM T_FACTURE, T_CLIENT
WHERE T_CLIENT.CLI_ID=T_FACTURE.CLI_ID
AND FAC_DATE>FAC_PMT_DATE
AND PMT_CODE<>""
GROUP BY facture
ORDER BY facture asc

Classement des modes de paiement par le montant total généré:
SELECT T_FACTURE.PMT_CODE as Mode, sum(T_LIGNE_FACTURES.LIF_MONTANT) as total
FROM T_FACTURE, T_LIGNE_FACTURES
WHERE T_FACTURE.FAC_ID=T_LIGNE_FACTURES.FAC_ID
GROUP BY Mode
ORDER BY total desc

Vous vous créez en tant que client de l'hôtel:
INSERT INTO "main"."T_CLIENT" ("CLI_ID","CLI_NOM","CLI_PRENOM","TIT_CODE") VALUES (101,"CHOUFFERT","Tristan","M.");

Ne pas oublier vos moyens de communication:
INSERT INTO "main"."T_EMAIL" ("EML_ID","EML_ADRESSE","CLI_ID") VALUES (40,"t.chouffert@ludus-academie.com",101);
INSERT INTO "main"."T_TELEPHONE" ("TEL_ID","TEL_NUMERO","CLI_ID","TYP_CODE") VALUES (251,"06-90-80-70-60",101,"GSM");

Vous créez une nouvelle chambre à la date du jour:
INSERT INTO "main"."TJ_CHB_PLN_CLI" ("CHB_ID","CLI_ID","PLN_JOUR","CHB_PLN_CLI_NB_PERS","CHB_PLN_CLI_RESERVE","CHB_PLN_CLI_OCCUPE")
VALUES (21,101, date('now'),2,1,1);

Nouvelle chambre 30% plus cher que l'ancienne plus cher:
INSERT INTO "main"."TJ_TRF_CHB" ("CHB_ID","TRF_DATE_DEBUT","TRF_CHB_PRIX")
VALUES (21, date('now'), 665);

Le règlement de votre facture sera effectué en CB:
INSERT INTO "main"."T_FACTURE" ("FAC_ID","FAC_DATE","PMT_CODE","FAC_PMT_DATE","CLI_ID")
VALUES (2375, date('now'), "CB", date('now'), 101);

Une 2nde facture a été éditée car le tarif a changé: rabais de 10%:
INSERT INTO "main"."T_LIGNE_FACTURES" ("LIF_ID","FAC_ID","LIF_QTE","LIF_REMISE_POURCENT","LIF_MONTANT","LIF_TAUX_TVA")
VALUES (16791, 2375, 1, 10, 665, 20.6);