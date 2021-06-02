
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

prompt #--------------------------#
prompt #-- Old tables go poooof --#
prompt #--------------------------#



exec VYMAZ_DATA_VSECH_TABULEK


prompt #--------------------------#
prompt #-- New tables go vruuum --#
prompt #--------------------------#

insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (1, 'Andy', 'Dymock', 34, 'Žena');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (2, 'Nick', 'Cahn', 42, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (3, 'Lilla', 'Commin', 15, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (4, 'Clarie', 'Starmer', 51, 'Žena');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (5, 'Danni', 'Murphey', 55, 'Žena');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (6, 'Gerrie', 'Scallan', 31, 'Žena');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (7, 'Chryste', 'Lanfear', 23, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (8, 'Sully', 'Cleiment', 58, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (9, 'Zolly', 'Attwell', 27, 'Žena');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (10, 'Stevie', 'Purrington', 62, 'Žena');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (11, 'Tracie', 'Godon', 39, 'Žena');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (12, 'Sylvan', 'Jorin', 65, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (13, 'Yehudi', 'Gebbe', 48, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (14, 'Bernita', 'Lummus', 28, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (15, 'Urbanus', 'Habron', 24, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (16, 'Marjorie', 'Banasevich', 45, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (17, 'Delmore', 'Butrimovich', 22, 'Žena');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (18, 'Emmi', 'Munkley', 15, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (19, 'Tully', 'Byrne', 15, 'Žena');

insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (20, 'Snoop', 'Dogg', 48, 'Muž');

insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (21, 'Nadine', 'Coumbe', 27, 'Žena');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (22, 'Orel', 'Sherwill', 53, 'Žena');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (23, 'Lona', 'Whitney', 43, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (24, 'David', 'Maykin', 44, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (25, 'Gael', 'Davall', 58, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (26, 'Allard', 'Dabels', 36, 'Žena');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (27, 'Bea', 'Ferrey', 16, 'Žena');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (28, 'Tye', 'Fireman', 19, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (29, 'Nelli', 'Rance', 57, 'Žena');

insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (30, 'Nelli', 'Cardew', 53, 'Žena');	--instruktori
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (31, 'Randall', 'Clown', 45, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (32, 'Simonette', 'Cleworth', 67, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (33, 'Beniamino', 'Bolderstone', 17, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (34, 'Carmelina', 'Sweeten', 34, 'Žena');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (35, 'Farlie', 'Clown', 22, 'Žena'); ----
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (36, 'Madge', 'Le Noire', 28, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (37, 'Marcille', 'Haily', 35, 'Žena');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (38, 'Stafani', 'Inkpen', 64, 'Žena');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (39, 'Allys', 'Durden', 58, 'Žena');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (40, 'Aigneis', 'Oiller', 25, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (41, 'Marguerite', 'Ullett', 33, 'Žena');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (42, 'Nanon', 'Clown', 22, 'Žena'); ----
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (43, 'Jamima', 'Peverell', 63, 'Žena');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (44, 'Dyana', 'Mitcheson', 39, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (45, 'Gavan', 'Lefeuvre', 46, 'Muž');

insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (46, 'Dědeček', 'Hříbeček', 75, 'Muž');
insert into ZAMESTNANEC (ID_ZAMESTNANEC, JMENO, PRIJMENI, VEK, POHLAVI) values (47, 'Babička', 'Palička', 75, 'Žena');


prompt #--------------------------#
prompt #-- VLEKARboys go vruuum --#
prompt #--------------------------#

insert into VLEKAR (ZAMESTNANEC_ID_ZAMESTNANEC) values (1);
insert into VLEKAR (ZAMESTNANEC_ID_ZAMESTNANEC) values (2);
insert into VLEKAR (ZAMESTNANEC_ID_ZAMESTNANEC) values (3);
insert into VLEKAR (ZAMESTNANEC_ID_ZAMESTNANEC) values (4);
insert into VLEKAR (ZAMESTNANEC_ID_ZAMESTNANEC) values (5);
insert into VLEKAR (ZAMESTNANEC_ID_ZAMESTNANEC) values (6);
insert into VLEKAR (ZAMESTNANEC_ID_ZAMESTNANEC) values (7);
insert into VLEKAR (ZAMESTNANEC_ID_ZAMESTNANEC) values (8);
insert into VLEKAR (ZAMESTNANEC_ID_ZAMESTNANEC) values (9);
insert into VLEKAR (ZAMESTNANEC_ID_ZAMESTNANEC) values (10);
insert into VLEKAR (ZAMESTNANEC_ID_ZAMESTNANEC) values (11);
insert into VLEKAR (ZAMESTNANEC_ID_ZAMESTNANEC) values (12);
insert into VLEKAR (ZAMESTNANEC_ID_ZAMESTNANEC) values (13);
insert into VLEKAR (ZAMESTNANEC_ID_ZAMESTNANEC) values (20);
insert into VLEKAR (ZAMESTNANEC_ID_ZAMESTNANEC) values (15);

prompt #--------------------------#
prompt #-- MASERboyss go vruuum --#
prompt #--------------------------#

insert into MASER (ZAMESTNANEC_ID_ZAMESTNANEC) values (15);
insert into MASER (ZAMESTNANEC_ID_ZAMESTNANEC) values (16);
insert into MASER (ZAMESTNANEC_ID_ZAMESTNANEC) values (17);
insert into MASER (ZAMESTNANEC_ID_ZAMESTNANEC) values (18);
insert into MASER (ZAMESTNANEC_ID_ZAMESTNANEC) values (19);
insert into MASER (ZAMESTNANEC_ID_ZAMESTNANEC) values (20);
insert into MASER (ZAMESTNANEC_ID_ZAMESTNANEC) values (22);
insert into MASER (ZAMESTNANEC_ID_ZAMESTNANEC) values (23);
insert into MASER (ZAMESTNANEC_ID_ZAMESTNANEC) values (24);
insert into MASER (ZAMESTNANEC_ID_ZAMESTNANEC) values (25);
insert into MASER (ZAMESTNANEC_ID_ZAMESTNANEC) values (26);
insert into MASER (ZAMESTNANEC_ID_ZAMESTNANEC) values (27);
insert into MASER (ZAMESTNANEC_ID_ZAMESTNANEC) values (28);
insert into MASER (ZAMESTNANEC_ID_ZAMESTNANEC) values (29);
insert into MASER (ZAMESTNANEC_ID_ZAMESTNANEC) values (30);

prompt #--------------------------#
prompt #-- INSTRUKTOR go vruuum --#
prompt #--------------------------#

insert into INSTRUKTOR (ZAMESTNANEC_ID_ZAMESTNANEC) values (30);
insert into INSTRUKTOR (ZAMESTNANEC_ID_ZAMESTNANEC) values (31); --
insert into INSTRUKTOR (ZAMESTNANEC_ID_ZAMESTNANEC) values (32);
insert into INSTRUKTOR (ZAMESTNANEC_ID_ZAMESTNANEC) values (33);
insert into INSTRUKTOR (ZAMESTNANEC_ID_ZAMESTNANEC) values (34);
insert into INSTRUKTOR (ZAMESTNANEC_ID_ZAMESTNANEC) values (35); --
insert into INSTRUKTOR (ZAMESTNANEC_ID_ZAMESTNANEC) values (36);
insert into INSTRUKTOR (ZAMESTNANEC_ID_ZAMESTNANEC) values (37);
insert into INSTRUKTOR (ZAMESTNANEC_ID_ZAMESTNANEC) values (39);
insert into INSTRUKTOR (ZAMESTNANEC_ID_ZAMESTNANEC) values (15);
insert into INSTRUKTOR (ZAMESTNANEC_ID_ZAMESTNANEC) values (20);
insert into INSTRUKTOR (ZAMESTNANEC_ID_ZAMESTNANEC) values (42); --
insert into INSTRUKTOR (ZAMESTNANEC_ID_ZAMESTNANEC) values (43);
insert into INSTRUKTOR (ZAMESTNANEC_ID_ZAMESTNANEC) values (44);


insert into PUJCOVNA (ID_PUJCOVNA, POCET_LYZE, POCET_SNOWBOARD, POCET_BEZKY, POCET_SANKY, ZAMESTNANEC_ID_ZAMESTNANEC) values (1, 18, 14, 4, 13, 10);
insert into PUJCOVNA (ID_PUJCOVNA, POCET_LYZE, POCET_SNOWBOARD, POCET_BEZKY, POCET_SANKY, ZAMESTNANEC_ID_ZAMESTNANEC) values (2, 31, 55, 47, 71, 43);
insert into PUJCOVNA (ID_PUJCOVNA, POCET_LYZE, POCET_SNOWBOARD, POCET_BEZKY, POCET_SANKY, ZAMESTNANEC_ID_ZAMESTNANEC) values (3, 68, 94, 3, 57, 28);
insert into PUJCOVNA (ID_PUJCOVNA, POCET_LYZE, POCET_SNOWBOARD, POCET_BEZKY, POCET_SANKY, ZAMESTNANEC_ID_ZAMESTNANEC) values (4, 0, 59, 46, 64, 14);
insert into PUJCOVNA (ID_PUJCOVNA, POCET_LYZE, POCET_SNOWBOARD, POCET_BEZKY, POCET_SANKY, ZAMESTNANEC_ID_ZAMESTNANEC) values (5, 29, 93, 66, 81, 29);


insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (1, 'id', 'Střední', '8-Sedačka', 'Ano', 'Mimo provoz', 4);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (2, 'ligula', 'Těžká', 'Poma', 'Ne', 'V provozu', 10);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (3, 'vulputate', 'Lehká', '6-Sedačka', 'Ano', 'V provozu', 7);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (4, 'Chacharov', 'Střední', '8-Sedačka', 'Ano', 'Mimo provoz', 12);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (5, 'Chacharov', 'Těžká', 'Poma', 'Ne', 'V provozu', 5);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (6, 'nascetur', 'Lehká', '4-Sedačka', 'Ne', 'Mimo provoz', 10);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (7, 'donec', 'Střední', '8-Sedačka', 'Ano', 'V provozu', 10);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (8, 'sed', 'Lehká', 'Poma', 'Ano', 'V provozu', 3);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (9, 'pellentesque', 'Těžká', 'Poma', 'Ano', 'Mimo provoz', 11);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (10, 'tristique', 'Těžká', '4-Sedačka', 'Ano', 'Mimo provoz', 20);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (11, 'proin', 'Lehká', 'Kotva', 'Ano', 'Mimo provoz', 4);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (12, 'justo', 'Střední', '6-Sedačka', 'Ano', 'Mimo provoz', 11);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (13, 'Chacharov', 'Lehká', '6-Sedačka', 'Ano', 'Mimo provoz', 13);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (14, 'ipsum', 'Těžká', '6-Sedačka', 'Ne', 'Mimo provoz', 7);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (15, 'aliquam', 'Lehká', 'Kotva', 'Ano', 'Mimo provoz', 15);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (16, 'quis', 'Lehká', '6-Sedačka', 'Ano', 'V provozu', 5);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (17, 'vel', 'Těžká', 'Kabinka', 'Ano', 'V provozu', 4);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (18, 'Chacharov', 'Střední', '4-Sedačka', 'Ne', 'Mimo provoz', 12);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (19, 'penatibus', 'Střední', '6-Sedačka', 'Ano', 'Mimo provoz', 4);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (20, 'iaculis', 'Střední', 'Poma', 'Ne', 'Mimo provoz', 6);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (21, 'vestibulum', 'Těžká', 'Kotva', 'Ano', 'V provozu', 4);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (22, 'integer', 'Střední', 'Kotva', 'Ano', 'V provozu', 11);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (23, 'vivamus', 'Lehká', 'Kotva', 'Ano', 'Mimo provoz', 8);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (24, 'lacinia', 'Lehká', '4-Sedačka', 'Ano', 'V provozu', 2);
insert into SJEZDOVKA (ID_SJEZDOVKA, MISTO, NAROCNOST, TYP_VLEKU, NOCNI_LYZOVANI, STAV, VLEKAR_ID_ZAMESTNANEC) values (25, 'convallis', 'Lehká', '4-Sedačka', 'Ne', 'Mimo provoz', 8);

prompt #--------------------------#
prompt #-- ZAKAZNICI go REEEEEE --#
prompt #--------------------------#

insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (1, 'Barrie', 'Diviney', 'Muž', 'bdiviney0@dailymail.co.uk', '8405988226');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (2, 'Ase', 'Youthed', 'Muž', 'ayouthed1@cloudflare.com', '2616318963');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (3, 'Jaimie', 'Fiddeman', 'Žena', 'jfiddeman2@dmoz.org', '8671876522');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (4, 'Woodman', 'Clue', 'Žena', 'wclue3@exblog.jp', '8747815786');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (5, 'Tova', 'Filippello', 'Žena', 'tfilippello4@deliciousdays.com', '7376141174');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (6, 'Wade', 'Crumly', 'Žena', 'wcrumly5@house.gov', '4622543203');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (7, 'Merry', 'Domokos', 'Muž', 'mdomokos6@twitter.com', '5873519081');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (8, 'Ida', 'Binnie', 'Žena', 'ibinnie7@blogspot.com', '9281695772');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (9, 'Joelynn', 'Mickan', 'Muž', 'jmickan8@amazon.de', '7356392562');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (10, 'Aylmar', 'Prudence', 'Muž', 'aprudence9@cdbaby.com', '6574326528');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (11, 'Jaynell', 'Hayzer', 'Žena', 'jhayzera@furl.net', '3287367518');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (12, 'Kassi', 'Winterborne', 'Muž', 'kwinterborneb@alexa.com', '1376612817');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (13, 'Faunie', 'Deakins', 'Muž', 'fdeakinsc@mtv.com', '4057856126');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (14, 'Clemmie', 'Carous', 'Žena', 'ccarousd@51.la', '5496835524');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (15, 'Corina', 'Stickley', 'Žena', 'cstickleye@domainmarket.com', '9471900853');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (16, 'Marlo', 'Silk', 'Muž', 'msilkf@ehow.com', '4405063592');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (17, 'Whitney', 'Bour', 'Žena', 'wbourg@dropbox.com', '6719729953');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (18, 'Chane', 'Norgate', 'Žena', 'cnorgateh@comcast.net', '5122844762');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (19, 'Isabelle', 'Carslaw', 'Žena', 'icarslawi@dion.ne.jp', '6218089857');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (20, 'Kirk', 'Hutson', 'Muž', 'khutsonj@ovh.net', '4535273326');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (21, 'Wiley', 'Robey', 'Muž', null, '4455601797');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (22, 'Terese', 'Winscum', 'Muž', 'twinscuml@princeton.edu', '6309584095');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (23, 'Orsola', 'Fenck', 'Žena', 'ofenckm@wiley.com', '8736792039');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (24, 'Joseph', 'Toth', 'Žena', 'jtothn@dailymail.co.uk', '9671057459');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (25, 'Marne', 'Luno', 'Žena', 'mlunoo@stanford.edu', '9117109160');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (26, 'Peg', 'Dominici', 'Žena', 'pdominicip@earthlink.net', '4234424156');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (27, 'Sherye', 'Cristoferi', 'Muž', 'scristoferiq@altervista.org', '2605507031');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (28, 'Kilian', 'Clethro', 'Žena', 'kclethror@cmu.edu', '7736753380');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (29, 'Konrad', 'O''Kenny', 'Žena', 'kokennys@ebay.com', '2921071912');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (30, 'Waylen', 'Load', 'Žena', 'wloadt@soup.io', '6451558650');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (31, 'Inge', 'Greaser', 'Muž', 'igreaseru@oakley.com', null);
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (32, 'Farrel', 'Ather', 'Žena', 'fatherv@weebly.com', '5006559534');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (33, 'Prinz', 'Swainson', 'Žena', 'pswainsonw@oakley.com', '7916313819');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (34, 'Lizbeth', 'Emerton', 'Žena', 'lemertonx@cisco.com', '7474171944');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (35, 'Caroline', 'Stubbert', 'Muž', 'cstubberty@rambler.ru', '5855396422');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (36, 'Kenon', 'Stellman', 'Muž', 'kstellmanz@comcast.net', '7402388053');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (37, 'Alfonse', 'Parsley', 'Žena', null, '4424657455');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (38, 'Huntington', 'Elijah', 'Žena', 'helijah11@dot.gov', '9327923789');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (39, 'Marlo', 'Pounds', 'Žena', 'mpounds12@woothemes.com', '9091576023');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (40, 'Oralia', 'Timberlake', 'Žena', 'otimberlake13@nbcnews.com', '2108671442');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (41, 'Jessie', 'MacArdle', 'Muž', 'jmacardle14@macromedia.com', '3052828999');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (42, 'Merwyn', 'Doust', 'Muž', 'mdoust15@php.net', '8794050001');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (43, 'Kipp', 'Langfat', 'Žena', 'klangfat16@plala.or.jp', '9289632423');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (44, 'Bartholemy', 'Arthey', 'Muž', 'barthey17@geocities.com', '8423909722');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (45, 'Cullan', 'Borlease', 'Žena', 'cborlease18@usa.gov', '1428700858');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (46, 'Josepha', 'Kitchingman', 'Muž', 'jkitchingman19@amazon.co.jp', '9864349435');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (47, 'Brodie', 'Cockney', 'Žena', 'bcockney1a@forbes.com', '6939548801'); --
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (48, 'Ulrick', 'Rose', 'Muž', 'urose1b@si.edu', '7887906531');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (49, 'Arni', 'Cockney', 'Žena', 'acockney@about.com', '2583564207'); --
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (50, 'Shelby', 'Callis', 'Žena', 'scallis1d@clickbank.net', '3321936167');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (51, 'Keefer', 'Jerzak', 'Žena', 'kjerzak1e@vistaprint.com', '5824662376');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (52, 'Curcio', 'Causey', 'Žena', 'ccausey1f@behance.net', '9377620001');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (53, 'Chalmers', 'Pecey', 'Muž', 'cpecey1g@smh.com.au', '5004508912');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (54, 'Sada', 'Klesel', 'Žena', 'sklesel1h@indiatimes.com', '4979127024');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (55, 'Veriee', 'Blewitt', 'Muž', 'vblewitt1i@samsung.com', '1981137054');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (56, 'Pincus', 'Brockie', 'Muž', 'pbrockie1j@icq.com', '5767816101');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (57, 'Nell', 'Bunce', 'Žena', 'nbunce1k@samsung.com', null);
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (58, 'Rowena', 'Cockney', 'Žena', 'rcockney2@scientificamerican.com', '8871193328'); --
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (59, 'Lorelle', 'Dearnly', 'Muž', 'ldearnly1m@dell.com', '5007482520');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (60, 'Ede', 'Klagges', 'Muž', 'eklagges1n@google.fr', '2226113301');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (61, 'Arie', 'Dalziell', 'Žena', 'adalziell1o@arstechnica.com', '4247905245');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (62, 'Adam', 'Ambrosio', 'Muž', 'aambrosio1p@deliciousdays.com', '1333289268');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (63, 'Karen', 'Lidster', 'Žena', 'klidster1q@baidu.com', null);
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (64, 'Carrie', 'Burril', 'Žena', 'cburril1r@webeden.co.uk', '3418216147');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (65, 'Ernesta', 'Edy', 'Muž', 'eedy1s@dell.com', '7478911303');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (66, 'Anatole', 'Sennett', 'Muž', 'asennett1t@people.com.cn', '9259629125');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (67, 'Jess', 'McDonell', 'Žena', 'jmcdonell1u@oakley.com', '1459819076');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (68, 'Nissie', 'Shower', 'Muž', 'nshower1v@nationalgeographic.com', '1495559618');

insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (69, 'Boss', 'Matoušek', 'Muž', 'matousekboss@cvut.cz', '6942066669'); --here

insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (70, 'Clem', 'Dockrill', 'Muž', 'cdockrill1x@ftc.gov', '3032430364');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (71, 'Darda', 'Nicely', 'Muž', 'dnicely1y@amazon.co.uk', '3665009852');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (72, 'Casar', 'Kitson', 'Žena', 'ckitson1z@ibm.com', '8172607066');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (73, 'Egan', 'Zorener', 'Muž', 'ezorener20@ocn.ne.jp', '1318605947');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (74, 'Ikey', 'Blackadder', 'Žena', 'iblackadder21@yahoo.co.jp', null);
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (75, 'Karlis', 'Pea', 'Muž', 'kpea22@skyrock.com', '7901480965');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (76, 'Diarmid', 'Cosser', 'Žena', 'dcosser23@cam.ac.uk', '5612078372');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (77, 'Clem', 'Turvey', 'Muž', 'cturvey24@blinklist.com', '8873763761');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (78, 'Selie', 'Northridge', 'Muž', 'snorthridge25@1und1.de', '3861185676');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (79, 'Karlen', 'Extill', 'Muž', 'kextill26@chron.com', '3139069125');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (80, 'Maiga', 'Conelly', 'Muž', 'mconelly27@gov.uk', '4925777325');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (81, 'Eleonora', 'Cordingley', 'Muž', 'ecordingley28@cafepress.com', '8249983982');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (82, 'Michele', 'Antal', 'Žena', 'mantal29@istockphoto.com', '8011782635');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (83, 'Dalia', 'Moodey', 'Žena', 'dmoodey2a@barnesandnoble.com', '3312835233');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (84, 'Renard', 'Griffithe', 'Žena', null, null);
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (85, 'Tan', 'Orpen', 'Muž', 'torpen2c@baidu.com', '6952493513');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (86, 'Justin', 'Rankmore', 'Muž', 'jrankmore2d@umn.edu', '8449832073');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (87, 'Germayne', 'Whopples', 'Muž', 'gwhopples2e@imdb.com', '6336807459');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (88, 'Taddeo', 'Sommer', 'Žena', 'tsommer2f@patch.com', '6047697645');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (89, 'Edward', 'Agg', 'Muž', 'eagg2g@blogtalkradio.com', null);
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (90, 'Micki', 'Ullrich', 'Muž', 'mullrich2h@youtube.com', '2043034395');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (91, 'Max', 'Grindley', 'Muž', 'mgrindley2i@parallels.com', '8542380917');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (92, 'Thekla', 'Meaney', 'Žena', 'tmeaney2j@google.com', '3556354348');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (93, 'Trista', 'Astall', 'Žena', 'tastall2k@senate.gov', '2863452594');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (94, 'Virgie', 'Grizard', 'Žena', 'vgrizard2l@time.com', '5144605335');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (95, 'Bonnibelle', 'Moorrud', 'Žena', 'bmoorrud2m@etsy.com', '5928712371');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (96, 'Annaliese', 'Mouser', 'Muž', 'amouser2n@spiegel.de', '8713395072');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (97, 'Town', 'Arnaez', 'Muž', 'tarnaez2o@dion.ne.jp', '7171845121');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (98, 'Maryrose', 'Barmby', 'Žena', 'mbarmby2p@studiopress.com', '5203546382');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (99, 'Hercule', 'Burkill', 'Žena', 'hburkill2q@columbia.edu', '4434007683');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (100, 'Wynny', 'Tomsett', 'Muž', 'wtomsett2r@virginia.edu', '4133262679');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (101, 'Dur', 'Babonau', 'Žena', 'dbabonau2s@cloudflare.com', '9413478812');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (102, 'Deane', 'Binnion', 'Žena', 'dbinnion2t@macromedia.com', '2532661464');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (103, 'Thelma', 'Deinhard', 'Žena', 'tdeinhard2u@disqus.com', '5749702624');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (104, 'Boycie', 'Trewman', 'Žena', 'btrewman2v@multiply.com', null);
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (105, 'Gardner', 'Badam', 'Žena', 'gbadam2w@skyrock.com', '2083956218');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (106, 'Breena', 'Hartzenberg', 'Žena', 'bhartzenberg2x@goo.gl', '8498973438');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (107, 'Esmeralda', 'Jacks', 'Žena', 'ejacks2y@blogspot.com', '1548483894');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (108, 'Maxy', 'Chalfont', 'Muž', 'mchalfont2z@ted.com', '7268408316');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (109, 'Patricio', 'Edghinn', 'Muž', 'pedghinn30@spiegel.de', '4896207908');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (110, 'Hamil', 'Pllu', 'Muž', 'hpllu31@so-net.ne.jp', '2116052623');
insert into ZAKAZNIK (ID_ZAKAZNIK, JMENO, PRIJMENI, POHLAVI, EMAIL, TELEFON) values (111, 'Bride', 'Ould', 'Muž', null, null);


insert into TYP_SLUZBY (ID_TYP_SLUZBY, NAZEV) values (1, 'Masáž');
insert into TYP_SLUZBY (ID_TYP_SLUZBY, NAZEV) values (2, 'Výuka');
insert into TYP_SLUZBY (ID_TYP_SLUZBY, NAZEV) values (3, 'Skipark');
insert into TYP_SLUZBY (ID_TYP_SLUZBY, NAZEV) values (4, 'Heli-Skiing');
insert into TYP_SLUZBY (ID_TYP_SLUZBY, NAZEV) values (5, 'Procházka');

insert into SLUZBA (ID_SLUZBA, TYP_SLUZBY_ID_TYP_SLUZBY, POPIS) values (1, 1, 'Masáž světových kvalit');
insert into SLUZBA (ID_SLUZBA, TYP_SLUZBY_ID_TYP_SLUZBY, POPIS) values (2, 2, 'Naučíme na prkně i batole');
insert into SLUZBA (ID_SLUZBA, TYP_SLUZBY_ID_TYP_SLUZBY, POPIS) values (3, 3, 'Největší skipark v Alpách');
insert into SLUZBA (ID_SLUZBA, TYP_SLUZBY_ID_TYP_SLUZBY, POPIS) values (4, 4, 'Zážitek na celý život');
insert into SLUZBA (ID_SLUZBA, TYP_SLUZBY_ID_TYP_SLUZBY, POPIS) values (5, 5, 'Objevte krásu Alp');
insert into SLUZBA (ID_SLUZBA, TYP_SLUZBY_ID_TYP_SLUZBY, POPIS) values (6, 2, 'Hodinový kurz lyžování.'); --
insert into SLUZBA (ID_SLUZBA, TYP_SLUZBY_ID_TYP_SLUZBY, POPIS) values (7, 1, 'Maecenas tincidunt lacus at velit.');
insert into SLUZBA (ID_SLUZBA, TYP_SLUZBY_ID_TYP_SLUZBY, POPIS) values (8, 1, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla.');
insert into SLUZBA (ID_SLUZBA, TYP_SLUZBY_ID_TYP_SLUZBY, POPIS) values (9, 1, 'Praesent blandit lacinia erat.');
insert into SLUZBA (ID_SLUZBA, TYP_SLUZBY_ID_TYP_SLUZBY, POPIS) values (10, 2, 'Maecenas tincidunt lacus at velit.'); --
insert into SLUZBA (ID_SLUZBA, TYP_SLUZBY_ID_TYP_SLUZBY, POPIS) values (11, 5, 'Aenean sit amet justo. Morbi ut odio.');
insert into SLUZBA (ID_SLUZBA, TYP_SLUZBY_ID_TYP_SLUZBY, POPIS) values (12, 5, 'Nunc rhoncus dui vel sem. Sed sagittis.');
insert into SLUZBA (ID_SLUZBA, TYP_SLUZBY_ID_TYP_SLUZBY, POPIS) values (13, 1, 'Etiam pretium iaculis justo. In hac habitasse platea dictumst.');
insert into SLUZBA (ID_SLUZBA, TYP_SLUZBY_ID_TYP_SLUZBY, POPIS) values (14, 2, 'Nulla tempus.'); --
insert into SLUZBA (ID_SLUZBA, TYP_SLUZBY_ID_TYP_SLUZBY, POPIS) values (15, 2, 'Naučíme vás na běžkách do 30 minut!'); --

insert into MASAZ (MASER_ID_ZAMESTNANEC, SLUZBA_ID_SLUZBA, TYP) values (15, 1, 'Lávové k. 60');
insert into MASAZ (MASER_ID_ZAMESTNANEC, SLUZBA_ID_SLUZBA, TYP) values (16, 7, 'Lávové k. 30');
insert into MASAZ (MASER_ID_ZAMESTNANEC, SLUZBA_ID_SLUZBA, TYP) values (17, 8, 'Thajská 60');
insert into MASAZ (MASER_ID_ZAMESTNANEC, SLUZBA_ID_SLUZBA, TYP) values (18, 9, 'Klasická 30');
insert into MASAZ (MASER_ID_ZAMESTNANEC, SLUZBA_ID_SLUZBA, TYP) values (19, 13, 'Thajská 30');

--insert into VYUKA (INSTRUKTOR_ID_ZAMESTNANEC, SLUZBA_ID_SLUZBA, TYP_VYBAVENI, DETSKA_VYUKA) values (30, 6, 'Snowboard', 'Ne');
insert into VYUKA (INSTRUKTOR_ID_ZAMESTNANEC, SLUZBA_ID_SLUZBA, TYP_VYBAVENI, DETSKA_VYUKA) values (31, 2, 'Snowboard', 'Ano'); --
insert into VYUKA (INSTRUKTOR_ID_ZAMESTNANEC, SLUZBA_ID_SLUZBA, TYP_VYBAVENI, DETSKA_VYUKA) values (32, 10, 'Lyže', 'Ne');
insert into VYUKA (INSTRUKTOR_ID_ZAMESTNANEC, SLUZBA_ID_SLUZBA, TYP_VYBAVENI, DETSKA_VYUKA) values (33, 14, 'Lyže', 'Ano');
--insert into VYUKA (INSTRUKTOR_ID_ZAMESTNANEC, SLUZBA_ID_SLUZBA, TYP_VYBAVENI, DETSKA_VYUKA) values (34, 15, 'Běžky', 'Ne');

insert into VYUKA (INSTRUKTOR_ID_ZAMESTNANEC, SLUZBA_ID_SLUZBA, TYP_VYBAVENI, DETSKA_VYUKA) values (35, 6, 'Lyže', 'Ne');	-----------------------------------
insert into VYUKA (INSTRUKTOR_ID_ZAMESTNANEC, SLUZBA_ID_SLUZBA, TYP_VYBAVENI, DETSKA_VYUKA) values (42, 15, 'Běžky', 'Ne'); --
prompt #---------------------------#
prompt #-- OBJEDNAVKA go kaching --#
prompt #---------------------------#

insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (2, 76, 24, '18.02.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (1, 34, 18, '10.12.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (3, 4, 4, '06.02.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (4, 44, 41, '03.10.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (5, 70, 35, '20.04.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (6, 68, 12, '20.04.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (7, 88, 20, '20.04.2020'); --here
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (8, 32, 10, '20.04.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (9, 65, 20, '20.04.2020'); --here
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (10, 41, 2, '25.01.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (11, 4, 27, '04.09.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (12, 111, 44, '21.12.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (13, 2, 41, '08.12.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (14, 10, 32, '20.01.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (15, 75, 18, '29.04.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (16, 50, 33, '15.03.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (17, 57, 11, '25.10.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (18, 78, 35, '19.04.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (19, 8, 37, '27.05.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (20, 28, 43, '31.01.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (21, 74, 17, '21.05.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (22, 108, 6, '10.02.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (23, 111, 8, '23.03.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (24, 37, 35, '03.01.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (25, 78, 13, '03.09.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (26, 64, 39, '12.10.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (27, 2, 33, '17.01.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (28, 25, 26, '10.11.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (29, 33, 25, '16.08.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (30, 78, 35, '30.05.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (31, 106, 18, '05.12.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (32, 82, 8, '15.02.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (33, 15, 14, '11.11.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (34, 14, 12, '12.11.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (35, 1, 35, '29.05.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (36, 27, 35, '30.08.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (37, 3, 28, '22.04.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (38, 51, 27, '07.07.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (39, 39, 42, '10.01.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (40, 25, 11, '04.06.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (41, 18, 2, '03.09.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (42, 25, 32, '06.04.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (43, 32, 31, '30.04.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (44, 89, 41, '09.06.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (45, 61, 19, '08.04.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (46, 9, 17, '02.11.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (47, 58, 38, '27.02.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (48, 83, 5, '20.10.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (49, 62, 26, '28.06.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (50, 88, 7, '22.07.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (51, 93, 15, '14.08.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (52, 104, 44, '03.01.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (53, 69, 34, '19.11.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (54, 86, 13, '17.07.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (55, 85, 20, '20.04.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (56, 74, 38, '01.09.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (57, 31, 17, '06.07.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (58, 96, 27, '26.03.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (59, 2, 38, '23.02.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (60, 83, 19, '05.11.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (61, 42, 44, '25.02.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (62, 53, 30, '28.11.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (63, 61, 10, '10.08.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (64, 109, 12, '21.09.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (65, 82, 18, '04.06.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (66, 38, 28, '17.02.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (67, 34, 26, '04.06.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (68, 33, 39, '10.11.2018');

insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (69, 69, 12, '06.09.2018');

insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (70, 104, 21, '17.12.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (71, 42, 33, '25.09.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (72, 33, 16, '21.03.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (73, 1, 24, '14.01.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (74, 111, 30, '15.01.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (75, 57, 29, '07.12.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (76, 48, 27, '19.11.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (77, 111, 43, '04.04.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (78, 59, 16, '11.01.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (79, 27, 31, '12.08.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (80, 68, 37, '30.09.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (81, 36, 34, '17.01.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (82, 69, 42, '26.11.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (83, 73, 41, '03.12.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (84, 52, 8, '26.05.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (85, 23, 22, '03.09.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (86, 99, 30, '10.12.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (87, 108, 16, '01.05.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (88, 50, 41, '10.12.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (89, 49, 25, '09.10.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (90, 4, 37, '03.12.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (91, 79, 37, '16.01.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (92, 19, 33, '16.02.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (93, 58, 1, '06.01.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (94, 7, 13, '21.07.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (95, 43, 16, '15.03.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (96, 76, 1, '22.04.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (97, 10, 9, '29.12.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (98, 33, 14, '18.03.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (99, 61, 44, '28.01.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (100, 30, 8, '24.12.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (101, 39, 43, '24.11.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (102, 67, 8, '18.07.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (103, 44, 45, '29.09.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (104, 63, 26, '14.03.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (105, 41, 38, '25.04.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (106, 84, 12, '02.01.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (107, 41, 5, '08.02.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (108, 44, 34, '22.07.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (109, 3, 27, '05.03.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (110, 24, 13, '19.03.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (111, 97, 38, '25.03.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (112, 35, 34, '20.03.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (113, 111, 6, '14.05.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (114, 98, 45, '29.01.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (115, 57, 43, '14.09.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (116, 68, 34, '03.02.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (117, 77, 19, '17.05.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (118, 62, 5, '06.01.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (119, 34, 9, '01.09.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (120, 40, 26, '18.06.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (121, 86, 1, '27.12.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (122, 31, 4, '16.04.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (123, 55, 30, '26.02.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (124, 30, 19, '18.05.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (125, 72, 31, '20.06.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (126, 106, 40, '25.02.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (127, 66, 22, '22.04.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (128, 14, 8, '06.03.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (129, 77, 25, '02.10.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (130, 102, 5, '05.01.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (131, 73, 45, '03.04.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (132, 7, 5, '14.01.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (133, 75, 30, '26.11.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (134, 76, 8, '22.02.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (135, 2, 23, '12.10.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (136, 30, 4, '14.01.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (137, 55, 23, '21.12.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (138, 70, 18, '06.11.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (139, 1, 1, '04.01.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (140, 22, 11, '18.01.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (141, 99, 25, '13.11.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (142, 34, 45, '20.10.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (143, 98, 28, '19.11.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (144, 5, 30, '20.10.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (145, 45, 38, '18.05.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (146, 49, 8, '28.04.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (147, 102, 5, '24.02.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (148, 3, 42, '16.11.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (149, 23, 22, '12.04.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (150, 43, 5, '13.11.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (151, 95, 1, '16.08.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (152, 34, 31, '29.03.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (153, 58, 33, '04.03.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (154, 87, 1, '12.02.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (155, 27, 14, '05.05.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (156, 48, 23, '11.10.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (157, 94, 26, '06.12.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (158, 47, 11, '03.02.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (159, 34, 44, '10.07.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (160, 74, 17, '01.02.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (161, 67, 2, '16.07.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (162, 82, 10, '30.01.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (163, 71, 22, '09.01.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (164, 87, 12, '12.01.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (165, 90, 23, '02.02.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (166, 41, 24, '24.06.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (167, 83, 14, '30.09.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (168, 87, 26, '05.11.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (169, 69, 43, '24.02.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (170, 5, 7, '01.07.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (171, 52, 29, '15.04.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (172, 46, 39, '11.02.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (173, 94, 45, '22.05.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (174, 57, 32, '23.08.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (175, 23, 13, '13.08.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (176, 74, 8, '20.10.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (177, 58, 24, '05.03.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (178, 72, 23, '10.08.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (179, 79, 13, '22.01.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (180, 12, 32, '29.06.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (181, 39, 26, '06.10.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (182, 67, 13, '18.01.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (183, 21, 31, '19.02.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (184, 70, 31, '30.04.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (185, 60, 1, '28.01.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (186, 81, 45, '05.02.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (187, 34, 25, '25.05.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (188, 60, 10, '16.02.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (189, 59, 41, '02.06.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (190, 84, 1, '09.09.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (191, 31, 4, '15.08.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (192, 36, 25, '18.04.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (193, 79, 14, '17.03.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (194, 49, 28, '30.03.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (195, 35, 22, '30.11.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (196, 32, 14, '01.12.2018');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (197, 43, 26, '12.07.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (198, 15, 22, '05.03.2020');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (199, 105, 39, '02.07.2019');
insert into OBJEDNAVKA (ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (200, 21, 16, '13.05.2019');

insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	201, 69, 1, '15.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	202, 69, 2, '16.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	203, 69, 3, '17.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	204, 69, 4, '15.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	205, 69, 5, '16.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	206, 69, 6, '17.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	207, 69, 7, '15.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	208, 69, 8, '16.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	209, 69, 9, '17.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	210, 69, 10, '15.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	211, 69, 11, '16.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	212, 69, 12, '17.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	213, 69, 13, '15.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	214, 69, 14, '16.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	215, 69, 15, '17.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	216, 69, 16, '15.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	217, 69, 17, '16.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	218, 69, 18, '17.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	219, 69, 19, '15.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	220, 69, 30, '16.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	221, 69, 21, '17.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	222, 69, 22, '15.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	223, 69, 23, '16.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	224, 69, 24, '17.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	225, 69, 25, '15.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	226, 69, 26, '16.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	227, 69, 27, '17.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	228, 69, 28, '15.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	229, 69, 29, '16.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	230, 69, 30, '17.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	231, 69, 31, '15.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	232, 69, 32, '16.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	233, 69, 33, '17.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	234, 69, 34, '15.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	235, 69, 35, '16.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	236, 69, 36, '17.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	237, 69, 37, '15.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	238, 69, 38, '16.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	239, 69, 39, '17.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	240, 69, 40, '15.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	241, 69, 41, '16.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	242, 69, 42, '17.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	243, 69, 43, '15.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	244, 69, 44, '16.04.2018');
insert into OBJEDNAVKA(ID_OBJEDNAVKA, ZAKAZNIK_ID_ZAKAZNIK, ZAMESTNANEC_ID_ZAMESTNANEC, DATUM) values (	245, 69, 45, '17.04.2018');

prompt #---------------------------#
prompt #-- POLOZKAS go countiing --#
prompt #---------------------------#

insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (1, 4, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (2, 4, 10);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (1, 2, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (3, 5, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (4, 1, 10);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (5, 11, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (6, 15, 6);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (7, 15, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (8, 7, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (9, 7, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (10, 12, 6);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (11, 15, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (12, 2, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (13, 11, 9);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (14, 11, 3);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (15, 7, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (16, 4, 3);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (17, 5, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (18, 10, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (19, 14, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (20, 8, 10);


insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (21, 3, 4); -- here
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (21, 4, 3);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (21, 5, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (21, 6, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (21, 7, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (21, 8, 12);


insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (22, 14, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (23, 7, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (24, 11, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (25, 2, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (25, 14, 6); -- chybi 26!


insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (27, 13, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (28, 14, 3);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (29, 9, 3);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (30, 5, 6);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (31, 10, 10);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (32, 11, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (33, 14, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (34, 5, 3);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (35, 10, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (36, 4, 3);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (37, 3, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (38, 9, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (39, 2, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (40, 3, 6);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (41, 7, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (42, 2, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (43, 10, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (44, 13, 9);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (45, 3, 6);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (46, 1, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (47, 4, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (48, 8, 9);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (49, 10, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (50, 9, 3);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (51, 15, 9);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (52, 11, 3);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (53, 5, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (54, 3, 10);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (55, 14, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (56, 13, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (57, 13, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (58, 13, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (59, 9, 10);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (60, 5, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (61, 11, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (62, 4, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (63, 5, 9);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (64, 2, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (65, 14, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (66, 7, 10);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (67, 2, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (68, 4, 6);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (68, 2, 2);

insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (69, 1, 12); -- here
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (69, 2, 32);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (69, 3, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (69, 4, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (69, 5, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (69, 6, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (69, 7, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (69, 8, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (69, 9, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (69, 10, 3);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (69, 11, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (69, 12, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (69, 13, 3);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (69, 14, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (69, 15, 9);

insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (70, 14, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (71, 9, 6);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (72, 14, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (73, 1, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (74, 8, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (75, 13, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (76, 13, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (77, 1, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (78, 8, 9);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (79, 2, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (80, 3, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (81, 7, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (82, 4, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (83, 9, 9);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (84, 7, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (85, 13, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (86, 2, 10);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (87, 15, 6);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (88, 11, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (89, 12, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (90, 13, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (91, 3, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (92, 14, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (93, 7, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (94, 15, 9);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (95, 6, 3);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (96, 10, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (97, 8, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (98, 13, 10);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (99, 14, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (100, 11, 10);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (101, 5, 6);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (102, 10, 10);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (103, 5, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (104, 6, 3);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (105, 8, 10);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (106, 13, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (107, 9, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (108, 13, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (109, 14, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (110, 7, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (111, 3, 3);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (112, 3, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (113, 2, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (114, 2, 10);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (115, 11, 3);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (116, 14, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (117, 6, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (118, 14, 3);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (119, 7, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (120, 9, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (121, 5, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (122, 3, 10);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (123, 11, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (124, 12, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (125, 2, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (126, 8, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (127, 13, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (128, 10, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (129, 7, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (130, 15, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (131, 2, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (132, 6, 3);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (133, 15, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (134, 8, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (135, 9, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (136, 9, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (137, 1, 6);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (138, 15, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (139, 12, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (140, 3, 6);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (141, 3, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (142, 1, 6);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (143, 1, 9);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (144, 2, 9);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (145, 10, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (146, 7, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (147, 4, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (148, 3, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (149, 11, 9);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (150, 7, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (151, 10, 6);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (152, 11, 6);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (153, 11, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (154, 10, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (155, 14, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (156, 13, 9);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (157, 14, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (158, 4, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (159, 7, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (160, 1, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (161, 1, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (162, 4, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (163, 5, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (164, 14, 6);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (165, 12, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (166, 14, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (167, 5, 3);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (168, 3, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (169, 14, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (170, 8, 9);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (171, 2, 10);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (172, 7, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (173, 13, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (174, 3, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (175, 13, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (176, 7, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (177, 8, 8);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (178, 1, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (179, 4, 10);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (180, 5, 10);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (181, 11, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (182, 11, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (183, 9, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (184, 15, 1);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (185, 2, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (186, 3, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (187, 5, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (188, 13, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (189, 10, 4);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (190, 11, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (191, 2, 5);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (192, 9, 7);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (193, 9, 6);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (194, 4, 2);
insert into POLOZKA (OBJEDNAVKA_ID_OBJEDNAVKA, SLUZBA_ID_SLUZBA, POCET_KS) values (195, 9, 8);


prompt #-------------------------#
prompt #-- We did it boys PogU --#
prompt #-------------------------#

commit;