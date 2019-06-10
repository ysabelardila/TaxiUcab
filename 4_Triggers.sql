/
CREATE OR REPLACE TRIGGER TGG_ACT_SALDO_CONDUCTOR
AFTER INSERT ON HIST_MONEDERO_COND
FOR EACH ROW
BEGIN
  IF :NEW.tipo = 'recarga' THEN
  UPDATE CONDUCTOR
  SET saldoactual = saldoactual + :NEW.cantidad
  WHERE id_conductor = :NEW.id_cond;
  ELSE
  UPDATE CONDUCTOR
  SET saldoactual = saldoactual - :NEW.cantidad
  WHERE id_conductor = :NEW.id_cond;
  END IF;
END;
/
HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
/
CREATE OR REPLACE TRIGGER TGG_ARCO_PAGO_SERVICIO
BEFORE INSERT ON PAGO_SERVICIO
FOR EACH ROW
BEGIN
    IF (:NEW.id_tdc IS NOT NULL) AND (:NEW.id_mon IS NOT NULL) THEN
      RAISE_APPLICATION_ERROR(-20000,'Debe seleccionarse un solo tipo de pago.');
    END IF;
    IF (:NEW.id_tdc IS NULL) AND (:NEW.id_mon IS NULL) THEN
      RAISE_APPLICATION_ERROR(-20001,'Debe seleccionarse al menos un tipo de pago.');
    END IF;
END;
/
CREATE OR REPLACE TRIGGER TGG_ACT_SALDO_MONEDERO
AFTER INSERT ON HIST_MONEDERO
FOR EACH ROW
BEGIN
  IF :NEW.tipo_recarga_consumo = 'recarga' THEN
    UPDATE MONEDERO_VIRTUAL
    SET saldoactual = saldoactual + :NEW.cantidad WHERE id_forma_pago=:NEW.id_mon;
  END IF; 
  IF :NEW.tipo_recarga_consumo = 'consumo' THEN
    UPDATE MONEDERO_VIRTUAL
    SET saldoactual = saldoactual - :NEW.cantidad WHERE id_forma_pago=:NEW.id_mon;
  END IF;
END;
/
CREATE OR REPLACE TRIGGER TGG_INS_CONSMON
BEFORE INSERT ON HIST_MONEDERO
FOR EACH ROW
DECLARE
  sal number;
BEGIN
  IF (:NEW.tipo_recarga_consumo = 'recarga') AND (:NEW.tipo_recarga = 'monedero') THEN
	IF (:NEW.id_mon_rec IS NOT NULL) AND (:NEW.id_us_rec IS NOT NULL) THEN
		IF (:NEW.id_mon_rec=:NEW.id_mon) OR (:NEW.id_us_rec=:NEW.id_us) THEN
			RAISE_APPLICATION_ERROR(-20002,'El monedero de destino y origen no pueden ser iguales.');
		ELSE
		    SELECT saldoactual INTO sal FROM MONEDERO_VIRTUAL where id_us=:NEW.id_us_rec;
		    IF ((sal-:NEW.cantidad) < 0) THEN
		      RAISE_APPLICATION_ERROR(-20000,'Saldo insuficiente en el monedero que recarga.');
		    ELSE
		      INSERT INTO HIST_MONEDERO VALUES (null,:NEW.cantidad,:NEW.fecha,'consumo','monedero',null,null,:NEW.id_mon_rec,null,null,null,:NEW.id_us_rec);
		    END IF;
		END IF;
	ELSE
		RAISE_APPLICATION_ERROR(-20001,'Los datos del monedero que recarga estan incompletos.');
	END IF;
  END IF;
END;
/
CREATE OR REPLACE TRIGGER TGG_MON_BANCO
BEFORE INSERT ON HIST_MONEDERO
FOR EACH ROW
BEGIN
  IF (:NEW.tipo_recarga_consumo = 'recarga') AND (:NEW.tipo_recarga = 'transferencia') THEN
    IF (:NEW.referencia IS NULL) OR (:NEW.banco_origen IS NULL) THEN
      RAISE_APPLICATION_ERROR(-20000,'Los datos bancarios estan incompletos.');
    END IF;
  END IF;
END;
/
CREATE OR REPLACE TRIGGER TGG_MON_TDC
BEFORE INSERT ON HIST_MONEDERO
FOR EACH ROW
BEGIN
  IF (:NEW.tipo_recarga_consumo = 'recarga') AND (:NEW.tipo_recarga = 'TDC') THEN
    IF (:NEW.id_tdc IS NULL) THEN
      RAISE_APPLICATION_ERROR(-20000,'La recarga por TDC debe estar referenciada.');
    END IF;
  END IF;
END;
/
CREATE OR REPLACE TRIGGER TGG_ACT_PRECIO_KM
BEFORE INSERT ON HIST_PRECIO_KM
FOR EACH ROW
BEGIN
  UPDATE HIST_PRECIO_KM
  SET activo = 'false' WHERE activo='true';
END;
/
CREATE OR REPLACE TRIGGER TGG_ARCO_HIST_MON
BEFORE INSERT ON HIST_MONEDERO
FOR EACH ROW
BEGIN
    IF (:NEW.tipo_recarga_consumo = 'recarga') AND (:NEW.tipo_recarga = 'TDC') AND (:NEW.id_tdc IS NOT NULL) THEN
    	IF ((:NEW.id_mon_rec IS NOT NULL) OR (:NEW.id_us_rec IS NOT NULL) OR (:NEW.referencia IS NOT NULL) OR (:NEW.banco_origen IS NOT NULL)) THEN
    		RAISE_APPLICATION_ERROR(-20000,'Debe seleccionarse un solo tipo de recarga.');
    	END IF;
    ELSIF (:NEW.tipo_recarga_consumo = 'recarga') AND (:NEW.tipo_recarga = 'monedero') AND (:NEW.id_mon_rec IS NOT NULL) AND (:NEW.id_us_rec IS NOT NULL) THEN
    	IF ((:NEW.id_tdc IS NOT NULL) OR (:NEW.referencia IS NOT NULL) OR (:NEW.banco_origen IS NOT NULL)) THEN
			RAISE_APPLICATION_ERROR(-20001,'Debe seleccionarse un solo tipo de recarga.');
		END IF;
    ELSIF (:NEW.tipo_recarga_consumo = 'recarga') AND (:NEW.tipo_recarga = 'transferencia') AND (:NEW.referencia IS NOT NULL) AND (:NEW.banco_origen IS NOT NULL) THEN
    	IF ((:NEW.id_tdc IS NOT NULL) OR (:NEW.id_mon_rec IS NOT NULL) OR (:NEW.id_us_rec IS NOT NULL)) THEN
    		RAISE_APPLICATION_ERROR(-20002,'Debe seleccionarse un solo tipo de recarga.');
    	END IF;
    END IF;
END;
/








