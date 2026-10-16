# flake8: noqa  (Bruchstück, das gen.py per exec einliest; ING und r kommen von dort)
# Erweiterung: Keto / Low Carb / kalorienarm / High Protein / zuckerarm
ING.update({
 'speck':('Bacon / Frühstücksspeck',330,20,27,0.5,3.0,1.60),
 'schweinefilet':('Schweinefilet',110,22,2.5,0,0.1,1.10),
 'rindersteak':('Rinder-Hüftsteak',130,22,4.5,0,0.1,2.20),
 'frischkaese':('Frischkäse (natur)',250,6,24,3,0.8,0.60),
 'oliven':('Oliven (entsteint)',150,1,15,1,3.5,0.90),
 'aubergine':('Aubergine',24,1,0.2,3,0.01,0.25),
 'weisskohl':('Weißkohl',25,1.3,0.2,3.5,0.01,0.12),
 'sahne':('Sahne (30 %)',290,2.4,30,3.3,0.1,0.30),
 'butter':('Butter',740,0.7,82,0.6,0.02,0.90),
 'zitrone':('Zitrone / Limette',30,0.7,0.3,3,0.0,0.40),
 'kakao':('Kakaopulver (stark entölt)',300,20,13,14,0.1,1.00),
 'kerne':('Sonnenblumen-/Kürbiskerne',580,24,48,8,0.01,0.60),
 'kuerbis':('Hokkaido-Kürbis',30,1,0.1,5,0.01,0.25),
 'leinsamen':('Leinsamen (geschrotet)',500,20,40,2,0.0,0.50),
})
SUGAR={'hafer':1,'nudeln':3,'kartoffel':1,'suesskartoffel':6,'quinoa':1,'couscous':2,'bulgur':1,'brot':3,'wrap':3,'haehnchen':0,'pute_auf':1,
 'ei':0.4,'quark':4,'skyr':4,'joghurt':6.5,'huettenkaese':2.5,'mozzarella':1,'milch':4.8,'proteinpulver':4,'tofu':0.5,'linsen':2,'kichererbsen':1,
 'bohnen':1,'edamame':2,'brokkoli':1.5,'spinat':0.5,'paprika':4,'zucchini':2,'tomaten_dose':3,'passata':4,'tomate':3,'gurke':1.5,'karotte':5,'zwiebel':5,
 'champignons':0.5,'salat':1,'avocado':0.5,'banane':17,'apfel':11,'beeren':6,'datteln':63,'erdnussbutter':6,'mandeln':4,'walnuesse':3,'chia':0.5,
 'honig':80,'sojasauce':1,'kokosmilch':1,'tomatenmark':12,'hummus':1,'mais':6,'reiswaffel':1,'kochschinken':0.5,'hirse':1,'blumenkohl':2,'pesto':2,
 'cashews':6,'senf':2,'linsen_dose':1,'reis':0.2,'kuerbis':4,'frischkaese':3,'oliven':0.5,'aubergine':3,'weisskohl':3.5,'sahne':3.3,'kakao':1,'kerne':2,'zitrone':2,'leinsamen':0.5,'speck':0.3}

# ---------- Keto / Low Carb (Vorbilder: REWE Keto-Sammlung, eigene schnelle Varianten)
r('Tomaten-Zucchini-Frittata','MA',20,2,True,False,[('ei',220),('zucchini',150),('tomate',100),('mozzarella',40),('olivenoel',8),('gewuerze',2),('salz',1)],
  ['Zucchini in dünne Scheiben schneiden und in Olivenöl 3 Minuten anbraten.','Eier verquirlen, würzen und über Zucchini und Tomatenscheiben gießen.','Mozzarella zerzupfen, darauf verteilen und zugedeckt 8 Minuten bei kleiner Hitze stocken lassen.'],'Kalt oder warm essen, hält 2 Tage.',4.8,'REWE Keto-Sammlung: Tomaten-Zucchini-Frittata (4,8/5), hier in 20 Minuten')
r('Omelett nach Thai-Art','F',15,0,True,False,[('ei',165),('spinat',60),('champignons',60),('paprika',40),('sojasauce',8),('rapsoel',6),('gewuerze',2)],
  ['Pilze und Paprika in Öl 3 Minuten braten, Spinat kurz mitgaren.','Eier mit Sojasauce und Gewürzen verquirlen und darübergießen.','Bei mittlerer Hitze stocken lassen und zusammenklappen.'],'',4.5,'REWE Keto-Sammlung: Thailändisches Frühstücks-Omelette (4,5/5)')
