/
/*CREATE OR REPLACE DIRECTORY DIR_TAXI as 'D:\UNIDAD DATA\Luis DATA\Universidad - DD 30-11-17\9no Semestre\Bases II\Proyecto\BFILES';
/*/
/*grant read,write on directory DIR_TAXI to admin;*/
/
CREATE OR REPLACE TYPE TELEFONO AS OBJECT(
  codigo_pais varchar2(4),
  codigo_telefonia varchar2(4),
  numero_telefonico varchar2(15)
);
/
CREATE OR REPLACE TYPE DATOS AS OBJECT(
  cedula_identidad number,
  nombres varchar2(40),
  apellidos varchar2(40),
  fecha_nac date,
  telefono_c TELEFONO
);
/
CREATE OR REPLACE TYPE DIRECCION AS OBJECT(
  zona varchar2(30),
  calle varchar2(30),
  edificio_casa varchar2(30)
);
/
CREATE TABLE CLIENTE(
  id_cliente number primary key,
  datos_cliente DATOS
);
/
CREATE TABLE CONDUCTOR(
  id_conductor number primary key,
  datos_conductor DATOS,
  doc_cedula BFILE not null,
  usuario varchar2(20) not null,
  password varchar2(20) not null,
  email varchar2(50) not null,
  estatus varchar2(10) not null,
  foto BLOB not null,
  saldoactual number not null,
  id_par number not null,
  check (estatus in('activo','inactivo'))
);
/
CREATE TABLE FAVORITO(
  id_us number not null,
  id_cond number not null,
  CONSTRAINT FAVORITO_PK PRIMARY KEY (id_us,id_cond)
);
/
CREATE TABLE FOTO(
  id_foto number primary key,
  archivo BLOB not null,
  fecha date not null,
  id_vehi number not null
);
/
CREATE TABLE HIST_MONEDERO(
  id_hist_monedero number not null,
  cantidad number not null,
  fecha date not null,
  tipo_recarga_consumo varchar2(10) not null,
  tipo_recarga varchar2(15),
  referencia number,
  banco_origen varchar2(15),
  id_mon number not null,
  id_tdc number,
  id_mon_rec number,
  id_us_rec number,
  id_us number not null,
  check (tipo_recarga_consumo in('recarga','consumo')),
  check (tipo_recarga in('TDC','transferencia','monedero')),
  CONSTRAINT HIST_MONEDERO_PK PRIMARY KEY (id_hist_monedero,id_mon,id_us)
);
/
CREATE TABLE HIST_MONEDERO_COND(
  id_monedero_cond number not null,
  cantidad number not null,
  tipo varchar2(10) not null,
  fecha date not null,
  id_cond number not null,
  check (tipo in('recarga','consumo')),
  CONSTRAINT MONEDERO_COND_PK PRIMARY KEY (id_monedero_cond,id_cond)
);
/
CREATE TABLE HIST_PRECIO_KM(
  id_precio number primary key,
  cantidad number not null,
  fecha_inicio date not null,
  activo varchar2(5) not null,
  check (activo in('true','false'))
);
/
CREATE TABLE INSPECCION(
  id_inspeccion number not null,
  fecha_inspeccion date not null,
  aprobado varchar2(3),
  observaciones varchar2(200),
  id_cond number not null,
  id_vehi number not null,
  check (aprobado in('si','no')),
  CONSTRAINT INSPECCION_PK PRIMARY KEY (id_inspeccion,id_cond,id_vehi)
);
/
CREATE TABLE MONEDERO_VIRTUAL(
  id_forma_pago number not null,
  saldoactual number not null,
  id_us number not null,
  CONSTRAINT MONEDERO_VIRTUAL_PK PRIMARY KEY (id_forma_pago,id_us)
);
/
CREATE TABLE PAGO_SERVICIO(
  id_pago number not null,
  cantidad number not null,
  id_serv number not null,
  id_us number not null,
  id_cond number not null,
  id_tdc number,
  id_mon number,
  CONSTRAINT PAGO_SERV_PK PRIMARY KEY (id_pago,id_serv,id_us,id_cond)
);
/
CREATE TABLE PARROQUIA(
  id_parroquia number primary key,
  nombre varchar2(40) not null,
  estado varchar2(20) not null
);
/
CREATE TABLE RUTA(
  kilometros number not null,
  id_par_origen number not null,
  id_par_destino number not null,
  CONSTRAINT RUTA_PK PRIMARY KEY (id_par_origen,id_par_destino)
);
/
CREATE TABLE SERVICIO(
  id_servicio number not null,
  precio number not null,
  efectivo varchar2(2) not null,
  codigo_pago_cliente varchar2(7),
  codigo_pago_conductor varchar2(7),
  califica_cliente number,
  califica_conductor number,
  fecha_hora date not null,
  tipo varchar2(15) not null,
  estatus varchar2(15) not null,
  punto_referencia DIRECCION,
  fecha_programada date,
  id_hp_km number not null,
  id_rutao number not null,
  id_rutad number not null,
  id_us number not null,
  id_cond number not null,
  check (efectivo in('Si','No')),
  check (tipo in('programado','no programado')),
  check (estatus in('completado','no completado','cancelado')),
  CONSTRAINT SERVICIO_PK PRIMARY KEY (id_servicio,id_us,id_cond)
);
/
CREATE TABLE TARJETA_CREDITO(
  id_forma_pago number not null,
  tipo varchar2(10) not null,
  nombre varchar2(30) not null,
  fecha_venci date not null,
  num_seguridad varchar2(3) not null,
  num_tajeta varchar2(16) not null,
  id_us number not null,
  check (tipo in('mastercard','visa')),
  CONSTRAINT TDC_PK PRIMARY KEY (id_forma_pago,id_us)
);
/
CREATE TABLE USUARIO(
  id_usuario number primary key,
  usuario varchar2(20) not null,
  password varchar2(20) not null,
  tipo varchar2(10) not null,
  email varchar2(50) not null,
  foto BLOB not null,
  id_cli number not null,
  id_par number not null,
  check (tipo in('natural','ejecutivo'))
);
/
CREATE TABLE VEHICULO(
  id_vehiculo number primary key,
  placa varchar2(7) not null,
  marca varchar2(10) not null,
  color varchar2(15) not null,
  aire_acondicionado varchar2(5) not null,
  reproductor varchar2(5) not null,
  blindado varchar2(5) not null,
  ano number not null,
  doc_propiedad BFILE not null,
  carnet_circulacion BFILE not null,
  estatus varchar2(10) not null,
  check (aire_acondicionado in('true','false')),
  check (reproductor in('true','false')),
  check (blindado in('true','false')),
  check (estatus in('activo','inactivo'))
);
/
/
/
/
/
/
CREATE SEQUENCE CLIENTE_SQNC START WITH 1;
/
CREATE OR REPLACE TRIGGER CLIENTE_SECUENCIA
BEFORE INSERT ON CLIENTE
FOR EACH ROW
BEGIN
  SELECT CLIENTE_SQNC.NEXTVAL
  INTO   :new.id_cliente
  FROM   dual;
