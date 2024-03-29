/
ALTER TABLE SERVICIO DROP CONSTRAINT SERVICIORUTA_FK4;
/
ALTER TABLE SERVICIO DROP CONSTRAINT SERVICIOHISTPRKM_FK3;
/
ALTER TABLE SERVICIO DROP CONSTRAINT SERVICIOCONDUCTOR_FK2;
/
ALTER TABLE SERVICIO DROP CONSTRAINT SERVICIOUSUARIO_FK1;
/
ALTER TABLE HIST_MONEDERO DROP CONSTRAINT HISTMONREC_FK;
/
ALTER TABLE HIST_MONEDERO DROP CONSTRAINT HISTMONTDC_FK;
/
ALTER TABLE HIST_MONEDERO DROP CONSTRAINT HISTMONMON_FK;
/
ALTER TABLE MONEDERO_VIRTUAL DROP CONSTRAINT MONEDEROUSUARIO_FK;
/
ALTER TABLE TARJETA_CREDITO DROP CONSTRAINT TARJETAUSUARIO_FK;
/
ALTER TABLE PAGO_SERVICIO DROP CONSTRAINT PAGOMON_FK3;
/
ALTER TABLE PAGO_SERVICIO DROP CONSTRAINT PAGOTDC_FK2;
/
ALTER TABLE PAGO_SERVICIO DROP CONSTRAINT PAGOSERVICIO_FK1;
/
ALTER TABLE RUTA DROP CONSTRAINT RUTAPARD_FK2;
/
ALTER TABLE RUTA DROP CONSTRAINT RUTAPARO_FK1;
/
ALTER TABLE INSPECCION DROP CONSTRAINT INSPECCIONVEHI_FK2;
/
ALTER TABLE INSPECCION DROP CONSTRAINT INSPECCIONCOND_FK1;
/
ALTER TABLE FOTO DROP CONSTRAINT FOTOVEHICULO_FK;
/
ALTER TABLE CONDUCTOR DROP CONSTRAINT CONDUCTORPARROQUIA_FK;
/
ALTER TABLE HIST_MONEDERO_COND DROP CONSTRAINT HISTMONECONDUCTOR_FK;
/
ALTER TABLE FAVORITO DROP CONSTRAINT FAVORITOCONDUCTOR_FK2;
/
ALTER TABLE FAVORITO DROP CONSTRAINT FAVORITOUSUARIO_FK1;
/
ALTER TABLE USUARIO DROP CONSTRAINT USUARIOPARROQUIA_FK;
/
ALTER TABLE USUARIO DROP CONSTRAINT USUARIOCLIENTE_FK;
/
/
/
DROP TRIGGER VEHICULO_SECUENCIA;
/
DROP SEQUENCE VEHICULO_SQNC;
/
DROP TRIGGER USUARIO_SECUENCIA;
/
DROP SEQUENCE USUARIO_SQNC;
/
DROP TRIGGER TARJETA_CREDITO_SECUENCIA;
/
DROP SEQUENCE TARJETA_CREDITO_SQNC;
/
DROP TRIGGER SERVICIO_SECUENCIA;
/
DROP SEQUENCE SERVICIO_SQNC;
/
DROP TRIGGER PARROQUIA_SECUENCIA;
/
DROP SEQUENCE PARROQUIA_SQNC;
/
DROP TRIGGER PAGO_SERVICIO_SECUENCIA;
/
DROP SEQUENCE PAGO_SERVICIO_SQNC;
/
DROP TRIGGER MONEDERO_VIRTUAL_SECUENCIA;
/
DROP SEQUENCE MONEDERO_VIRTUAL_SQNC;
/
DROP TRIGGER MONEDERO_COND_SECUENCIA ;
/
DROP SEQUENCE MONEDERO_COND_SQNC;
/
DROP TRIGGER INSPECCION_SECUENCIA;
/
DROP SEQUENCE INSPECCION_SQNC;
/
DROP TRIGGER HIST_PRECIO_SECUENCIA;
/
DROP SEQUENCE HIST_PRECIO_SQNC;
/
DROP TRIGGER HIST_MONEDERO_SECUENCIA;
/
DROP SEQUENCE HIST_MONEDERO_SQNC;
/
DROP TRIGGER FOTO_SECUENCIA;
/
DROP SEQUENCE FOTO_SQNC;
/
DROP TRIGGER CONDUCTOR_SECUENCIA;
/
DROP SEQUENCE CONDUCTOR_SQNC;
/
DROP TRIGGER CLIENTE_SECUENCIA;
/
DROP SEQUENCE CLIENTE_SQNC;
/
/
/
DROP TABLE VEHICULO;
/
DROP TABLE USUARIO;
/
DROP TABLE TARJETA_CREDITO;
/
DROP TABLE SERVICIO;
/
DROP TABLE RUTA;
/
DROP TABLE PARROQUIA;
/
DROP TABLE PAGO_SERVICIO;
/
DROP TABLE MONEDERO_VIRTUAL;
/
DROP TABLE HIST_MONEDERO_COND;
/
DROP TABLE INSPECCION;
/
DROP TABLE HIST_PRECIO_KM;
/
DROP TABLE HIST_MONEDERO;
/
DROP TABLE FOTO;
/
DROP TABLE FAVORITO;
/
DROP TABLE CONDUCTOR;
/
DROP TABLE CLIENTE;
/
/
/
DROP TYPE DIRECCION;
/
DROP TYPE DATOS;
/
DROP TYPE TELEFONO;
/
/
DROP DIRECTORY DIR_TAXI;