r('Tomaten-Mozzarella-Omelett','FA',10,0,True,False,[('ei',165),('tomate',100),('mozzarella',60),('olivenoel',5),('gewuerze',2),('salz',1)],
  ['Eier verquirlen und in Olivenöl stocken lassen.','Tomatenscheiben und Mozzarella auf eine Hälfte legen.','Zusammenklappen und kurz zugedeckt schmelzen lassen.'],'',4.3,'REWE Keto-Sammlung: Tomaten-Mozzarella-Omelett (4,3/5)')
r('Zucchininudeln mit Oliven und Feta','MA',20,0,True,False,[('zucchini',350),('oliven',30),('feta',50),('tomate',80),('olivenoel',8),('gewuerze',2),('salz',1)],
  ['Zucchini mit dem Spiralschneider oder Sparschäler zu Nudeln schneiden.','In Olivenöl 2–3 Minuten bissfest braten, Tomatenstücke und Oliven zugeben.','Feta darüber bröseln und sofort servieren.'],'Wenige Kohlenhydrate, bei Bedarf 1 Ei oder Hähnchenwürfel für mehr Eiweiß.',4.5,'REWE Keto-Sammlung: Zucchininudeln mit Oliven und Feta (4,5/5)')
r('Gebratener Lachs auf Römersalat','A',20,0,False,False,[('lachs',160),('salat',150),('tomate',80),('olivenoel',10),('senf',8),('zitrone',15),('salz',1)],
  ['Lachs mit Salz würzen und in einer Pfanne 3–4 Minuten pro Seite braten.','Salat, Tomaten und Dressing aus Olivenöl, Senf und Zitronensaft mischen.','Lachs auf dem Salat anrichten.'],'',4.6,'REWE Keto-Sammlung: Gebratener Lachs mit Römersalat (4,6/5)')
r('Zucchini-Spaghetti mit Zitronen-Hähnchen','MA',25,0,False,False,[('zucchini',300),('haehnchen',150),('zitrone',20),('sahne',40),('parmesan',10),('olivenoel',5),('gewuerze',2),('salz',1)],
  ['Hähnchen in Streifen in Olivenöl goldbraun braten.','Sahne, Zitronensaft und -abrieb zugeben und 2 Minuten einkochen.','Zucchinispaghetti 2 Minuten mitgaren und mit Parmesan servieren.'],'',4.0,'REWE Keto-Sammlung: Zucchini-Spaghetti mit Zitronen-Hähnchensoße (4,0/5)')
r('Schweinefilet mit Spiegelei, Speck und Brokkoli','A',25,0,False,False,[('schweinefilet',150),('ei',55),('speck',20),('brokkoli',200),('rapsoel',6),('salz',1)],
  ['Filet in Medaillons schneiden und je 2–3 Minuten pro Seite braten.','Speck knusprig braten, Brokkoli 5 Minuten dämpfen.','Spiegelei braten und alles anrichten.'],'',4.7,'REWE Keto-Sammlung: Schweinekoteletts mit Spiegelei und Bacon (4,7/5), hier mit magerem Filet')
r('Blumenkohlreis-Bowl mit Hähnchen','MA',25,3,False,False,[('blumenkohl',300),('haehnchen',150),('avocado',50),('paprika',50),('olivenoel',6),('sojasauce',8),('gewuerze',2)],
  ['Blumenkohl fein raspeln oder hacken und in Olivenöl 5 Minuten braten.','Hähnchenstreifen mit Gewürzen braten.','Alles in einer Schüssel mit Paprika, Avocado und Sojasauce anrichten.'],'Blumenkohlreis hält 3 Tage im Kühlschrank.')
r('Paprika-Omelett mit Feta','F',15,0,True,False,[('ei',165),('paprika',100),('feta',30),('rapsoel',5),('gewuerze',2)],
  ['Paprika würfeln und in Öl 3 Minuten anbraten.','Verquirlte Eier darübergeben und stocken lassen.','Feta darüber bröseln und zusammenklappen.'],'',3.9,'REWE Keto-Sammlung: Schnelle Paprika-Omeletts (3,9/5)')