END;
/
CREATE SEQUENCE CONDUCTOR_SQNC START WITH 1;
/
CREATE OR REPLACE TRIGGER CONDUCTOR_SECUENCIA
BEFORE INSERT ON CONDUCTOR
FOR EACH ROW
BEGIN
  SELECT CONDUCTOR_SQNC.NEXTVAL
  INTO   :new.id_conductor
  FROM   dual;
END;
/
CREATE SEQUENCE FOTO_SQNC START WITH 1;
/
CREATE OR REPLACE TRIGGER FOTO_SECUENCIA
BEFORE INSERT ON FOTO
FOR EACH ROW
BEGIN
  SELECT FOTO_SQNC.NEXTVAL
  INTO   :new.id_foto
  FROM   dual;
END;
/
CREATE SEQUENCE HIST_MONEDERO_SQNC START WITH 1;
/
CREATE OR REPLACE TRIGGER HIST_MONEDERO_SECUENCIA
BEFORE INSERT ON HIST_MONEDERO
FOR EACH ROW
BEGIN
  SELECT HIST_MONEDERO_SQNC.NEXTVAL
  INTO   :new.id_hist_monedero
  FROM   dual;
END;
/
CREATE SEQUENCE HIST_PRECIO_SQNC START WITH 1;
/
CREATE OR REPLACE TRIGGER HIST_PRECIO_SECUENCIA
BEFORE INSERT ON HIST_PRECIO_KM
FOR EACH ROW
BEGIN
  SELECT HIST_PRECIO_SQNC.NEXTVAL
  INTO   :new.id_precio
  FROM   dual;
