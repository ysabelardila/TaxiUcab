
/*IMPORTANTE!! RECORDAR CAMBIAR EL DIRECTORIO*/
/*CREATE OR REPLACE DIRECTORY DIR_VINOS as 'C:\Users\ycha1\Desktop\TaxiUcab\Imagenes';*/
/
/*grant read,write on directory DIR_VINOS to admin;*/



CREATE OR REPLACE TYPE VALORACION AS OBJECT(
    nombreelemento varchar2(20),
    valor number,
    observacion varchar2(200)
);
/
CREATE OR REPLACE TYPE VALORACION_NT AS TABLE OF VALORACION;
/
CREATE OR REPLACE TYPE COSTO AS OBJECT(
    cantidademuestras number(2),
    valor number(4),
    pais varchar2(30)
);
/
CREATE OR REPLACE TYPE COSTO_NT AS TABLE OF COSTO;
/
CREATE OR REPLACE TYPE TIPO_VALOR AS OBJECT(
    ano date,
    valor number
);
/
CREATE OR REPLACE TYPE TIPO_VALOR_NT AS TABLE OF TIPO_VALOR;
/
CREATE OR REPLACE TYPE EXPORTACION AS OBJECT(
    valor TIPO_VALOR,
    pais varchar2(30)
);
/
CREATE OR REPLACE TYPE EXPORTACION_NT AS TABLE OF EXPORTACION;
/
CREATE OR REPLACE TYPE PREMIO AS OBJECT(
    nombre varchar2(50),
    descripcion varchar2(200),
    tipo varchar2(11),
    premiomonetario number,
    posicion number(1)
);
/
CREATE OR REPLACE TYPE PREMIO_NT AS TABLE OF PREMIO;
/
CREATE OR REPLACE TYPE ESCALAEVALUACION AS OBJECT(
    elemento varchar2(20),
    rangoi number,
    rangof number,
    clasificacion varchar2(2)
);
/
CREATE OR REPLACE TYPE ESCALAEVALUACION_NT AS TABLE OF ESCALAEVALUACION;
/
CREATE OR REPLACE TYPE TELEFONO AS OBJECT(
    codigoarea varchar2(3),
    numero varchar2(15)
);
/
CREATE OR REPLACE TYPE TELEFONO_VA AS VARRAY(5) OF TELEFONO;
/
CREATE OR REPLACE TYPE PERSONAL_CONTACTO AS OBJECT(
    nombre varchar2(30),
    apellido varchar2(30),
    cargo varchar2(100),
    email varchar2(70)
);
/
CREATE OR REPLACE TYPE PERSONAL_CONTACTO_VA AS VARRAY(5) OF PERSONAL_CONTACTO;

/
CREATE OR REPLACE TYPE LUGAR AS OBJECT(
    pais varchar2(30),
    ciudad varchar2(30)
);
/
CREATE OR REPLACE TYPE HECHO AS OBJECT(
    ano date,
    hechohistorico varchar2(500)
);
/
CREATE OR REPLACE TYPE HECHO_NT AS TABLE OF HECHO;
/
CREATE OR REPLACE TYPE CALIFICACION AS OBJECT(
    nombrecritica varchar2(50),
    valor TIPO_VALOR
);
/
CREATE OR REPLACE TYPE CALIFICACION_NT AS TABLE OF CALIFICACION;
/
CREATE OR REPLACE TYPE UNIDADMONETARIA AS OBJECT(
    nombre varchar2(20),
    simbolo varchar2(3)
);
/
CREATE OR REPLACE TYPE DATOS_C AS OBJECT(
    telefonos TELEFONO_VA,
    paginaweb varchar2(100),
    direccion varchar2(200),
    email varchar2(70),
    contactos PERSONAL_CONTACTO_VA);
