# Zutaten: key -> (Name, kcal, P, F, C, Salz g, Preis €/100g)  je 100 g (Richtwerte, Discounter-Preise 2026 geschätzt)
ING = {
 'reis':('Reis (trocken)',350,7,1,78,0.01,0.20),
 'hafer':('Haferflocken',370,13,7,60,0.02,0.15),
 'nudeln':('Vollkornnudeln (trocken)',350,13,2.5,67,0.02,0.22),
 'kartoffel':('Kartoffeln',77,2,0.1,17,0.01,0.12),
 'suesskartoffel':('Süßkartoffel',86,1.6,0.1,20,0.05,0.30),
 'quinoa':('Quinoa (trocken)',360,14,6,64,0.02,0.60),
 'couscous':('Couscous (trocken)',360,12,1.5,73,0.02,0.25),
 'bulgur':('Bulgur (trocken)',340,12,1.5,65,0.02,0.30),
 'brot':('Vollkornbrot',215,8,1.5,40,1.2,0.30),
 'wrap':('Vollkorn-Wrap',300,8,6,52,1.3,0.40),
 'haehnchen':('Hähnchenbrust',110,23,1.5,0,0.15,0.85),
 'pute_auf':('Putenbrust-Aufschnitt',105,21,1.5,1,2.0,1.20),
 'puten_hack':('Putenhackfleisch',140,20,6,0,0.2,0.85),
 'rinderhack':('Rinderhack (mager)',125,21,5,0,0.15,1.10),
 'lachs':('Lachsfilet',200,20,13,0,0.15,1.60),
 'raeucherlachs':('Räucherlachs',180,20,11,0,3.0,2.50),
 'thunfisch':('Thunfisch im eigenen Saft',110,25,1,0,1.0,1.00),
 'seelachs':('Seelachs (TK)',80,18,0.7,0,0.3,0.80),
 'garnelen':('Garnelen (TK)',85,18,1,0,1.2,1.60),
 'ei':('Eier',143,12.5,10,0.7,0.35,0.55),
 'quark':('Magerquark',67,12,0.3,4,0.1,0.16),
 'skyr':('Skyr',63,11,0.2,4,0.1,0.20),
 'joghurt':('Naturjoghurt 1,5 %',47,4.5,1.5,6.5,0.1,0.12),
 'huettenkaese':('Hüttenkäse',95,12,4,2.5,0.7,0.55),
 'feta':('Feta',260,15,21,1.5,2.7,0.65),
 'mozzarella':('Mozzarella light',165,18,9,1,0.5,0.70),
 'parmesan':('Parmesan',400,36,28,0,1.8,1.60),
 'milch':('Milch 1,5 %',47,3.4,1.5,4.8,0.1,0.10),
 'proteinpulver':('Proteinpulver',380,78,5,8,0.5,3.00),
 'tofu':('Tofu natur',120,13,7,1.5,0.05,0.50),
 'linsen':('Rote Linsen (trocken)',350,25,1.5,50,0.02,0.20),
 'kichererbsen':('Kichererbsen (Dose, abgetropft)',120,7,2.5,17,0.3,0.20),
 'bohnen':('Kidney-/Schwarze Bohnen (Dose)',110,7,0.5,17,0.4,0.20),
 'edamame':('Edamame (TK)',120,12,5,6,0.01,0.45),
 'brokkoli':('Brokkoli',34,3,0.4,4,0.03,0.22),
 'spinat':('Blattspinat (TK)',25,3,0.4,1,0.2,0.15),
 'paprika':('Paprika',30,1,0.3,5,0.01,0.32),
 'zucchini':('Zucchini',18,1.5,0.3,2,0.01,0.20),
 'tomaten_dose':('Tomaten (Dose, gehackt)',20,1,0.2,3.5,0.3,0.10),
 'passata':('Passierte Tomaten',25,1.3,0.2,4,0.1,0.10),
 'tomate':('Tomaten',18,0.9,0.2,3,0.01,0.30),
 'gurke':('Gurke',12,0.6,0.1,1.5,0.01,0.15),
 'karotte':('Karotten',35,0.9,0.2,7,0.1,0.10),
 'zwiebel':('Zwiebeln',40,1.1,0.1,8,0.01,0.10),
 'champignons':('Champignons',22,3,0.3,1,0.01,0.40),
 'salat':('Blattsalat',18,1.5,0.3,1.5,0.1,0.50),
 'avocado':('Avocado',160,2,15,2,0.01,0.70),
 'banane':('Banane',90,1,0.3,20,0.01,0.20),
 'apfel':('Apfel',52,0.3,0.2,12,0.01,0.25),
 'beeren':('Beeren (TK)',45,0.8,0.3,8,0.01,0.40),
 'datteln':('Datteln',280,2,0.3,65,0.01,0.60),
 'erdnussbutter':('Erdnussbutter',600,25,50,10,0.5,0.80),
 'mandeln':('Mandeln',580,21,50,10,0.01,1.00),
 'walnuesse':('Walnüsse',650,15,65,7,0.01,1.00),
 'chia':('Chiasamen',480,17,31,8,0.01,1.10),
 'olivenoel':('Olivenöl',880,0,99.5,0,0.0,0.85),
 'rapsoel':('Rapsöl',880,0,99,0,0.0,0.25),
 'honig':('Honig',330,0.3,0,80,0.0,0.80),
 'sojasauce':('Sojasauce',60,6,0,6,14.0,0.40),
 'kokosmilch':('Kokosmilch (Dose, light)',80,0.7,7,2,0.05,0.30),
 'tomatenmark':('Tomatenmark',82,4.5,0.5,15,1.0,0.60),
 'hummus':('Hummus',250,7,18,13,1.2,0.65),
 'mais':('Mais (Dose)',80,2.5,1,14,0.3,0.20),
 'reiswaffel':('Reiswaffeln',380,8,3,80,0.8,0.50),
 'kochschinken':('Kochschinken',110,19,3,1,2.0,1.00),
 'hirse':('Hirse (trocken)',360,11,4,69,0.02,0.35),
 'blumenkohl':('Blumenkohl',25,2,0.3,2.5,0.02,0.25),
 'pesto':('Pesto',450,5,45,5,2.0,0.90),
 'cashews':('Cashewkerne',580,18,44,30,0.02,1.20),
 'senf':('Senf',66,4,4,3,2.5,0.40),
 'linsen_dose':('Linsen (Dose, abgetropft)',115,9,0.6,16,0.3,0.25),
 'gewuerze':('Gewürze und Kräuter',0,0,0,0,0.0,1.00),
 'salz':('Salz',0,0,0,0,100.0,0.03),
}
# Rezepte: (id, Name, Slots[F=Frühstück,M=Mittag,A=Abend,S=Snack], Minuten, Meal-Prep-Tage (0=nein), vegetarisch, vegan, [(zutat,g)], [Schritte], Hinweis)
R=[]
def r(name,slots,minutes,prep,veg,vegan,ings,steps,note='',rating=None,source=''): R.append((name,slots,minutes,prep,veg,vegan,ings,steps,note,rating,source))