r('Thunfisch-Avocado-Salat','MA',10,2,False,False,[('thunfisch',110),('avocado',100),('ei',55),('gurke',80),('salat',50),('olivenoel',6),('zitrone',15),('senf',5),('salz',1)],
  ['Ei hart kochen (9 Minuten).','Avocado, Gurke und Ei würfeln, Salat zupfen.','Mit Thunfisch, Olivenöl, Zitronensaft und Senf mischen.'],'Dressing separat mitnehmen, dann hält es 2 Tage.')
r('Hähnchen mit Zitronen-Kruste und Brokkoli','A',25,3,False,False,[('haehnchen',180),('zitrone',15),('parmesan',10),('brokkoli',200),('olivenoel',8),('gewuerze',3),('salz',1)],
  ['Hähnchen mit Zitronensaft, Gewürzen und Parmesan einreiben.','In Olivenöl 6 Minuten pro Seite braten.','Brokkoli dämpfen und dazu servieren.'],'',4.1,'REWE Keto-Sammlung: Hähnchenbrustfilets mit Limetten-Koriander-Kruste (4,1/5)')
r('Hack-Zucchini-Pfanne mit Mozzarella','A',20,3,False,False,[('rinderhack',150),('zucchini',250),('tomatenmark',15),('mozzarella',40),('zwiebel',30),('olivenoel',5),('gewuerze',3),('salz',1)],
  ['Hack mit Zwiebel in Olivenöl krümelig braten.','Zucchiniwürfel und Tomatenmark zugeben und 8 Minuten garen.','Mozzarella darauf schmelzen lassen.'],'Hält 3 Tage, gut aufzuwärmen.')
r('Quark mit Nüssen und Beeren (Low Carb)','F',3,0,True,False,[('quark',200),('sahne',30),('walnuesse',20),('beeren',40),('leinsamen',10)],
  ['Quark mit Sahne glatt rühren.','Walnüsse hacken, mit Leinsamen und Beeren darübergeben.'],'Ohne Honig, nur der Zucker aus Quark und Beeren.')
r('Rührei mit Räucherlachs und Avocado','F',8,0,False,False,[('ei',165),('raeucherlachs',60),('avocado',60),('butter',5),('salz',0.5)],
  ['Eier in Butter bei kleiner Hitze cremig rühren.','Mit Lachsstreifen und Avocadoscheiben anrichten.'],'')
r('Blumenkohlpüree mit Hähnchen-Pilz-Pfanne','A',25,0,False,False,[('blumenkohl',300),('haehnchen',150),('champignons',150),('frischkaese',30),('butter',5),('gewuerze',2),('salz',1)],
  ['Blumenkohl 10 Minuten weich kochen, abgießen und mit Frischkäse pürieren.','Hähnchen und Pilze in Butter 8 Minuten braten.','Auf dem Püree anrichten.'],'',3.7,'REWE Keto-Sammlung: Blumenkohl-Püree mit Putenbrustfilet (3,7/5)')
r('Brokkoli-Käse-Suppe mit Speck','MA',20,3,False,False,[('brokkoli',300),('frischkaese',40),('parmesan',15),('zwiebel',30),('speck',15),('gewuerze',2),('salz',1)],
  ['Zwiebel und Brokkoli mit 300 ml Wasser 10 Minuten kochen.','Frischkäse und Parmesan zugeben und pürieren.','Speck knusprig braten und darüberstreuen.'],'Hält 3 Tage, einfrierbar.')
r('Omelett-Muffins mit Schinken und Gemüse','FS',25,3,False,False,[('ei',220),('kochschinken',60),('paprika',60),('spinat',40),('feta',30),('gewuerze',2)],
  ['Eier verquirlen, Schinken, Paprika, Spinat und Feta untermischen.','In Muffinförmchen füllen und 18 Minuten bei 180 °C backen.'],'3 Tage haltbar, kalt oder aufgewärmt.')
r('Gefüllte Auberginen mit Hack','A',35,2,False,False,[('aubergine',250),('rinderhack',120),('tomaten_dose',80),('mozzarella',40),('zwiebel',30),('olivenoel',5),('gewuerze',3),('salz',1)],
  ['Auberginen halbieren, aushöhlen und 10 Minuten vorbacken.','Hack mit Zwiebel und Tomaten anbraten und einfüllen.','Mit Mozzarella überbacken (10 Minuten, 200 °C).'],'',4.0,'REWE Keto-Sammlung: Gefüllte Auberginen mit Hackfleisch (4,0/5), hier verkürzt')