/
CREATE TABLE BODEGA(
    id_bodega number not null,
    nombre varchar2(50) not null,
    fechafundacion date not null,
    mision varchar2(1500) not null,
    datosbodega DATOS_C not null,
    logo BFILE not null,
    produccionanual TIPO_VALOR_NT,
    exportacionanual EXPORTACION_NT,
    descripcionvinos varchar2(1000) not null,
    historia HECHO_NT,
    id_pais number not null,
    id_bodega_dueno number,
    id_pais_dueno number,
    CONSTRAINT BODEGA_PK PRIMARY KEY (id_bodega,id_pais))
    NESTED TABLE historia STORE AS HISTB_NT,
    NESTED TABLE produccionanual STORE AS PRODANUALB_NT,
    NESTED TABLE exportacionanual STORE AS EXPORTANUALB_NT;
/
CREATE TABLE BOD_MARCA(
    id_marca number not null,
    id_bodega number not null,
    id_pais number not null,
    CONSTRAINT BOD_MARCA_PK PRIMARY KEY (id_marca,id_bodega,id_pais)
);
/
CREATE TABLE CALENDARIO_EDICION(
    id_calendarioe number not null,
    fechai date not null,
    fechaf date not null,
    fechaliminsc date not null,
    fechalimenvio date,
    emailenvioinsc varchar2(70),
    direnviomuestras DATOS_C,
    costos COSTO_NT,
    unidadmonetaria varchar2(10) not null,
    id_concurso number not null,
    CONSTRAINT CALENDARIO_EDICION_PK PRIMARY KEY (id_calendarioe,id_concurso))
    NESTED TABLE costos STORE AS COS_NT;
/
CREATE OR REPLACE TYPE PUBLICACION_VA AS VARRAY(10) OF varchar2(500);
/
CREATE TABLE CATADOREXPERTO(
    id_cexperto number primary key,
    nombre varchar2(30) not null,
    apellido varchar2(30) not null,
    fechanac date not null,
    genero varchar2(15) not null,
    lugarnac LUGAR not null,
    descripcion varchar2(200) not null,
    curriculum HECHO_NT,
    publicaciones PUBLICACION_VA not null,
    id_pais number,
    CHECK (genero in('Masculino','Femenino','Otro')))
    NESTED TABLE curriculum STORE AS CURRI_NT;
/
CREATE TABLE CATADORPRINCIPIANTE(
    id_cprincipiante number primary key,
    nombre varchar2(30) not null,
    apellido varchar2(30) not null,
    fechanac date not null,
    genero varchar2(15) not null,
    lugarnac LUGAR not null,
    descripcion varchar2(200) not null,
    CHECK (genero in('Masculino','Femenino','Otro')));
/
CREATE OR REPLACE TYPE VOL_VA AS VARRAY(10) OF NUMBER;
/
CREATE TABLE CLASIFICACION_VINO(
    id_cvino number primary key,
    nombre varchar2(20) not null,
    nivel varchar2(1) not null,
    vol VOL_VA,
    id_nivel number,
    check (nivel in('1','2','3'))
);
/
CREATE TABLE CONCURSO(
    id_concurso number primary key,
    nombre varchar2(50) not null,
    tipocata varchar2(15) not null,
    tipo varchar2(10) not null,
    tipoubicacion varchar2(20) not null,
    premios PREMIO_NT,
    escalas ESCALAEVALUACION_NT,
    check (tipocata in('Comparativa','A ciegas','Vertical','Varietal')),
    check (tipo in('Vino','Cata')),
    check (tipoubicacion in('Nacional','Internacional')))
    NESTED TABLE premios STORE AS PRE_NT,
    NESTED TABLE escalas STORE AS ESCALA_NT;