# --- Frühstück
r('Protein-Overnight-Oats','F',5,3,True,False,[('hafer',50),('skyr',150),('milch',100),('proteinpulver',15),('beeren',80),('chia',8)],
  ['Haferflocken, Skyr, Milch, Proteinpulver und Chiasamen in einem Glas verrühren.','Über Nacht (mind. 4 Std.) im Kühlschrank quellen lassen.','Mit aufgetauten Beeren toppen.'],'Für 3 Tage im Voraus: 3 Gläser vorbereiten, Beeren erst morgens dazu.')
r('Skyr-Bowl mit Beeren und Mandeln','F',3,0,True,False,[('skyr',300),('beeren',100),('hafer',30),('mandeln',15),('honig',10)],
  ['Skyr in eine Schüssel geben.','Beeren, Haferflocken und gehackte Mandeln darauf verteilen.','Mit Honig beträufeln.'])
r('Rührei mit Spinat und Vollkorntoast','F',10,0,True,False,[('ei',165),('spinat',80),('brot',70),('rapsoel',5),('tomate',60),('salz',1)],
  ['Spinat auftauen und ausdrücken.','Öl erhitzen, Spinat kurz anbraten, verquirlte Eier dazugeben und stocken lassen.','Mit Salz würzen, mit Toast und Tomatenscheiben servieren.'])
r('Avocado-Hüttenkäse-Toast','F',5,0,True,False,[('brot',80),('huettenkaese',100),('avocado',60),('tomate',60),('gewuerze',2)],
  ['Brot toasten.','Avocado zerdrücken und aufstreichen, Hüttenkäse darauf geben.','Mit Tomatenscheiben und Gewürzen belegen.'])
r('Bananen-Hafer-Pancakes','F',15,3,True,False,[('hafer',60),('ei',110),('banane',120),('quark',100),('rapsoel',5)],
  ['Haferflocken fein mixen, mit Eiern, Banane und Quark zu Teig pürieren.','Öl in einer beschichteten Pfanne erhitzen, kleine Pfannkuchen bei mittlerer Hitze von beiden Seiten backen.','Warm essen oder abkühlen lassen und bis 3 Tage kühl lagern.'],'Lässt sich einfrieren und im Toaster aufbacken.')
r('Protein-Porridge','F',8,0,True,False,[('hafer',60),('milch',200),('proteinpulver',25),('banane',80),('gewuerze',1)],
  ['Haferflocken mit Milch aufkochen und 3 Minuten quellen lassen.','Vom Herd nehmen, Proteinpulver unterrühren.','Mit Bananenscheiben und Zimt servieren.'])
