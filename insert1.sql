
prompt #---------------------#
prompt #- Pomocne procedury -#
prompt #---------------------#

create or replace procedure SMAZ_VSECHNY_TABULKY AS
-- pokud v logu bude uvedeno, ze nektery objekt nebyl zrusen, protoze na nej jiny jeste existujici objekt stavi, spust proceduru opakovane, dokud se nezrusi vse
begin
  for iRec in 
    (select distinct OBJECT_TYPE, OBJECT_NAME,
      'drop '||OBJECT_TYPE||' "'||OBJECT_NAME||'"'||
      case OBJECT_TYPE when 'TABLE' then ' cascade constraints purge' else ' ' end as PRIKAZ
    from USER_OBJECTS where OBJECT_NAME not in ('SMAZ_VSECHNY_TABULKY', 'VYPNI_CIZI_KLICE', 'ZAPNI_CIZI_KLICE', 'VYMAZ_DATA_VSECH_TABULEK')
    ) loop
        begin
          dbms_output.put_line('Prikaz: '||irec.prikaz);
        execute immediate iRec.prikaz;
        exception
          when others then dbms_output.put_line('NEPOVEDLO SE!');
        end;
      end loop;
end;
/

create or replace procedure VYPNI_CIZI_KLICE as 
begin
  for cur in (select CONSTRAINT_NAME, TABLE_NAME from USER_CONSTRAINTS where CONSTRAINT_TYPE = 'R' ) 
  loop
    execute immediate 'alter table '||cur.TABLE_NAME||' modify constraint "'||cur.CONSTRAINT_NAME||'" DISABLE';
  end loop;
end VYPNI_CIZI_KLICE;
/


create or replace procedure ZAPNI_CIZI_KLICE as 
begin
  for cur in (select CONSTRAINT_NAME, TABLE_NAME from USER_CONSTRAINTS where CONSTRAINT_TYPE = 'R' ) 
  loop
    execute immediate 'alter table '||cur.TABLE_NAME||' modify constraint "'||cur.CONSTRAINT_NAME||'" enable validate';
  end loop;
end ZAPNI_CIZI_KLICE;
/

create or replace procedure VYMAZ_DATA_VSECH_TABULEK is
begin
  -- Vymazat data vsech tabulek
  VYPNI_CIZI_KLICE;
  for v_rec in (select distinct TABLE_NAME from USER_TABLES)
  loop
    execute immediate 'truncate table '||v_rec.TABLE_NAME||' drop storage';
  end loop;
  ZAPNI_CIZI_KLICE;
  
  -- Nastavit vsechny sekvence od 1
  for v_rec in (select distinct SEQUENCE_NAME  from USER_SEQUENCES)
  loop
    execute immediate 'alter sequence '||v_rec.SEQUENCE_NAME||' restart start with 1';
  end loop;
end VYMAZ_DATA_VSECH_TABULEK;
/

prompt #------------------------#
prompt #- Zrusit stare tabulky -#
prompt #------------------------#



exec VYMAZ_DATA_VSECH_TABULEK

insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (1, 'Austen', 'Spandley', 53, 'Male', 'Vlekar');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (2, 'Ulla', 'Albisser', 39, 'Female', 'Instruktor');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (3, 'Gisella', 'Larder', 65, 'Female', 'Maser');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (4, 'Stanleigh', 'Brozek', 29, 'Male', 'Vlekar');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (5, 'Darlleen', 'Romi', 75, 'Female', 'Instruktor');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (6, 'Mateo', 'Emmins', 18, 'Male', 'Instruktor');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (7, 'Spencer', 'Cleynaert', 40, 'Male', 'Maser');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (8, 'Dot', 'Craighall', 80, 'Female', 'Maser');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (9, 'Nicky', 'Cattlow', 50, 'Female', 'Vlekar');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (10, 'Letta', 'Cuerdale', 17, 'Female', 'Instruktor');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (11, 'Avigdor', 'Beldon', 67, 'Male', 'Vlekar');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (12, 'Nils', 'Fortman', 20, 'Male', 'Vlekar');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (13, 'Myles', 'Gratrex', 77, 'Male', 'Instruktor');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (14, 'Prentiss', 'Hayler', 16, 'Male', 'Instruktor');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (15, 'Celinda', 'O''Hara', 16, 'Female', 'Instruktor');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (16, 'Miguela', 'Wessing', 63, 'Female', 'Instruktor');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (17, 'Ginevra', 'Janic', 58, 'Female', 'Maser');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (18, 'Lorie', 'Durante', 74, 'Female', 'Vlekar');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (19, 'Andree', 'Rizzillo', 63, 'Female', 'Maser');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (20, 'Hasty', 'Robottham', 38, 'Male', 'Instruktor');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (21, 'Damien', 'Goldson', 38, 'Male', 'Maser');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (22, 'Layney', 'Fishburn', 39, 'Female', 'Maser');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (23, 'Jeremias', 'Eadie', 57, 'Male', 'Vlekar');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (24, 'Kalli', 'Carmont', 20, 'Female', 'Vlekar');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (25, 'Robert', 'Fenlon', 19, 'Male', 'Instruktor');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (26, 'Lisa', 'O'' Cuolahan', 60, 'Female', 'Maser');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (27, 'Kiersten', 'Dallimore', 61, 'Female', 'Vlekar');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (28, 'Wake', 'Clewarth', 67, 'Male', 'Maser');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (29, 'Shina', 'Hoodspeth', 68, 'Female', 'Instruktor');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (30, 'Juliann', 'Bowhay', 39, 'Female', 'Maser');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (31, 'Leo', 'Lyon', 80, 'Male', 'Vlekar');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (32, 'Damian', 'Chessill', 40, 'Male', 'Maser');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (33, 'Sergent', 'Saltwell', 75, 'Male', 'Maser');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (34, 'Danika', 'Moulster', 27, 'Female', 'Instruktor');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (35, 'Morgan', 'Auguste', 44, 'Male', 'Instruktor');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (36, 'Kaiser', 'Dawson', 67, 'Male', 'Vlekar');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (37, 'Ivan', 'Wilkie', 36, 'Male', 'Maser');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (38, 'Rubie', 'Bedding', 22, 'Female', 'Instruktor');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (39, 'Clea', 'Buttriss', 75, 'Female', 'Vlekar');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (40, 'Jase', 'Fussen', 47, 'Male', 'Instruktor');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (41, 'Glen', 'Imlock', 15, 'Male', 'Instruktor');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (42, 'Cristin', 'Moulsdall', 61, 'Female', 'Instruktor');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (43, 'Ari', 'Jennison', 64, 'Male', 'Instruktor');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (44, 'Homer', 'Matussov', 42, 'Male', 'Maser');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (45, 'Morena', 'McGreary', 72, 'Female', 'Maser');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (46, 'Kandy', 'Orrell', 71, 'Female', 'Instruktor');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (47, 'Edmon', 'McLoughlin', 72, 'Male', 'Vlekar');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (48, 'Alysa', 'Inglesent', 80, 'Female', 'Vlekar');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (49, 'Tommie', 'Duligall', 22, 'Male', 'Maser');
insert into ZAMESTNANEC (id_zamestnanec, jmeno, prijmeni, vek, pohlavi, zamestnanec_type) values (50, 'Granthem', 'Crann', 69, 'Male', 'Instruktor');




insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (1, 'Zacharie', 'Cammacke', 'Male', 'zcammacke0@technorati.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (2, 'Gerome', 'Beevens', 'Male', 'gbeevens1@webeden.co.uk');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (3, 'Bernarr', 'Issit', 'Male', 'bissit2@elpais.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (4, 'Sheffie', 'Kent', 'Male', 'skent3@usda.gov');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (5, 'Barbi', 'Syncke', 'Female', 'bsyncke4@parallels.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (6, 'Colan', 'Tibbles', 'Male', 'ctibbles5@ucoz.ru');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (7, 'Cary', 'Turbayne', 'Female', 'cturbayne6@1und1.de');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (8, 'Roz', 'Alcock', 'Female', 'ralcock7@marriott.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (9, 'Angelika', 'Dagon', 'Female', 'adagon8@wikimedia.org');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (10, 'Baird', 'Jankovic', 'Male', 'bjankovic9@shop-pro.jp');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (11, 'Reuben', 'Book', 'Male', 'rbooka@nasa.gov');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (12, 'Chane', 'Scriviner', 'Male', 'cscrivinerb@cnbc.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (13, 'Ennis', 'Hazleton', 'Male', 'ehazletonc@smh.com.au');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (14, 'Rodolphe', 'Morsom', 'Male', 'rmorsomd@google.co.uk');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (15, 'Berk', 'Eldredge', 'Male', 'beldredgee@google.com.au');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (16, 'Quinn', 'Penniall', 'Female', 'qpenniallf@amazon.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (17, 'Rosanne', 'Furmage', 'Female', 'rfurmageg@scribd.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (18, 'Morissa', 'Keasey', 'Female', 'mkeaseyh@wired.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (19, 'Rossie', 'Ide', 'Male', 'ridei@wp.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (20, 'Aubrie', 'Peyto', 'Female', 'apeytoj@google.co.jp');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (21, 'Lorena', 'Ogley', 'Female', 'logleyk@accuweather.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (22, 'Arnie', 'Dodgshon', 'Male', 'adodgshonl@google.es');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (23, 'Elroy', 'Fries', 'Male', 'efriesm@clickbank.net');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (24, 'Antony', 'Harmes', 'Male', 'aharmesn@hao123.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (25, 'Mommy', 'Colliber', 'Female', 'mcollibero@youtu.be');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (26, 'Lynde', 'Iorizzi', 'Female', 'liorizzip@ftc.gov');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (27, 'Rosemaria', 'Buncombe', 'Female', 'rbuncombeq@npr.org');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (28, 'Powell', 'Dubarry', 'Male', 'pdubarryr@photobucket.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (29, 'Harlen', 'Bines', 'Male', 'hbiness@macromedia.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (30, 'Keelby', 'Hemms', 'Male', 'khemmst@vkontakte.ru');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (31, 'Nalani', 'Seebert', 'Female', 'nseebertu@narod.ru');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (32, 'Annalise', 'Feben', 'Female', 'afebenv@printfriendly.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (33, 'Rubi', 'Sekulla', 'Female', 'rsekullaw@google.com.au');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (34, 'Lynne', 'Singleton', 'Female', 'lsingletonx@cmu.edu');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (35, 'Mart', 'Tatham', 'Male', 'mtathamy@qq.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (36, 'Rolland', 'Neeves', 'Male', 'rneevesz@thetimes.co.uk');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (37, 'Dalia', 'Aubury', 'Female', 'daubury10@harvard.edu');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (38, 'Zia', 'Bucknell', 'Female', 'zbucknell11@wiley.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (39, 'Nance', 'Josupeit', 'Female', 'njosupeit12@zdnet.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (40, 'Benedick', 'Scatcher', 'Male', 'bscatcher13@npr.org');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (41, 'Riannon', 'Burk', 'Female', 'rburk14@ox.ac.uk');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (42, 'Ruben', 'Terrell', 'Male', 'rterrell15@example.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (43, 'Chester', 'Houldcroft', 'Male', 'chouldcroft16@opensource.org');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (44, 'Parrnell', 'Harler', 'Male', 'pharler17@yahoo.co.jp');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (45, 'Constancy', 'Ivons', 'Female', 'civons18@ifeng.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (46, 'Mari', 'Vockins', 'Female', 'mvockins19@deliciousdays.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (47, 'Barnard', 'Strognell', 'Male', 'bstrognell1a@last.fm');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (48, 'Kathlin', 'Blondin', 'Female', 'kblondin1b@networkadvertising.org');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (49, 'Amber', 'Elcome', 'Female', 'aelcome1c@chronoengine.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (50, 'Molli', 'Krojn', 'Female', 'mkrojn1d@etsy.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (51, 'Charleen', 'Beran', 'Female', 'cberan1e@wordpress.org');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (52, 'Svend', 'Frowd', 'Male', 'sfrowd1f@posterous.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (53, 'Augustin', 'Windybank', 'Male', 'awindybank1g@imdb.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (54, 'Marita', 'Adair', 'Female', 'madair1h@aboutads.info');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (55, 'Meridith', 'Brearty', 'Female', 'mbrearty1i@yale.edu');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (56, 'Hagan', 'Sherringham', 'Male', 'hsherringham1j@ycombinator.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (57, 'Devin', 'Garrison', 'Female', 'dgarrison1k@moonfruit.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (58, 'Hermy', 'Wyett', 'Male', 'hwyett1l@netlog.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (59, 'Verna', 'Madelin', 'Female', 'vmadelin1m@arizona.edu');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (60, 'Dela', 'Mattessen', 'Female', 'dmattessen1n@surveymonkey.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (61, 'Garald', 'Demonge', 'Male', 'gdemonge1o@simplemachines.org');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (62, 'Noe', 'O''Shaughnessy', 'Male', 'noshaughnessy1p@stanford.edu');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (63, 'Angeli', 'Sandiland', 'Male', 'asandiland1q@unesco.org');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (64, 'Aharon', 'Jorg', 'Male', 'ajorg1r@mtv.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (65, 'Emelyne', 'Payne', 'Female', 'epayne1s@about.me');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (66, 'Rasla', 'Bryns', 'Female', 'rbryns1t@blogger.com');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (67, 'Crichton', 'Husselbee', 'Male', 'chusselbee1u@google.com.au');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (68, 'Graeme', 'Tremolieres', 'Male', 'gtremolieres1v@a8.net');
insert into ZAKAZNIK (id_zakaznik, jmeno, prijmeni, pohlavi, email) values (69, 'Perl', 'Hindmore', 'Female', 'phindmore1w@shareasale.com');



commit;