r('Steak mit Pilzen und Zucchini','A',20,0,False,False,[('rindersteak',180),('champignons',120),('zucchini',150),('butter',8),('gewuerze',2),('salz',1)],
  ['Steak mit Salz würzen und 2–3 Minuten pro Seite scharf anbraten, dann ruhen lassen.','Pilze und Zucchini in Butter 6 Minuten braten.','Steak aufschneiden und mit dem Gemüse servieren.'],'')
r('Puten-Frischkäse-Röllchen','S',5,1,False,False,[('pute_auf',80),('frischkaese',40),('gurke',80),('paprika',40)],
  ['Aufschnitt mit Frischkäse bestreichen.','Gurke und Paprika in Streifen darauflegen und aufrollen.'],'Keto-tauglich und ohne Kochen.')
r('Low-Carb-Weißkohlpfanne mit Hack','A',25,3,False,False,[('weisskohl',300),('rinderhack',150),('tomatenmark',15),('zwiebel',40),('rapsoel',5),('sojasauce',8),('gewuerze',3)],
  ['Hack mit Zwiebel in Öl krümelig braten.','Kohl in Streifen und Tomatenmark zugeben, 10 Minuten bei mittlerer Hitze garen.','Mit Sojasauce und Gewürzen abschmecken.'],'Wie gefüllter Kohl, aber in 25 Minuten. Hält 3 Tage.')

# ---------- Kalorienarm und eiweißreich
r('Cottage-Cheese-Beef-Bowl','M',20,2,False,False,[('rinderhack',100),('suesskartoffel',150),('huettenkaese',100),('avocado',50),('honig',5),('rapsoel',4),('gewuerze',4)],
  ['Süßkartoffel würfeln, mit Öl in der Heißluftfritteuse 10 Minuten bei 200 °C garen (Backofen: 20 Minuten bei 220 °C).','Hack mit Taco-Gewürz krümelig braten.','Süßkartoffeln in eine Schüssel, Hüttenkäse in die Mitte, Hack und Avocado darauf, mit etwas Honig und Chili beträufeln.'],'Alle Teile lassen sich getrennt vorbereiten.',None,'Social-Media-Trend: Cottage-Cheese-Beef-Bowl (TikTok), hier auf eine Portion berechnet')
r('Protein-Pancakes mit Hüttenkäse','F',15,0,True,False,[('huettenkaese',80),('quark',60),('ei',110),('mandeln',25),('beeren',60),('rapsoel',4)],
  ['Hüttenkäse, Quark, Eier und gemahlene Mandeln zu Teig mixen.','In wenig Öl kleine Pfannkuchen von beiden Seiten backen.','Mit Beeren servieren.'],'Ohne Zuckerzusatz.',None,'Idee: web.de Proteinsnacks (Protein-Pancakes)')
r('Hüttenkäse-Eiermuffins','FS',25,3,True,False,[('ei',165),('huettenkaese',100),('karotte',40),('kerne',15),('gewuerze',2),('salz',1)],
  ['Eier mit Hüttenkäse, geraspelter Karotte, Kernen und Gewürzen mischen.','In Muffinförmchen füllen und 20 Minuten bei 180 °C backen.'],'3 Tage haltbar.',None,'Idee: web.de Proteinsnacks (Cottage-Cheese-Muffins)')
r('Thunfisch-Bowl mit Bohnen und Quinoa','M',15,3,False,False,[('thunfisch',100),('bohnen',80),('quinoa',50),('gurke',80),('mais',30),('tomate',80),('joghurt',30),('olivenoel',5),('salz',1)],
  ['Quinoa nach Packung kochen und abkühlen lassen.','Gemüse würfeln, Bohnen abspülen.','Alles mit Thunfisch, Joghurt und Olivenöl mischen.'],'3 Tage kühl haltbar.',None,'Idee: ALDI Süd Fitness-Rezepte (Thunfisch-Bowl)')
r('Magerquark-Schoko-Mousse','S',5,2,True,False,[('quark',250),('kakao',10),('proteinpulver',10),('beeren',50)],
  ['Quark mit Kakao und Proteinpulver glatt rühren.','Mit Beeren servieren und kalt stellen.'],'Ohne zugesetzten Zucker; bei Bedarf Süßstoff nach Geschmack.')