r('Tofu-Rührei-Wrap','F',12,0,True,True,[('tofu',150),('wrap',62),('paprika',60),('spinat',40),('rapsoel',5),('gewuerze',3),('salz',1)],
  ['Tofu zerbröseln und in Öl mit Gewürzen (Kurkuma, Paprika) anbraten.','Gewürfelte Paprika und Spinat 3 Minuten mitbraten.','Alles im Wrap einrollen.'])
r('Shakshuka-Pfanne mit Feta','F',20,3,True,False,[('ei',165),('tomaten_dose',200),('paprika',80),('zwiebel',40),('feta',30),('brot',50),('rapsoel',5),('gewuerze',3)],
  ['Zwiebel und Paprika in Öl anbraten, Dosentomaten und Gewürze zugeben, 8 Minuten köcheln.','Mulden formen, Eier hineinschlagen, zugedeckt 5 Minuten stocken lassen.','Feta darüber bröseln, mit Brot essen.'],'Die Tomatensauce hält 3 Tage; Eier frisch dazugeben.')
r('Süßkartoffel-Hash mit Ei','F',20,0,False,False,[('suesskartoffel',200),('ei',110),('paprika',60),('pute_auf',50),('rapsoel',5),('salz',1)],
  ['Süßkartoffel würfeln und in Öl 10 Minuten braten.','Paprika und Putenstreifen zugeben, 4 Minuten weiterbraten.','Eier als Spiegelei oder verrührt darübergeben.'])
r('Lachs-Quark-Brot','F',5,0,False,False,[('brot',100),('quark',100),('raeucherlachs',60),('gurke',80),('gewuerze',2)],
  ['Quark mit Gewürzen und Dill glatt rühren.','Brot damit bestreichen und mit Lachs belegen.','Gurkenscheiben dazu.'])
r('Bananen-Erdnuss-Shake','F',3,0,True,False,[('banane',120),('milch',300),('proteinpulver',30),('erdnussbutter',15),('hafer',30)],
  ['Alle Zutaten in einen Mixer geben.','30 Sekunden mixen.','Sofort trinken oder gekühlt mitnehmen.'])

# --- Mittag
r('Linsen-Bolognese mit Vollkornnudeln','M',25,4,True,False,[('nudeln',90),('linsen',60),('passata',200),('karotte',60),('zwiebel',50),('parmesan',10),('olivenoel',8),('gewuerze',3),('salz',1)],
  ['Zwiebel und Karotte würfeln, in Olivenöl anbraten.','Linsen und Passata mit 150 ml Wasser zugeben, 15 Minuten köcheln.','Nudeln kochen, mit der Sauce mischen, Parmesan darüber.'],'Sauce für 4 Tage kochen und portionsweise einfrieren.')
r('Chili con Pute mit Reis','M',30,4,False,False,[('puten_hack',200),('bohnen',120),('mais',60),('tomaten_dose',200),('paprika',80),('zwiebel',50),('reis',60),('rapsoel',5),('gewuerze',4),('salz',1)],
  ['Hack in Öl krümelig anbraten, Zwiebel und Paprika zugeben.','Tomaten, Bohnen, Mais und Gewürze einrühren, 20 Minuten köcheln.','Reis separat kochen und dazu servieren.'],'Eines der besten Meal-Prep-Gerichte: 4 Tage im Kühlschrank haltbar.')
r('Hähnchen-Gemüse-Wok mit Reis','M',20,3,False,False,[('haehnchen',180),('brokkoli',150),('paprika',80),('karotte',60),('sojasauce',15),('reis',70),('rapsoel',8)],
  ['Reis nach Packung kochen.','Hähnchenstreifen in Öl scharf anbraten, Gemüse zugeben und 6 Minuten wokken.','Mit Sojasauce ablöschen und über dem Reis anrichten.'])
r('Thunfisch-Nudelsalat','M',15,3,False,False,[('nudeln',80),('thunfisch',120),('mais',50),('tomate',100),('gurke',80),('olivenoel',10),('joghurt',40),('salz',1)],
  ['Nudeln kochen und abkühlen lassen.','Gemüse würfeln und mit Thunfisch und Nudeln mischen.','Mit Joghurt, Olivenöl, Salz und Pfeffer anmachen.'],'Schmeckt am nächsten Tag noch besser.')
r('Kichererbsen-Curry mit Reis','M',25,4,True,True,[('kichererbsen',200),('kokosmilch',80),('tomaten_dose',150),('spinat',100),('zwiebel',50),('reis',70),('rapsoel',5),('gewuerze',4),('salz',1)],
  ['Zwiebel in Öl anbraten, Currypulver zugeben.','Tomaten, Kokosmilch und Kichererbsen einrühren, 12 Minuten köcheln, Spinat unterheben.','Mit Reis servieren.'])