/
CREATE TABLE CONC_ORGAN(
    id_concurso number not null,
    id_organizacion number not null,
    CONSTRAINT CONC_ORGAN_PK PRIMARY KEY (id_concurso,id_organizacion)
);
/
CREATE TABLE COSECHA(
    id_cosecha number not null,
    calificacion varchar2(5) not null,
    ano date not null,
    id_bodega number not null,
    id_pais number not null,
    id_uvavariedad number not null,
    CHECK (calificacion in('E','MB','B','R','D')),
    CONSTRAINT COSECHA_PK PRIMARY KEY (id_cosecha,id_bodega,id_pais)
);
/
CREATE TABLE DENOM_ORIGEN(
    id_denom_origen number not null,
    nombre varchar2(50) not null,
    descripcion varchar2(200) not null,
    id_uvavariedad number not null,
    id_region number not null,
    id_pais number not null,
    CONSTRAINT DENOM_ORIGEN_PK PRIMARY KEY (id_denom_origen,id_uvavariedad,id_region,id_pais)
);
/
CREATE TABLE DO_BODEGA(
    id_bodega number not null,
    id_pais number not null,
    id_uvavariedad number not null,
    id_denom_origen number not null,
    id_region number not null,
    CONSTRAINT DO_BODEGA_PK PRIMARY KEY (id_bodega,id_pais,id_uvavariedad,id_denom_origen,id_region)
);
/
CREATE TABLE HIST_PRECIO(
    ano date not null,
    precio number not null,
    id_presentacion number not null,
    id_marca number not null,
    CONSTRAINT HIST_PRECIO_PK PRIMARY KEY (ano,id_presentacion,id_marca)
);
/
CREATE TABLE JUEZ(
    id_cexperto number not null,
    id_calendarioe number not null,
    id_concurso number not null,
    CONSTRAINT JUEZ_PK PRIMARY KEY (id_cexperto,id_calendarioe,id_concurso)
);
/
CREATE OR REPLACE TYPE MARIDAJE_VA AS VARRAY(10) OF VARCHAR2(30);
/
CREATE TABLE MARCA(
    id_marca number primary key,
    nombre varchar2(50) not null,
    calificaciones CALIFICACION_NT,
    foto BFILE,
    graduacion number not null,
    elaboracion varchar2(1000) not null,
    maridaje MARIDAJE_VA not null,
    temperaturaconsumo number not null,
    ventanaconsumo number not null,
    acidez number not null,
    ph number not null,
    madera varchar2(5) not null,
    catadescripcion varchar2(1000) not null,
    tiempomaduracionmeses number not null,
    tipotapon varchar2(15) not null,
    produccionanual TIPO_VALOR_NT,
    exportacionanual EXPORTACION_NT,
    id_cvino number not null,
    CHECK (tipotapon in('Corcho','Aluminio','Pl�stico')),
    CHECK (madera in('Si','No'))) 
    NESTED TABLE produccionanual STORE AS PRODANUALM_NT,
    NESTED TABLE exportacionanual STORE AS EXPORTANUALM_NT,
    NESTED TABLE calificaciones STORE AS CALIFICM_NT;
/
CREATE TABLE MUESTRA_BODEGA(
    id_muestrab number not null,
    anada number not null,
    premio number,
    id_marca number not null,
    id_participante number not null,
    CONSTRAINT MUESTRA_BODEGA_PK PRIMARY KEY (id_muestrab,id_participante)
);
/
CREATE TABLE MUESTRA_CATADORES(
    anada number not null,
    sumatoria number not null,
    id_marca number not null,
    CONSTRAINT MUESTRA_CATADORES_PK PRIMARY KEY (anada,id_marca)
);
/
CREATE TABLE ORGANIZACION(
    id_organizacion number primary key,
    nombre varchar2(50) not null,
    descripcion varchar2(500) not null
);
/
CREATE TABLE PAIS(
    id_pais number primary key,
    nombre varchar2(30) not null,
    continente varchar2(15) not null,
    superficievinedo TIPO_VALOR_NT,
    mapa BFILE not null,
    descripcion varchar2(2000) not null,
    unidadmonetaria UNIDADMONETARIA not null,
    produccionanual TIPO_VALOR_NT,
    exportacionanual EXPORTACION_NT,
    CHECK (continente in('Am�rica','Asia','�frica','Europa','Ocean�a'))) 
    NESTED TABLE superficievinedo STORE AS SUPERF_NT,
    NESTED TABLE produccionanual STORE AS PRODANUALP_NT,
    NESTED TABLE exportacionanual STORE AS EXPORTANUALP_NT;
