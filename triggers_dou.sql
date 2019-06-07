/
CREATE OR REPLACE TRIGGER INSPECCION_APROBADO
AFTER UPDATE ON INSPECCION
FOR EACH ROW
DECLARE
  id_update VEHICULO.id_vehiculo%type;
  CURSOR vehiculo_aprobado is
    SELECT id_vehiculo
    FROM VEHICULO v, INSPECCION i
    WHERE v.estatus = 'activo'
    AND v.id_vehiculo = i.id_vehi
    AND i.id_cond = :NEW.id_cond;
BEGIN
  OPEN vehiculo_aprobado;
  IF :NEW.aprobado = 'si' THEN
    IF vehiculo_aprobado%FOUND THEN
      FETCH vehiculo_aprobado into id_update;
      UPDATE VEHICULO
      SET estatus = 'inactivo'
      WHERE id_vehiculo = id_update;
    END IF;
    UPDATE VEHICULO
    SET estatus = 'activo'
    WHERE id_vehiculo = :NEW.id_vehi;
  END IF;
  CLOSE vehiculo_aprobado;
END;
/
CREATE OR REPLACE TRIGGER ACTUALIZAR_SALDO_CONDUCTOR
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