r('Quinoa-Bowl mit Kichererbsen und Feta','M',15,3,True,False,[('quinoa',70),('kichererbsen',120),('gurke',100),('tomate',100),('feta',40),('olivenoel',10),('hummus',30),('salz',1)],
  ['Quinoa 12 Minuten kochen und abkühlen lassen.','Gemüse würfeln, mit Kichererbsen und Quinoa mischen.','Feta darüber, Hummus als Klecks, mit Olivenöl beträufeln.'])
r('Burrito-Bowl','M',20,3,False,False,[('rinderhack',150),('reis',70),('bohnen',100),('mais',50),('paprika',80),('avocado',40),('joghurt',40),('gewuerze',4),('salz',1)],
  ['Reis kochen.','Hack mit Gewürzen anbraten, Paprika mitgaren.','Alles in einer Schale anrichten, Bohnen, Mais, Avocado und Joghurt darauf.'])
r('Ofenkartoffel mit Kräuterquark und Lachs','M',45,0,False,False,[('kartoffel',350),('quark',200),('raeucherlachs',50),('gurke',80),('gewuerze',3),('salz',1)],
  ['Kartoffeln waschen, einstechen und bei 200 °C etwa 40 Minuten backen.','Quark mit Kräutern, Salz und Pfeffer glatt rühren.','Kartoffeln aufschneiden, Quark und Lachs darauf, Gurke dazu.'])
r('Pute-Hummus-Wrap','M',8,0,False,False,[('wrap',124),('pute_auf',100),('hummus',40),('salat',50),('gurke',50),('paprika',50)],
  ['Wraps mit Hummus bestreichen.','Pute, Salat, Gurken- und Paprikastreifen darauf legen.','Fest einrollen und halbieren.'],'Zum Mitnehmen geeignet, in Folie 1 Tag haltbar.')
r('Hack-Zucchini-Pfanne mit Kartoffeln','M',25,3,False,False,[('rinderhack',150),('zucchini',200),('kartoffel',250),('tomatenmark',15),('zwiebel',40),('rapsoel',5),('gewuerze',3),('salz',1)],
  ['Kartoffeln würfeln und 12 Minuten kochen.','Hack mit Zwiebel in Öl anbraten, Tomatenmark und Zucchiniwürfel zugeben.','Kartoffeln unterheben und würzen.'])
r('Lachs mit Ofengemüse und Couscous','M',25,0,False,False,[('lachs',150),('couscous',70),('zucchini',150),('paprika',100),('olivenoel',8),('gewuerze',2),('salz',1)],
  ['Gemüse würfeln, mit Öl und Gewürzen auf ein Blech, 10 Minuten bei 200 °C backen.','Lachs dazulegen und weitere 12 Minuten garen.','Couscous mit heißem Wasser übergießen, 5 Minuten quellen lassen.'])
r('Teriyaki-Tofu-Bowl','M',25,0,True,True,[('tofu',200),('reis',70),('brokkoli',150),('karotte',60),('sojasauce',20),('honig',10),('rapsoel',6)],
  ['Tofu pressen, würfeln und in Öl knusprig braten.','Sojasauce mit Honig und 30 ml Wasser mischen, über den Tofu geben und einkochen.','Mit gedämpftem Brokkoli, Karotten und Reis anrichten.'])
r('Rote-Linsen-Dal mit Reis','M',25,4,True,True,[('linsen',90),('kokosmilch',60),('spinat',80),('zwiebel',50),('tomaten_dose',100),('reis',60),('rapsoel',5),('gewuerze',4),('salz',1)],
  ['Zwiebel mit Gewürzen anbraten.','Linsen, Tomaten, Kokosmilch und 300 ml Wasser 15 Minuten köcheln.','Spinat unterrühren, mit Reis servieren.'],'Sehr günstig und gut für 4 Tage.')
r('Hähnchen-Bulgur-Salat','M',20,3,False,False,[('bulgur',70),('haehnchen',150),('gurke',100),('tomate',100),('feta',30),('olivenoel',10),('salz',1)],
  ['Bulgur mit heißem Wasser übergießen und 15 Minuten quellen lassen.','Hähnchen würzen und braten, in Streifen schneiden.','Alles mit Gemüse, Feta und Olivenöl mischen.'])
r('Garnelen-Zucchini-Pfanne mit Reis','M',15,0,False,False,[('garnelen',180),('zucchini',150),('reis',70),('olivenoel',8),('gewuerze',3),('salz',1)],
  ['Reis kochen.','Garnelen auftauen, in Olivenöl 3 Minuten braten.','Zucchinistreifen zugeben, würzen und mit Reis servieren.'])

# --- Abend
r('Champignon-Omelett mit Mozzarella','A',12,0,True,False,[('ei',220),('champignons',120),('mozzarella',40),('tomate',80),('rapsoel',5),('brot',50),('salz',1)],
  ['Champignons in Öl anbraten.','Verquirlte Eier darübergießen und stocken lassen.','Mozzarella darauf, zusammenklappen, mit Tomate und Brot servieren.'])