/
CREATE TABLE PARTICIPANTE(
    id_participante number primary key,
    fechainsc date not null,
    premiocatador varchar2(50),
    id_calendarioe number not null,
    id_concurso number not null,
    id_cprincipiante number,
    id_bodega number,
    id_pais number
);
/
CREATE TABLE PRESENTACION(
    id_presentacion number not null,
    tipo varchar2(10) not null,
    unidadescaja varchar2(3),
    id_marca number not null,
    check (tipo in('Botella','Caja')),
    CONSTRAINT PRESENTACION_PK PRIMARY KEY (id_presentacion,id_marca)
);
/
CREATE TABLE REGION_PRODUCTORA(
    id_region number not null,
    nombre varchar2(30) not null,
    clima varchar2(20) not null,
    id_pais number not null,
    CONSTRAINT REGION_PRODUCTORA_PK PRIMARY KEY (id_region,id_pais)
);
/
CREATE TABLE REGULA(
    id_pais number not null,
    id_organizacion number not null,
    CONSTRAINT REGULA_PK PRIMARY KEY (id_pais,id_organizacion)
);
/
CREATE OR REPLACE TYPE NOMBRE_VA AS VARRAY(10) OF VARCHAR2(30);
/
CREATE TABLE UVAVARIEDAD(
    id_uvavariedad number primary key,
    nombres NOMBRE_VA not null,
    clasificacion varchar2(10) not null,
    CHECK (clasificacion in('Tintas','Blancas'))
    );
/
CREATE TABLE VALORACIONBODEGA(
    id_valoracionb number primary key,
    fechacata date not null,
    valoraciones VALORACION_NT,
    puntuaciontotal number not null,
    id_muestrab number not null,
    id_participante number not null,
    id_cexperto number not null,
    id_calendarioe number not null,
    id_concurso number not null)
    NESTED TABLE valoraciones STORE AS VALORA_NT;
/
CREATE TABLE VALORACIONPARTICIPANTE(
    id_valoracionp number primary key,
    fechacata date not null,
    valoraciones VALORACION_NT,
    puntuaciontotal number not null,
    id_participante number not null,
    anada number not null,
    id_marca number not null)
    NESTED TABLE valoraciones STORE AS VALOR_PAR_NT;
/
CREATE SEQUENCE bodega_sqnc START WITH 1;
/
CREATE OR REPLACE TRIGGER bodega_secuencia 
BEFORE INSERT ON bodega 
FOR EACH ROW
BEGIN
  SELECT bodega_sqnc.NEXTVAL
  INTO   :new.id_bodega
  FROM   dual;
END;
/
CREATE SEQUENCE calendarioe_sqnc START WITH 1;
/
CREATE OR REPLACE TRIGGER calendarioe_secuencia 
BEFORE INSERT ON calendario_edicion 
FOR EACH ROW
BEGIN
  SELECT calendarioe_sqnc.NEXTVAL
  INTO   :new.id_calendarioe
  FROM   dual;
END;
/
CREATE SEQUENCE cexperto_sqnc START WITH 1;
/
CREATE OR REPLACE TRIGGER cexperto_secuencia 
BEFORE INSERT ON catadorexperto 
FOR EACH ROW
BEGIN
  SELECT cexperto_sqnc.NEXTVAL
  INTO   :new.id_cexperto
  FROM   dual;
END;
/
CREATE SEQUENCE cprincipiante_sqnc START WITH 1;
/
CREATE OR REPLACE TRIGGER cprincipiante_secuencia 
BEFORE INSERT ON catadorprincipiante 
FOR EACH ROW
BEGIN
  SELECT cprincipiante_sqnc.NEXTVAL
  INTO   :new.id_cprincipiante
  FROM   dual;
END;
/
CREATE SEQUENCE cvino_sqnc START WITH 1;
/
CREATE OR REPLACE TRIGGER cvino_secuencia 
BEFORE INSERT ON clasificacion_vino 
FOR EACH ROW
BEGIN
  SELECT cvino_sqnc.NEXTVAL
  INTO   :new.id_cvino
  FROM   dual;