r('Thunfisch-Gurken-Boote','S',8,1,False,False,[('gurke',200),('thunfisch',80),('joghurt',30),('senf',5),('gewuerze',2)],
  ['Gurken halbieren und entkernen.','Thunfisch mit Joghurt, Senf und Gewürzen mischen und einfüllen.'],'')
r('Hähnchen-Gemüse-Pfanne (leicht)','MA',15,3,False,False,[('haehnchen',180),('paprika',100),('zucchini',150),('brokkoli',100),('sojasauce',10),('rapsoel',5)],
  ['Hähnchen in Streifen in Öl anbraten.','Gemüse zugeben und 6 Minuten mitbraten.','Mit Sojasauce abschmecken.'],'Unter 400 kcal, viel Volumen.')
r('Garnelen-Zucchini-Pfanne mit Zitrone','A',15,0,False,False,[('garnelen',200),('zucchini',250),('tomate',100),('olivenoel',8),('zitrone',15),('gewuerze',3),('salz',0.5)],
  ['Zucchini in Scheiben in Olivenöl 3 Minuten braten.','Garnelen und Tomaten zugeben und 4 Minuten braten.','Mit Zitronensaft und Gewürzen abschmecken.'],'Sehr kalorienarm bei viel Eiweiß.')
r('Seelachs-Gemüse-Päckchen','A',25,0,False,False,[('seelachs',200),('paprika',80),('zucchini',100),('tomate',80),('olivenoel',5),('zitrone',15),('gewuerze',3)],
  ['Fisch und Gemüse auf Backpapier legen, mit Öl, Zitrone und Gewürzen würzen.','Zu einem Päckchen falten und 18 Minuten bei 200 °C backen.'],'')
r('Protein-Salat mit Hüttenkäse und Ei','M',10,1,True,False,[('huettenkaese',150),('ei',55),('gurke',120),('tomate',100),('kerne',10),('gewuerze',2)],
  ['Ei hart kochen.','Gemüse würfeln, mit Hüttenkäse und Ei anrichten, Kerne darüberstreuen.'],'')
r('Rote-Linsen-Gemüse-Suppe','MA',25,4,True,True,[('linsen',50),('karotte',80),('zwiebel',30),('tomaten_dose',150),('olivenoel',5),('gewuerze',4),('salz',1)],
  ['Zwiebel und Karotte in Öl anschwitzen.','Linsen, Tomaten und 400 ml Wasser zugeben und 15 Minuten kochen.','Pürieren oder stückig lassen und würzen.'],'Hält 4 Tage, einfrierbar.')
r('Asia-Tofu-Gemüse-Pfanne','A',15,2,True,True,[('tofu',200),('brokkoli',150),('paprika',100),('sojasauce',12),('erdnussbutter',10),('rapsoel',6)],
  ['Tofu würfeln und in Öl knusprig braten.','Gemüse zugeben und 6 Minuten braten.','Sojasauce mit Erdnussbutter und etwas Wasser verrühren und unterheben.'],'')
r('Quark-Kräuter-Dip mit Gemüsesticks','S',5,2,True,False,[('quark',150),('gurke',100),('karotte',80),('paprika',80),('zitrone',10),('gewuerze',3),('salz',0.5)],
  ['Quark mit Zitronensaft, Kräutern und Salz verrühren.','Gemüse in Sticks schneiden und dippen.'],'')
r('Gemüse-Rührei-Bowl','F',10,0,True,False,[('ei',165),('spinat',100),('tomate',100),('champignons',100),('rapsoel',4),('salz',1)],
  ['Pilze in Öl 3 Minuten braten, Spinat und Tomaten zugeben.','Eier darübergeben und stocken lassen.'],'Unter 350 kcal.')
r('Skyr mit Zimt-Apfel und Walnuss','F',3,0,True,False,[('skyr',250),('apfel',80),('walnuesse',12),('gewuerze',1)],
  ['Skyr in eine Schüssel geben.','Apfel würfeln, mit Zimt und gehackten Walnüssen darauf verteilen.'],'Kein Zuckerzusatz.')
r('Thunfisch-Omelett','FA',10,0,False,False,[('ei',165),('thunfisch',60),('tomate',60),('zwiebel',20),('rapsoel',4),('salz',0.5)],
  ['Zwiebel und Tomate in Öl 2 Minuten braten.','Eier mit Thunfisch verquirlen, dazugeben und stocken lassen.'],'')