r('Protein-Abendbrotplatte','A',5,0,False,False,[('brot',100),('huettenkaese',150),('pute_auf',60),('gurke',100),('tomate',100),('gewuerze',1)],
  ['Brot in Scheiben schneiden.','Hüttenkäse, Pute, Gurken- und Tomatenscheiben anrichten.','Mit Pfeffer würzen.'])
r('Hähnchen-Ofengemüse mit Kartoffeln','A',35,3,False,False,[('haehnchen',200),('kartoffel',250),('brokkoli',150),('paprika',80),('olivenoel',10),('gewuerze',3),('salz',1)],
  ['Kartoffeln und Paprika würfeln, mit Öl und Gewürzen auf ein Blech, 15 Minuten bei 200 °C.','Hähnchen und Brokkoli dazugeben, weitere 18 Minuten backen.','Auf Boxen verteilen.'],'Lässt sich perfekt für 3 Abende vorbereiten.')
r('Seelachs mit Kartoffeln und Rahmspinat','A',25,0,False,False,[('seelachs',220),('kartoffel',250),('spinat',150),('joghurt',60),('rapsoel',5),('gewuerze',2),('salz',1)],
  ['Kartoffeln kochen.','Seelachs in Öl 4 Minuten pro Seite braten.','Spinat erhitzen, Joghurt unterrühren, würzen und alles anrichten.'])
r('Hackbällchen in Tomatensauce','A',30,4,False,False,[('puten_hack',200),('passata',200),('zwiebel',40),('hafer',20),('zucchini',150),('rapsoel',5),('gewuerze',4),('salz',1)],
  ['Hack mit Haferflocken, Zwiebel und Gewürzen zu Bällchen formen.','In Öl rundum anbraten.','Passata und Zucchiniwürfel zugeben, 12 Minuten sanft köcheln.'],'Wenig Kohlenhydrate, ideal an Ruhetagen und zum Vorkochen.')
r('Tofu-Gemüse-Curry','A',20,3,True,True,[('tofu',180),('kokosmilch',70),('paprika',100),('brokkoli',100),('sojasauce',10),('reis',40),('rapsoel',5),('gewuerze',3)],
  ['Tofu würfeln und in Öl anbraten.','Gemüse und Currypulver zugeben, mit Kokosmilch und Sojasauce ablöschen, 8 Minuten garen.','Mit wenig Reis servieren.'])
r('Linsensuppe mit Kartoffeln','A',30,4,False,False,[('linsen',80),('karotte',80),('kartoffel',150),('zwiebel',40),('kochschinken',40),('rapsoel',5),('gewuerze',3),('salz',2)],
  ['Zwiebel, Karotte und Kartoffel würfeln und in Öl anbraten.','Linsen und 600 ml Wasser zugeben, 20 Minuten köcheln.','Schinkenwürfel zugeben, würzen.'])
r('Gefüllte Paprika','A',40,3,False,False,[('paprika',250),('rinderhack',150),('reis',40),('tomaten_dose',100),('feta',30),('gewuerze',3),('salz',1)],
  ['Paprika halbieren und entkernen.','Hack mit gekochtem Reis, Tomaten und Gewürzen mischen und einfüllen.','Feta darüber, 30 Minuten bei 190 °C backen.'])
r('Lachs-Avocado-Salat','A',15,0,False,False,[('lachs',140),('salat',100),('avocado',60),('gurke',100),('olivenoel',8),('ei',55),('salz',1)],
  ['Lachs in der Pfanne 3 Minuten pro Seite braten.','Ei hart kochen.','Salat, Gurke und Avocado anrichten, Lachs und Ei dazu, mit Öl beträufeln.'])
r('Ei-Gemüse-Muffins','A',25,4,True,False,[('ei',220),('paprika',80),('spinat',60),('feta',30),('pute_auf',40),('salz',1)],
  ['Gemüse klein schneiden, Spinat auftauen und ausdrücken.','Eier verquirlen, mit Gemüse, Feta und Pute mischen.','In Muffinförmchen füllen, 18 Minuten bei 180 °C backen.'],'Kalt oder aufgewärmt gut, bis zu 4 Tage haltbar.')
r('Hähnchen-Gemüsesuppe','A',25,4,False,False,[('haehnchen',150),('karotte',100),('kartoffel',150),('nudeln',30),('zwiebel',40),('gewuerze',3),('salz',2)],
  ['Zwiebel, Karotte und Kartoffel würfeln, in 600 ml Wasser 12 Minuten kochen.','Hähnchen und Nudeln zugeben, weitere 10 Minuten garen.','Würzen und das Hähnchen kurz zerzupfen.'])