END;
/
CREATE SEQUENCE INSPECCION_SQNC START WITH 1;
/
CREATE OR REPLACE TRIGGER INSPECCION_SECUENCIA
BEFORE INSERT ON INSPECCION
FOR EACH ROW
BEGIN
  SELECT INSPECCION_SQNC.NEXTVAL
  INTO   :new.id_inspeccion
  FROM   dual;
END;
/
CREATE SEQUENCE MONEDERO_COND_SQNC START WITH 1;
/
CREATE OR REPLACE TRIGGER MONEDERO_COND_SECUENCIA
BEFORE INSERT ON HIST_MONEDERO_COND
FOR EACH ROW
BEGIN
  SELECT MONEDERO_COND_SQNC.NEXTVAL
  INTO   :new.id_monedero_cond
  FROM   dual;
END;
/
CREATE SEQUENCE MONEDERO_VIRTUAL_SQNC START WITH 1;
/
CREATE OR REPLACE TRIGGER MONEDERO_VIRTUAL_SECUENCIA
BEFORE INSERT ON MONEDERO_VIRTUAL
FOR EACH ROW
BEGIN
  SELECT MONEDERO_VIRTUAL_SQNC.NEXTVAL
  INTO   :new.id_forma_pago
  FROM   dual;
END;
/
CREATE SEQUENCE PAGO_SERVICIO_SQNC START WITH 1;
/
CREATE OR REPLACE TRIGGER PAGO_SERVICIO_SECUENCIA
BEFORE INSERT ON PAGO_SERVICIO
FOR EACH ROW
BEGIN
  SELECT PAGO_SERVICIO_SQNC.NEXTVAL
  INTO   :new.id_pago
  FROM   dual;
END;
/
CREATE SEQUENCE PARROQUIA_SQNC START WITH 1;
/
CREATE OR REPLACE TRIGGER PARROQUIA_SECUENCIA
BEFORE INSERT ON PARROQUIA
FOR EACH ROW
BEGIN
  SELECT PARROQUIA_SQNC.NEXTVAL
  INTO   :new.id_parroquia
  FROM   dual;
END;
/
CREATE SEQUENCE SERVICIO_SQNC START WITH 1;
/
CREATE OR REPLACE TRIGGER SERVICIO_SECUENCIA
BEFORE INSERT ON SERVICIO
FOR EACH ROW
BEGIN
  SELECT SERVICIO_SQNC.NEXTVAL
  INTO   :new.id_servicio
  FROM   dual;
END;
/
CREATE SEQUENCE TARJETA_CREDITO_SQNC START WITH 1;
/
CREATE OR REPLACE TRIGGER TARJETA_CREDITO_SECUENCIA
BEFORE INSERT ON TARJETA_CREDITO
FOR EACH ROW
BEGIN
  SELECT TARJETA_CREDITO_SQNC.NEXTVAL
  INTO   :new.id_forma_pago
  FROM   dual;
END;
/
CREATE SEQUENCE USUARIO_SQNC START WITH 1;
/
CREATE OR REPLACE TRIGGER USUARIO_SECUENCIA
BEFORE INSERT ON USUARIO
FOR EACH ROW
BEGIN
  SELECT USUARIO_SQNC.NEXTVAL
  INTO   :new.id_usuario
  FROM   dual;
END;
/
CREATE SEQUENCE VEHICULO_SQNC START WITH 1;
/
CREATE OR REPLACE TRIGGER VEHICULO_SECUENCIA
BEFORE INSERT ON VEHICULO
FOR EACH ROW
BEGIN
  SELECT VEHICULO_SQNC.NEXTVAL
  INTO   :new.id_vehiculo
  FROM   dual;