END;
/
CREATE SEQUENCE concurso_sqnc START WITH 1;
/
CREATE OR REPLACE TRIGGER concurso_secuencia 
BEFORE INSERT ON concurso 
FOR EACH ROW
BEGIN
  SELECT concurso_sqnc.NEXTVAL
  INTO   :new.id_concurso
  FROM   dual;
END;
/
CREATE SEQUENCE cosecha_sqnc START WITH 1;
/
CREATE OR REPLACE TRIGGER cosecha_secuencia 
BEFORE INSERT ON cosecha 
FOR EACH ROW
BEGIN
  SELECT cosecha_sqnc.NEXTVAL
  INTO   :new.id_cosecha
  FROM   dual;
END;
/
CREATE SEQUENCE denom_origen_sqnc START WITH 1;
/
CREATE OR REPLACE TRIGGER denom_origen_secuencia 
BEFORE INSERT ON denom_origen
FOR EACH ROW
BEGIN
  SELECT denom_origen_sqnc.NEXTVAL
  INTO   :new.id_denom_origen
  FROM   dual;
END;
/
CREATE SEQUENCE marca_sqnc START WITH 1;
/
CREATE OR REPLACE TRIGGER marca_secuencia 
BEFORE INSERT ON marca
FOR EACH ROW
BEGIN
  SELECT marca_sqnc.NEXTVAL
  INTO   :new.id_marca
  FROM   dual;
END;
/
CREATE SEQUENCE muestrab_sqnc START WITH 1;
/
CREATE OR REPLACE TRIGGER muestrab_secuencia 
BEFORE INSERT ON muestra_bodega
FOR EACH ROW
BEGIN
  SELECT muestrab_sqnc.NEXTVAL
  INTO   :new.id_muestrab
  FROM   dual;
END;
/
CREATE SEQUENCE organizacion_sqnc START WITH 1;
/
CREATE OR REPLACE TRIGGER organizacion_secuencia 
BEFORE INSERT ON organizacion
FOR EACH ROW
BEGIN
  SELECT organizacion_sqnc.NEXTVAL
  INTO   :new.id_organizacion
  FROM   dual;
END;
/
CREATE SEQUENCE pais_sqnc START WITH 1;
/
CREATE OR REPLACE TRIGGER pais_secuencia 
BEFORE INSERT ON pais
FOR EACH ROW
BEGIN
  SELECT pais_sqnc.NEXTVAL
  INTO   :new.id_pais
  FROM   dual;
END;
/
CREATE SEQUENCE participante_sqnc START WITH 1;
/
CREATE OR REPLACE TRIGGER participante_secuencia 
BEFORE INSERT ON participante
FOR EACH ROW
BEGIN
  SELECT participante_sqnc.NEXTVAL
  INTO   :new.id_participante
  FROM   dual;
END;
/
CREATE SEQUENCE presentacion_sqnc START WITH 1;
/
CREATE OR REPLACE TRIGGER presentacion_secuencia 
BEFORE INSERT ON presentacion
FOR EACH ROW
BEGIN
  SELECT presentacion_sqnc.NEXTVAL
  INTO   :new.id_presentacion
  FROM   dual;
END;
/
CREATE SEQUENCE region_sqnc START WITH 1;
/
CREATE OR REPLACE TRIGGER region_secuencia 
BEFORE INSERT ON region_productora
FOR EACH ROW
BEGIN
  SELECT region_sqnc.NEXTVAL
  INTO   :new.id_region
  FROM   dual;
END;
/
CREATE SEQUENCE uvavariedad_sqnc START WITH 1;
/
CREATE OR REPLACE TRIGGER uvavariedad_secuencia 
BEFORE INSERT ON uvavariedad
FOR EACH ROW
BEGIN
  SELECT uvavariedad_sqnc.NEXTVAL
  INTO   :new.id_uvavariedad
  FROM   dual;