r('Süßkartoffel-Bohnen-Pfanne','A',25,3,True,False,[('suesskartoffel',250),('bohnen',120),('mais',40),('paprika',80),('avocado',30),('joghurt',40),('rapsoel',6),('gewuerze',3),('salz',1)],
  ['Süßkartoffeln würfeln und in Öl 12 Minuten braten.','Paprika, Bohnen und Mais zugeben, würzen.','Mit Avocado und Joghurt servieren.'])

# --- Snacks
r('Skyr mit Beeren','S',3,0,True,False,[('skyr',250),('beeren',100)],['Skyr in eine Schale geben.','Aufgetaute Beeren darauf verteilen.'])
r('Magerquark-Creme mit Banane','S',3,0,True,False,[('quark',250),('honig',8),('banane',60),('gewuerze',1)],['Quark glatt rühren.','Banane zerdrücken und mit Honig und Zimt unterheben.'])
r('Schneller Proteinshake','S',2,0,True,False,[('milch',300),('proteinpulver',30),('banane',100)],['Alles in einen Shaker oder Mixer geben.','Gut schütteln oder mixen.'])
r('Reiswaffeln mit Erdnussbutter und Banane','S',3,0,True,True,[('reiswaffel',20),('erdnussbutter',20),('banane',80)],['Reiswaffeln mit Erdnussbutter bestreichen.','Bananenscheiben darauf legen.'])
r('Eier mit Gemüsesticks und Hummus','S',12,3,True,False,[('ei',110),('karotte',100),('gurke',100),('hummus',40)],['Eier 9 Minuten hart kochen und abschrecken.','Gemüse in Sticks schneiden.','Mit Hummus servieren.'],'Eier lassen sich 5 Tage gekocht im Kühlschrank halten.')
r('Joghurt mit Walnüssen und Apfel','S',3,0,True,False,[('joghurt',200),('walnuesse',20),('honig',10),('apfel',100)],['Joghurt in eine Schale geben.','Apfel würfeln, mit Walnüssen und Honig darauf verteilen.'])
r('Thunfisch-Gurken-Happen','S',5,0,False,False,[('gurke',150),('thunfisch',80),('quark',40),('gewuerze',2)],['Thunfisch mit Quark und Gewürzen verrühren.','Gurke in dicke Scheiben schneiden und die Creme darauf geben.'])
r('Energy Balls mit Dattel und Protein','S',15,5,True,True,[('hafer',40),('datteln',40),('erdnussbutter',20),('proteinpulver',15)],['Alle Zutaten im Mixer zu einer klebrigen Masse verarbeiten (ggf. etwas Wasser).','Zu 4 Kugeln rollen und 30 Minuten kühlen.'],'Eine Portion entspricht 4 Kugeln. Bis zu 5 Tage haltbar.')
r('Pute-Hüttenkäse-Röllchen','S',5,0,False,False,[('pute_auf',80),('huettenkaese',100),('gurke',80),('gewuerze',1)],['Pute flach ausbreiten.','Hüttenkäse und Gurkenstreifen darauf geben und aufrollen.'])

# --- Neu: von gut bewerteten Rezepten inspiriert (eigene, schnelle Varianten)
r('Fajita-Wraps mit Hähnchen','M',25,0,False,False,[('haehnchen',180),('paprika',150),('zwiebel',50),('wrap',124),('joghurt',50),('avocado',40),('rapsoel',6),('gewuerze',4),('salz',1)],
  ['Hähnchen und Gemüse in Streifen schneiden, mit Fajita-Gewürz mischen.','In Öl 8 Minuten scharf anbraten.','Wraps füllen, Joghurt und Avocado dazugeben und einrollen.'],'',4.7,'REWE: Mexikanische Fajitas (4,7/5)')
r('Tex-Mex-Reissalat','M',25,3,True,False,[('reis',70),('bohnen',100),('mais',60),('paprika',80),('tomate',80),('joghurt',40),('olivenoel',8),('gewuerze',3),('salz',1)],
  ['Reis kochen und abkühlen lassen.','Bohnen, Mais, Paprika und Tomaten würfeln und untermischen.','Mit Joghurt, Olivenöl und Gewürzen anmachen.'],'Hält 3 Tage kühl, gut für die Box.',4.3,'REWE: Tex-Mex Reissalat (4,3/5)')
r('Hirse-Gemüse-Pfanne mit Feta','M',25,3,True,False,[('hirse',70),('zucchini',150),('paprika',100),('champignons',100),('edamame',80),('feta',40),('rapsoel',8),('gewuerze',3),('salz',1)],
  ['Hirse in der doppelten Menge Wasser 12 Minuten garen.','Gemüse und Edamame in Öl 8 Minuten braten.','Hirse unterheben, Feta darüber bröseln.'],'',4.6,'REWE: Hirse-Gemüse-Pfanne (4,6/5)')