END;
/
/
/
ALTER TABLE USUARIO ADD CONSTRAINT USUARIOCLIENTE_FK FOREIGN KEY (id_cli) REFERENCES CLIENTE(id_cliente);
/
ALTER TABLE USUARIO ADD CONSTRAINT USUARIOPARROQUIA_FK FOREIGN KEY (id_par) REFERENCES PARROQUIA(id_par);
/
ALTER TABLE FAVORITO ADD CONSTRAINT FAVORITOUSUARIO_FK1 FOREIGN KEY (id_us) REFERENCES USUARIO(id_usuario);
/
ALTER TABLE FAVORITO ADD CONSTRAINT FAVORITOCONDUCTOR_FK2 FOREIGN KEY (id_cond) REFERENCES CONDUCTOR(id_conductor);
/
ALTER TABLE HIST_MONEDERO_COND ADD CONSTRAINT HISTMONECONDUCTOR_FK FOREIGN KEY (id_cond) REFERENCES CONDUCTOR(id_conductor);
/
ALTER TABLE CONDUCTOR ADD CONSTRAINT CONDUCTORPARROQUIA_FK FOREIGN KEY (id_par) REFERENCES PARROQUIA(id_parroquia);
/
ALTER TABLE FOTO ADD CONSTRAINT FOTOVEHICULO_FK FOREIGN KEY (id_vehi) REFERENCES VEHICULO(id_vehiculo);
/
ALTER TABLE INSPECCION ADD CONSTRAINT INSPECCIONCOND_FK1 FOREIGN KEY (id_cond) REFERENCES CONDUCTOR(id_conductor);
/
ALTER TABLE INSPECCION ADD CONSTRAINT INSPECCIONVEHI_FK2 FOREIGN KEY (id_vehi) REFERENCES VEHICULO(id_vehiculo);
/
ALTER TABLE RUTA ADD CONSTRAINT RUTAPARO_FK1 FOREIGN KEY (id_par_origen) REFERENCES PARROQUIA(id_parroquia);
/
ALTER TABLE RUTA ADD CONSTRAINT RUTAPARD_FK2 FOREIGN KEY (id_par_destino) REFERENCES PARROQUIA(id_parroquia);
/
ALTER TABLE PAGO_SERVICIO ADD CONSTRAINT PAGOSERVICIO_FK1 FOREIGN KEY (id_serv,id_us,id_cond) REFERENCES SERVICIO(id_servicio,id_us,id_cond);
/
ALTER TABLE PAGO_SERVICIO ADD CONSTRAINT PAGOTDC_FK2 FOREIGN KEY (id_us,id_tdc) REFERENCES TARJETA_CREDITO(id_us,id_forma_pago);
/
ALTER TABLE PAGO_SERVICIO ADD CONSTRAINT PAGOMON_FK3 FOREIGN KEY (id_us,id_mon) REFERENCES MONEDERO_VIRTUAL(id_us,id_forma_pago);
/
ALTER TABLE TARJETA_CREDITO ADD CONSTRAINT TARJETAUSUARIO_FK FOREIGN KEY (id_us) REFERENCES USUARIO(id_usuario);
/
ALTER TABLE MONEDERO_VIRTUAL ADD CONSTRAINT MONEDEROUSUARIO_FK FOREIGN KEY (id_us) REFERENCES USUARIO(id_usuario);
/
ALTER TABLE HIST_MONEDERO ADD CONSTRAINT HISTMONMON_FK FOREIGN KEY (id_mon,id_us) REFERENCES MONEDERO_VIRTUAL(id_forma_pago,id_us);
/
ALTER TABLE HIST_MONEDERO ADD CONSTRAINT HISTMONTDC_FK FOREIGN KEY (id_tdc,id_us) REFERENCES TARJETA_CREDITO(id_forma_pago,id_us);
/
ALTER TABLE HIST_MONEDERO ADD CONSTRAINT HISTMONREC_FK FOREIGN KEY (id_mon_rec,id_us_rec) REFERENCES MONEDERO_VIRTUAL(id_forma_pago,id_us);
/
ALTER TABLE SERVICIO ADD CONSTRAINT SERVICIOUSUARIO_FK1 FOREIGN KEY (id_us) REFERENCES USUARIO(id_usuario);
/
ALTER TABLE SERVICIO ADD CONSTRAINT SERVICIOCONDUCTOR_FK2 FOREIGN KEY (id_cond) REFERENCES CONDUCTOR(id_conductor);
/
ALTER TABLE SERVICIO ADD CONSTRAINT SERVICIOHISTPRKM_FK3 FOREIGN KEY (id_hp_km) REFERENCES HIST_PRECIO_KM(id_precio);
/
ALTER TABLE SERVICIO ADD CONSTRAINT SERVICIORUTA_FK4 FOREIGN KEY (id_rutao,id_rutad) REFERENCES RUTA(id_par_origen,id_par_destino);
/