END;
/
CREATE SEQUENCE valoracionb_sqnc START WITH 1;
/
CREATE OR REPLACE TRIGGER valoracionb_secuencia 
BEFORE INSERT ON valoracionbodega
FOR EACH ROW
BEGIN
  SELECT valoracionb_sqnc.NEXTVAL
  INTO   :new.id_valoracionb
  FROM   dual;
END;
/
CREATE SEQUENCE valoracionp_sqnc START WITH 1;
/
CREATE OR REPLACE TRIGGER valoracionp_secuencia 
BEFORE INSERT ON valoracionparticipante
FOR EACH ROW
BEGIN
  SELECT valoracionp_sqnc.NEXTVAL
  INTO   :new.id_valoracionp
  FROM   dual;
END;
/
ALTER TABLE BODEGA ADD CONSTRAINT BODEGAPAIS_FK FOREIGN KEY (id_pais) REFERENCES PAIS(id_pais);
/
ALTER TABLE BODEGA ADD CONSTRAINT BODEGADUENO_FK1 FOREIGN KEY (id_bodega_dueno,id_pais_dueno) REFERENCES BODEGA(id_bodega,id_pais);
/
ALTER TABLE BOD_MARCA ADD CONSTRAINT BODMARCAMARCA_FK FOREIGN KEY (id_marca) REFERENCES MARCA(id_marca);
/
ALTER TABLE BOD_MARCA ADD CONSTRAINT BODMARCABODEGA_FK1 FOREIGN KEY (id_bodega,id_pais) REFERENCES BODEGA(id_bodega,id_pais);
/
ALTER TABLE CALENDARIO_EDICION ADD CONSTRAINT CALEDICCONCURSO_FK FOREIGN KEY (id_concurso) REFERENCES CONCURSO(id_concurso);
/
ALTER TABLE CATADOREXPERTO ADD CONSTRAINT CEXPERTO_FK FOREIGN KEY (id_pais) REFERENCES PAIS(id_pais);
/
ALTER TABLE CLASIFICACION_VINO ADD CONSTRAINT CVINONIVEL_FK FOREIGN KEY (id_nivel) REFERENCES CLASIFICACION_VINO(id_cvino);
/
ALTER TABLE CONC_ORGAN ADD CONSTRAINT CONCORGANORGAN_FK FOREIGN KEY (id_organizacion) REFERENCES ORGANIZACION(id_organizacion);
/
ALTER TABLE CONC_ORGAN ADD CONSTRAINT CONCORGANCONCURSO_FK FOREIGN KEY (id_concurso) REFERENCES CONCURSO(id_concurso);
/
ALTER TABLE COSECHA ADD CONSTRAINT COSECHABOD_FK1 FOREIGN KEY (id_bodega,id_pais) REFERENCES BODEGA(id_bodega,id_pais);
/
ALTER TABLE COSECHA ADD CONSTRAINT COSECHAUVAV_FK FOREIGN KEY (id_uvavariedad) REFERENCES UVAVARIEDAD(id_uvavariedad);
/
ALTER TABLE DENOM_ORIGEN ADD CONSTRAINT DENOMORIREG_FK1 FOREIGN KEY (id_region,id_pais) REFERENCES REGION_PRODUCTORA(id_region,id_pais);
/
ALTER TABLE DENOM_ORIGEN ADD CONSTRAINT DENOMORIUVA_FK FOREIGN KEY (id_uvavariedad) REFERENCES UVAVARIEDAD(id_uvavariedad);
/
ALTER TABLE DO_BODEGA ADD CONSTRAINT DOBODBOD_FK1 FOREIGN KEY (id_bodega,id_pais) REFERENCES BODEGA(id_bodega,id_pais);
/
ALTER TABLE DO_BODEGA ADD CONSTRAINT DOBODDENO_FK1 FOREIGN KEY (id_uvavariedad,id_denom_origen,id_region,id_pais) REFERENCES DENOM_ORIGEN(id_uvavariedad,id_denom_origen,id_region,id_pais);
/
ALTER TABLE HIST_PRECIO ADD CONSTRAINT HISTPREPRESEN_FRK1 FOREIGN KEY (id_presentacion,id_marca) REFERENCES PRESENTACION(id_presentacion,id_marca);
/
ALTER TABLE JUEZ ADD CONSTRAINT JUEZCEXPERT_FK FOREIGN KEY (id_cexperto) REFERENCES CATADOREXPERTO(id_cexperto);
/
ALTER TABLE JUEZ ADD CONSTRAINT JUEZCALENEDIC_FK1 FOREIGN KEY (id_calendarioe,id_concurso) REFERENCES CALENDARIO_EDICION(id_calendarioe,id_concurso);
/
ALTER TABLE MARCA ADD CONSTRAINT MARCACLASIFV_FK FOREIGN KEY (id_cvino) REFERENCES CLASIFICACION_VINO(id_cvino);
/
ALTER TABLE MUESTRA_BODEGA ADD CONSTRAINT MUEBODPART_FK FOREIGN KEY (id_participante) REFERENCES PARTICIPANTE(id_participante);
/
ALTER TABLE MUESTRA_BODEGA ADD CONSTRAINT MUEBODMARCA_FK FOREIGN KEY (id_marca) REFERENCES MARCA(id_marca);
/
ALTER TABLE MUESTRA_CATADORES ADD CONSTRAINT MUECATMARCA_FK FOREIGN KEY (id_marca) REFERENCES MARCA(id_marca);
/
ALTER TABLE PARTICIPANTE ADD CONSTRAINT PARTCALENDE_FK1 FOREIGN KEY (id_calendarioe,id_concurso) REFERENCES CALENDARIO_EDICION(id_calendarioe,id_concurso);
/
ALTER TABLE PARTICIPANTE ADD CONSTRAINT PARTCPRINC_FK FOREIGN KEY (id_cprincipiante) REFERENCES CATADORPRINCIPIANTE(id_cprincipiante);
/
ALTER TABLE PARTICIPANTE ADD CONSTRAINT PARTBODEG_FK2 FOREIGN KEY (id_bodega,id_pais) REFERENCES BODEGA(id_bodega,id_pais);
/
ALTER TABLE PRESENTACION ADD CONSTRAINT PRESENMARCA_FK FOREIGN KEY (id_marca) REFERENCES MARCA(id_marca);
/
ALTER TABLE REGION_PRODUCTORA ADD CONSTRAINT REGPRODPAIS_FK FOREIGN KEY (id_pais) REFERENCES PAIS(id_pais);
/
ALTER TABLE REGULA ADD CONSTRAINT REGULAPAIS_FK FOREIGN KEY (id_pais) REFERENCES PAIS(id_pais);
/
ALTER TABLE REGULA ADD CONSTRAINT REGULAORGANIZA_FK FOREIGN KEY (id_organizacion) REFERENCES ORGANIZACION(id_organizacion);
/
ALTER TABLE VALORACIONBODEGA ADD CONSTRAINT VALORBODMUESTRA_FK1 FOREIGN KEY (id_muestrab,id_participante) REFERENCES MUESTRA_BODEGA(id_muestrab,id_participante);
/
ALTER TABLE VALORACIONBODEGA ADD CONSTRAINT VALORBODJUEZ_FK2 FOREIGN KEY (id_cexperto,id_calendarioe,id_concurso) REFERENCES JUEZ(id_cexperto,id_calendarioe,id_concurso);
/
ALTER TABLE VALORACIONPARTICIPANTE ADD CONSTRAINT VALORPARTMUESTRA_FK1 FOREIGN KEY (anada,id_marca) REFERENCES MUESTRA_CATADORES(anada,id_marca);
/
ALTER TABLE VALORACIONPARTICIPANTE ADD CONSTRAINT VALORPARTPARTI_FK FOREIGN KEY (id_participante) REFERENCES PARTICIPANTE(id_participante);
/




