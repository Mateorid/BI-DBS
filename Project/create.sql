--purge = navzdy
--cascade  constraints = smaze tabulkuku i kdyz jsou na ni vazane nejake klice
--truncate table = maze data v tabulkach


-- Generated by Oracle SQL Developer Data Modeler 19.2.0.182.1216
--   at:        2020-04-07 15:18:17 CEST
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g


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

exec SMAZ_VSECHNY_TABULKY;

prompt #-------------------------#
prompt #- Vytvorit nove tabulky -#
prompt #-------------------------#


CREATE TABLE instruktor (
    zamestnanec_id_zamestnanec INTEGER NOT NULL
);

ALTER TABLE instruktor ADD CONSTRAINT instruktor_pk PRIMARY KEY ( zamestnanec_id_zamestnanec );

CREATE TABLE masaz (
    typ                    VARCHAR2(15 CHAR) NOT NULL,
    maser_id_zamestnanec   INTEGER NOT NULL,
    sluzba_id_sluzba       INTEGER NOT NULL
);

ALTER TABLE masaz ADD CONSTRAINT masaz_pk PRIMARY KEY ( sluzba_id_sluzba );

CREATE TABLE maser (
    zamestnanec_id_zamestnanec INTEGER NOT NULL
);

ALTER TABLE maser ADD CONSTRAINT maser_pk PRIMARY KEY ( zamestnanec_id_zamestnanec );

CREATE TABLE objednavka (
    id_objednavka                INTEGER NOT NULL,
    datum                        DATE NOT NULL,
    zakaznik_id_zakaznik         INTEGER NOT NULL,
    zamestnanec_id_zamestnanec   INTEGER NOT NULL
);

ALTER TABLE objednavka ADD CONSTRAINT objednavka_pk PRIMARY KEY ( id_objednavka );

CREATE TABLE polozka (
    pocet_ks                   INTEGER NOT NULL,
    objednavka_id_objednavka   INTEGER NOT NULL,
    sluzba_id_sluzba           INTEGER NOT NULL
);

ALTER TABLE polozka ADD CONSTRAINT polozka_pk PRIMARY KEY ( objednavka_id_objednavka,
                                                            sluzba_id_sluzba );

CREATE TABLE pujcovna (
    id_pujcovna                  INTEGER NOT NULL,
    pocet_lyze                   INTEGER NOT NULL,
    pocet_snowboard              INTEGER NOT NULL,
    pocet_bezky                  INTEGER NOT NULL,
    pocet_sanky                  INTEGER NOT NULL,
    zamestnanec_id_zamestnanec   INTEGER NOT NULL
);

ALTER TABLE pujcovna ADD CONSTRAINT pujcovna_pk PRIMARY KEY ( id_pujcovna );

CREATE TABLE sjezdovka (
    id_sjezdovka            INTEGER NOT NULL,
    misto                   VARCHAR2(20 CHAR) NOT NULL,
    narocnost               VARCHAR2(10 CHAR),
    typ_vleku               VARCHAR2(12 CHAR) NOT NULL,
    nocni_lyzovani          VARCHAR2(4) NOT NULL,
    stav                    VARCHAR2(12 CHAR) NOT NULL,
    vlekar_id_zamestnanec   INTEGER NOT NULL
);

ALTER TABLE sjezdovka ADD CONSTRAINT sjezdovka_pk PRIMARY KEY ( id_sjezdovka );

CREATE TABLE sluzba (
    id_sluzba                  INTEGER NOT NULL,
    typ_sluzby_id_typ_sluzby   INTEGER NOT NULL,
    popis                      VARCHAR2(100 CHAR)
);

ALTER TABLE sluzba ADD CONSTRAINT sluzba_pk PRIMARY KEY ( id_sluzba );

CREATE TABLE typ_sluzby (
    id_typ_sluzby   INTEGER NOT NULL,
    nazev           VARCHAR2(15 CHAR) NOT NULL
);

ALTER TABLE typ_sluzby ADD CONSTRAINT typ_sluzby_pk PRIMARY KEY ( id_typ_sluzby );

CREATE TABLE vlekar (
    zamestnanec_id_zamestnanec INTEGER NOT NULL
);

ALTER TABLE vlekar ADD CONSTRAINT vlekar_pk PRIMARY KEY ( zamestnanec_id_zamestnanec );

CREATE TABLE vyuka (
    typ_vybaveni                VARCHAR2(10 CHAR) NOT NULL,
    detska_vyuka                VARCHAR2(4 CHAR) NOT NULL,
    instruktor_id_zamestnanec   INTEGER NOT NULL,
    sluzba_id_sluzba            INTEGER NOT NULL
);

ALTER TABLE vyuka ADD CONSTRAINT vyuka_pk PRIMARY KEY ( sluzba_id_sluzba );

CREATE TABLE zakaznik (
    id_zakaznik   INTEGER NOT NULL,
    jmeno         VARCHAR2(20 CHAR) NOT NULL,
    prijmeni      VARCHAR2(20 CHAR) NOT NULL,
    pohlavi       VARCHAR2(6 CHAR) NOT NULL,
    email         VARCHAR2(45 CHAR),
    telefon       INTEGER
);