r('Orientalischer Bulgur mit Joghurt-Dip','M',25,3,True,False,[('bulgur',70),('kichererbsen',120),('tomate',100),('gurke',80),('joghurt',100),('olivenoel',8),('gewuerze',3),('salz',1)],
  ['Bulgur mit heißem Wasser quellen lassen.','Kichererbsen in Olivenöl mit Gewürzen anrösten.','Mit Tomaten und Gurke mischen, Joghurt mit Salz und Kräutern als Dip dazu.'],'',4.6,'REWE: Orientalischer Bulgur mit Schafjoghurt-Dip (4,6/5)')
r('Couscous-Pfanne mit Cashews und Edamame','M',20,0,True,True,[('couscous',70),('zucchini',150),('brokkoli',100),('edamame',100),('cashews',20),('rapsoel',6),('sojasauce',10)],
  ['Couscous mit heißem Wasser quellen lassen.','Gemüse und Edamame in Öl 8 Minuten braten, mit Sojasauce würzen.','Couscous und geröstete Cashews unterheben.'],'',4.2,'REWE: Grüne Gemüse-Couscouspfanne mit Cashews (4,2/5)')
r('Spirelli mit Zucchini-Hack-Soße','M',25,4,False,False,[('nudeln',90),('rinderhack',120),('zucchini',200),('passata',100),('zwiebel',40),('parmesan',10),('rapsoel',5),('gewuerze',3),('salz',1)],
  ['Nudeln kochen.','Hack mit Zwiebel anbraten, Zucchiniwürfel und Passata zugeben, 10 Minuten köcheln.','Nudeln unterheben, Parmesan darüber.'],'',None,'Idee: Für Sie, Meal-Prep-Rezepte')
r('Pesto-Hähnchen-Pasta','M',20,3,False,False,[('nudeln',80),('haehnchen',150),('pesto',25),('tomate',100),('spinat',60),('rapsoel',5),('salz',1)],
  ['Nudeln kochen.','Hähnchenwürfel in Öl braten, Tomaten und Spinat kurz mitgaren.','Mit Nudeln und Pesto mischen.'],'',None,'Idee: Für Sie, Meal-Prep-Rezepte')
r('Lachs mit Quinoa und Brokkoli','M',25,0,False,False,[('lachs',140),('quinoa',70),('brokkoli',150),('olivenoel',5),('senf',10),('salz',1)],
  ['Quinoa 12 Minuten kochen.','Lachs mit Senf bestreichen und in Öl 3–4 Minuten pro Seite braten.','Brokkoli 5 Minuten dämpfen und alles anrichten.'],'',None,'Idee: Für Sie, Meal-Prep-Rezepte')
r('Seelachs-One-Pot mit Gemüse','M',25,0,False,False,[('seelachs',200),('kartoffel',200),('karotte',80),('brokkoli',100),('tomaten_dose',100),('rapsoel',5),('gewuerze',3),('salz',1)],
  ['Kartoffel- und Karottenwürfel in Öl kurz anbraten.','Tomaten, 150 ml Wasser und Brokkoli zugeben, 10 Minuten garen.','Fischstücke daraufsetzen und 6 Minuten zugedeckt ziehen lassen.'],'',None,'Idee: Für Sie, Meal-Prep-Rezepte')
r('Thunfisch-Linsen-Salat im Glas','M',12,3,False,False,[('linsen_dose',150),('thunfisch',100),('paprika',80),('gurke',80),('zwiebel',30),('olivenoel',10),('senf',8),('salz',1)],
  ['Linsen abspülen und abtropfen.','Gemüse klein würfeln.','Alles mit Thunfisch, Öl, Senf und Salz mischen und in Gläser füllen.'],'Im Glas 3 Tage haltbar.',None,'Idee: Für Sie, Meal-Prep-Rezepte')
r('Ofen-Hähnchen mit Blumenkohl','M',30,3,False,False,[('haehnchen',200),('blumenkohl',300),('olivenoel',10),('joghurt',60),('gewuerze',3),('salz',1)],
  ['Blumenkohl in Röschen teilen, mit Öl und Gewürzen auf ein Blech.','Hähnchen würzen, dazulegen und 25 Minuten bei 200 °C backen.','Joghurt mit Salz und Kräutern als Dip servieren.'],'Wenig Kohlenhydrate.',None,'Idee: Für Sie, Meal-Prep-Rezepte')
r('Lachs-Geschnetzeltes mit Senfsauce','M',20,0,False,False,[('lachs',150),('joghurt',80),('senf',12),('zwiebel',40),('reis',60),('spinat',60),('rapsoel',5),('salz',1)],
  ['Reis kochen.','Zwiebel in Öl anbraten, Lachswürfel 3 Minuten mitbraten.','Joghurt und Senf einrühren, Spinat unterheben und über dem Reis servieren.'],'',None,'Idee: Für Sie, Meal-Prep-Rezepte')
r('Curry-Hähnchen-Wrap mit Apfel','M',15,0,False,False,[('wrap',124),('haehnchen',150),('joghurt',50),('apfel',60),('salat',40),('gewuerze',3),('rapsoel',5)],
  ['Hähnchenstreifen mit Currypulver in Öl braten.','Joghurt mit Curry verrühren, Apfel würfeln.','Alles in den Wraps einrollen.'],'',None,'Idee: Für Sie, Meal-Prep-Rezepte')
r('Kartoffeln mit Pilzen und Kräuterquark','M',25,0,True,False,[('kartoffel',300),('champignons',200),('quark',150),('zwiebel',40),('ei',55),('rapsoel',8),('gewuerze',2),('salz',1)],
  ['Kartoffeln kochen.','Zwiebel und Pilze in Öl kräftig braten.','Quark mit Kräutern und Salz anrühren, mit Kartoffeln, Pilzen und gekochtem Ei servieren.'],'',4.5,'REWE: Kartoffeln mit Pilzen (4,5/5)')
r('Brokkolitaler mit Joghurt-Dip','A',25,3,True,False,[('brokkoli',250),('ei',110),('hafer',40),('feta',40),('joghurt',80),('rapsoel',8),('salz',1)],
  ['Brokkoli kochen und fein hacken.','Mit Eiern, Haferflocken und Feta mischen, kleine Taler formen.','In Öl von beiden Seiten goldbraun braten, mit Joghurt servieren.'],'Warm oder kalt, 3 Tage haltbar.',4.4,'REWE: Kleine Brokkolitaler (4,4/5)')
r('Bunte Gemüsepfanne mit Quark-Zitronen-Dip','A',20,0,True,False,[('paprika',150),('zucchini',150),('brokkoli',100),('kichererbsen',100),('quark',100),('rapsoel',8),('gewuerze',3),('salz',1)],
  ['Gemüse in Stücke schneiden und in Öl 8 Minuten braten.','Kichererbsen zugeben und 3 Minuten mitbraten.','Quark mit Zitrone, Salz und Kräutern verrühren und dazu servieren.'],'',4.3,'REWE: Bunte Gemüsepfanne mit Zitronen-Dip (4,3/5)')
r('Hackfleisch-Salat im Glas','A',20,3,False,False,[('rinderhack',130),('salat',100),('mais',50),('bohnen',60),('tomate',100),('joghurt',40),('rapsoel',5),('gewuerze',3),('salz',1)],
  ['Hack mit Gewürzen in Öl krümelig braten und abkühlen lassen.','Gemüse klein schneiden.','In Gläsern schichten: Dressing, Bohnen, Mais, Hack, Tomate, Salat zuletzt.'],'',None,'Idee: Für Sie, Meal-Prep-Rezepte')
r('Schnelle Asia-Hackpfanne','A',15,3,False,False,[('puten_hack',180),('brokkoli',150),('karotte',60),('sojasauce',15),('reis',60),('rapsoel',5)],
  ['Reis kochen.','Hack in Öl krümelig braten, Gemüse in Stücken zugeben und 6 Minuten braten.','Mit Sojasauce ablöschen und mit Reis servieren.'])
r('Rührei-Wrap mit Paprika','F',10,0,True,False,[('ei',165),('wrap',62),('paprika',60),('quark',50),('rapsoel',5),('salz',1)],
  ['Paprika würfeln und in Öl 2 Minuten braten.','Eier mit Quark verquirlen, dazugeben und stocken lassen.','Im Wrap einrollen.'],'',None,'Idee: Für Sie, Meal-Prep-Rezepte')

exec(open('more.py').read())
RATINGS={'Chili con Pute mit Reis':(4.3,'REWE: Schnelles Chili con Pute (4,3/5)'),'Protein-Porridge':(4.5,'REWE: Protein Porridge (4,5/5)'),'Rote-Linsen-Dal mit Reis':(3.7,'REWE: Indisches Dhal mit Spinat (3,7/5)')}
for k,rec in enumerate(R):
    if len(rec)==9:
        rt=RATINGS.get(rec[0]); R[k]=rec+((rt[0],rt[1]) if rt else (None,''))
# --- Auswertung
def mac(ings):
    k=p=f=c=s=pr=0.0
    for key,g in ings:
        n,kc,P,F,C,S,PR=ING[key]; m=g/100
        k+=kc*m;p+=P*m;f+=F*m;c+=C*m;s+=S*m;pr+=PR*m
    return k,p,f,c,s,pr
if __name__=='__main__':
    import sys
    print(len(R),'Rezepte,',len(ING),'Zutaten')
    for rec in R:
        k,p,f,c,s,pr=mac(rec[6])
        print(f"{rec[0][:42]:42} {rec[1]} {rec[2]:>3}min  {k:5.0f} kcal P{p:4.0f} F{f:4.0f} K{c:4.0f} Salz{s:4.1f}  {pr:4.2f}€  carb%={c*4/k*100:3.0f} prot%={p*4/k*100:3.0f}")