ALTER TABLE zakaznik ADD CONSTRAINT zakaznik_pk PRIMARY KEY ( id_zakaznik );

CREATE TABLE zamestnanec (
    id_zamestnanec   INTEGER NOT NULL,
    jmeno            VARCHAR2(20 CHAR) NOT NULL,
    prijmeni         VARCHAR2(20 CHAR) NOT NULL,
    pohlavi          VARCHAR2(6 CHAR) NOT NULL,
    vek              INTEGER NOT NULL
);

ALTER TABLE zamestnanec ADD CONSTRAINT zamestnanec_pk PRIMARY KEY ( id_zamestnanec );

ALTER TABLE instruktor
    ADD CONSTRAINT instruktor_zamestnanec_fk FOREIGN KEY ( zamestnanec_id_zamestnanec )
        REFERENCES zamestnanec ( id_zamestnanec );

ALTER TABLE masaz
    ADD CONSTRAINT masaz_maser_fk FOREIGN KEY ( maser_id_zamestnanec )
        REFERENCES maser ( zamestnanec_id_zamestnanec );

ALTER TABLE masaz
    ADD CONSTRAINT masaz_sluzba_fk FOREIGN KEY ( sluzba_id_sluzba )
        REFERENCES sluzba ( id_sluzba );

ALTER TABLE maser
    ADD CONSTRAINT maser_zamestnanec_fk FOREIGN KEY ( zamestnanec_id_zamestnanec )
        REFERENCES zamestnanec ( id_zamestnanec );

ALTER TABLE objednavka
    ADD CONSTRAINT objednavka_zakaznik_fk FOREIGN KEY ( zakaznik_id_zakaznik )
        REFERENCES zakaznik ( id_zakaznik );

ALTER TABLE objednavka
    ADD CONSTRAINT objednavka_zamestnanec_fk FOREIGN KEY ( zamestnanec_id_zamestnanec )
        REFERENCES zamestnanec ( id_zamestnanec );

ALTER TABLE polozka
    ADD CONSTRAINT polozka_objednavka_fk FOREIGN KEY ( objednavka_id_objednavka )
        REFERENCES objednavka ( id_objednavka );

ALTER TABLE polozka
    ADD CONSTRAINT polozka_sluzba_fk FOREIGN KEY ( sluzba_id_sluzba )
        REFERENCES sluzba ( id_sluzba );

ALTER TABLE pujcovna
    ADD CONSTRAINT pujcovna_zamestnanec_fk FOREIGN KEY ( zamestnanec_id_zamestnanec )
        REFERENCES zamestnanec ( id_zamestnanec );

ALTER TABLE sjezdovka
    ADD CONSTRAINT sjezdovka_vlekar_fk FOREIGN KEY ( vlekar_id_zamestnanec )
        REFERENCES vlekar ( zamestnanec_id_zamestnanec );

ALTER TABLE sluzba
    ADD CONSTRAINT sluzba_typ_sluzby_fk FOREIGN KEY ( typ_sluzby_id_typ_sluzby )
        REFERENCES typ_sluzby ( id_typ_sluzby );

ALTER TABLE vlekar
    ADD CONSTRAINT vlekar_zamestnanec_fk FOREIGN KEY ( zamestnanec_id_zamestnanec )
        REFERENCES zamestnanec ( id_zamestnanec );

ALTER TABLE vyuka
    ADD CONSTRAINT vyuka_instruktor_fk FOREIGN KEY ( instruktor_id_zamestnanec )
        REFERENCES instruktor ( zamestnanec_id_zamestnanec );

ALTER TABLE vyuka
    ADD CONSTRAINT vyuka_sluzba_fk FOREIGN KEY ( sluzba_id_sluzba )
        REFERENCES sluzba ( id_sluzba );

CREATE OR REPLACE TRIGGER arc_arc_1_masaz BEFORE
    INSERT OR UPDATE OF sluzba_id_sluzba ON masaz
    FOR EACH ROW
DECLARE
    d INTEGER;
BEGIN
    SELECT
        a.typ_sluzby_id_typ_sluzby
    INTO d
    FROM
        sluzba a
    WHERE
        a.id_sluzba = :new.sluzba_id_sluzba;

    IF ( d IS NULL OR d <> 1 ) THEN
        raise_application_error(-20223, 'FK Masaz_Sluzba_FK in Table Masaz violates Arc constraint on Table Sluzba - discriminator column Typ_sluzby_ID_typ_sluzby doesn''t have value 1'
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/

CREATE OR REPLACE TRIGGER arc_arc_1_vyuka BEFORE
    INSERT OR UPDATE OF sluzba_id_sluzba ON vyuka
    FOR EACH ROW
DECLARE
    d INTEGER;
BEGIN
    SELECT
        a.typ_sluzby_id_typ_sluzby
    INTO d
    FROM
        sluzba a
    WHERE
        a.id_sluzba = :new.sluzba_id_sluzba;

    IF ( d IS NULL OR d <> 2 ) THEN
        raise_application_error(-20223, 'FK Vyuka_Sluzba_FK in Table Vyuka violates Arc constraint on Table Sluzba - discriminator column Typ_sluzby_ID_typ_sluzby doesn''t have value 2'
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            13
-- CREATE INDEX                             0
-- ALTER TABLE                             27
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           2
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
